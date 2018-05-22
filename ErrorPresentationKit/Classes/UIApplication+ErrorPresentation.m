//
//  UIApplication+ErrorPresentation.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "UIApplication+ErrorPresentation.h"
#import "UIResponder+ErrorPresentation.h"
#import "EPKRecoveryAgent.h"
#import "EPKRecoveryOption.h"

@interface NSError (CheckForCancel)

- (BOOL)epk_isCancelError;

@end

@implementation NSError (CheckForCancel)

- (BOOL)epk_isCancelError
{
    BOOL result = NO;
    
    if ([self.domain isEqualToString: NSCocoaErrorDomain]) {
        //
        result = self.code == NSUserCancelledError;
        
    } else if ([self.domain isEqualToString: NSURLErrorDomain]) {
        
        result = self.code == NSURLErrorCancelled;
    }
    return result;
}

@end

@implementation UIApplication (ErrorPresentation)

- (NSError *)willPresentError:(NSError *)error
{
    NSError *theErrorToPresent = nil;
    
    id <ApplicationDelegateWithErrorPresentation> delegate = (id <ApplicationDelegateWithErrorPresentation>)self.delegate;
    
    if ([delegate respondsToSelector: @selector(application:willPresentError:)]) {
        
        theErrorToPresent = [delegate application: self willPresentError: error];
    } else {
        theErrorToPresent = [super willPresentError: error];
    }
    return [theErrorToPresent epk_isCancelError] ? nil : theErrorToPresent;
}

- (BOOL)presentError:(NSError *)anError
{
    __block BOOL result = NO;
    __block BOOL jobsDone = NO;

    NSError *theErrorToPresent = [self willPresentError: anError];
    
    if (theErrorToPresent) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: theErrorToPresent.localizedDescription
                                                                       message: [theErrorToPresent recoveryAttempter] ? theErrorToPresent.localizedRecoverySuggestion : nil
                                                                preferredStyle: UIAlertControllerStyleAlert];
        
        [theErrorToPresent.localizedRecoveryOptions enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            void (^actionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                //
                id recoverer = [theErrorToPresent recoveryAttempter];
                result = [recoverer attemptRecoveryFromError: theErrorToPresent optionIndex: idx];
                jobsDone = YES;
            };
            UIAlertAction *action = [UIAlertAction actionWithTitle: title
                                                             style: idx == 0 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault
                                                           handler: actionHandler];
            [alert addAction: action];
        }];
        
        if (alert.actions.count == 0) {
            //
            EPKRecoveryAgent *recoverer = [[EPKRecoveryAgent alloc] init];
            [recoverer addRecoveryOption:  [EPKRecoveryOption okRecoveryOption]];

            void (^handler)(UIAlertAction *action) = ^(UIAlertAction *action){
                result = [recoverer attemptRecoveryFromError: theErrorToPresent optionIndex: 0];
                jobsDone = YES;
            };
            
            [alert addAction: [UIAlertAction actionWithTitle: recoverer.recoveryOptionsTitles.firstObject style: UIAlertActionStyleCancel handler: handler]];
        }
        UIViewController *presenter = self.delegate.window.rootViewController;
        while (presenter.presentedViewController) {
            presenter = presenter.presentedViewController;
        }
        [presenter presentViewController: alert animated: YES completion: NULL];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        do {
            [runLoop runMode: runLoop.currentMode beforeDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
        } while (!jobsDone);
    }
    return result;
}

- (void)presentError:(NSError *)error delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
{
    NSError *theErrorToPresent = [self willPresentError: error];
    
    if (theErrorToPresent) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: theErrorToPresent.localizedDescription
                                                                       message: [theErrorToPresent recoveryAttempter] ? theErrorToPresent.localizedRecoverySuggestion : nil
                                                                preferredStyle: UIAlertControllerStyleAlert];
        
        [theErrorToPresent.localizedRecoveryOptions enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            void (^actionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                //
                id recoverer = [theErrorToPresent recoveryAttempter];
                
                [recoverer attemptRecoveryFromError: theErrorToPresent
                                        optionIndex: idx
                                           delegate: delegate
                                 didRecoverSelector: didPresentSelector
                                        contextInfo: contextInfo];
            };
            UIAlertAction *action = [UIAlertAction actionWithTitle: title
                                                             style: idx == 0 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault
                                                           handler: actionHandler];
            [alert addAction: action];
        }];
        
        if (alert.actions.count == 0) {
            //
            EPKRecoveryAgent *recoverer = [[EPKRecoveryAgent alloc] init];
            [recoverer addRecoveryOption:  [EPKRecoveryOption okRecoveryOption]];
            
            void (^handler)(UIAlertAction *action) = ^(UIAlertAction *action){
                //
                [recoverer attemptRecoveryFromError: theErrorToPresent
                                        optionIndex: 0
                                           delegate: delegate
                                 didRecoverSelector: didPresentSelector
                                        contextInfo: contextInfo];
            };
            [alert addAction: [UIAlertAction actionWithTitle: recoverer.recoveryOptionsTitles.firstObject style: UIAlertActionStyleCancel handler: handler]];
        }
        UIViewController *presenter = self.delegate.window.rootViewController;
        while (presenter.presentedViewController) {
            presenter = presenter.presentedViewController;
        }
        [presenter presentViewController: alert animated: YES completion: NULL];
    } else {
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: [delegate methodSignatureForSelector: didPresentSelector]];
        
        [invocation setSelector: didPresentSelector];
        
        BOOL recoveryResult = NO;
        [invocation setArgument: &recoveryResult atIndex: 2];
        [invocation setArgument: &contextInfo    atIndex: 3];
        
        [invocation performSelector: @selector(invokeWithTarget:) withObject: delegate afterDelay: 0.0];
    }
}

@end
