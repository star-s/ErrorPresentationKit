//
//  UIApplication+ErrorPresentation.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "UIApplication+ErrorPresentation.h"
#import "UIResponder+ErrorPresentation.h"
#import "EPKRecoveryAgent.h"
#import "EPKRecoveryOption.h"

@interface NSError (CheckForCancel)

@property (nonatomic, readonly) BOOL epk_isCancelledError;

@end

@implementation NSError (CheckForCancel)

- (BOOL)epk_isCancelledError
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
    return theErrorToPresent;
}

- (void)presentError:(NSError *)error didPresentHandler:(void (^)(BOOL recovered))handler;
{
    NSError *theErrorToPresent = [self willPresentError: error];
    
    if (theErrorToPresent && ![theErrorToPresent epk_isCancelledError]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: theErrorToPresent.localizedDescription
                                                                       message: [theErrorToPresent recoveryAttempter] ? theErrorToPresent.localizedRecoverySuggestion : nil
                                                                preferredStyle: UIAlertControllerStyleAlert];
        
        [theErrorToPresent.localizedRecoveryOptions enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            UIAlertAction *action = [UIAlertAction actionWithTitle: title
                                                             style: idx == 0 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault
                                                           handler: ^(UIAlertAction *action){
                                                               id recoverer = [theErrorToPresent recoveryAttempter];
                                                               BOOL recoveryResult = [recoverer attemptRecoveryFromError: theErrorToPresent optionIndex: idx];
                                                               handler ? handler(recoveryResult) : NULL;
                                                           }];
            [alert addAction: action];
        }];
        
        if (alert.actions.count == 0) {
            //
            EPKRecoveryAgent *recoverer = [[EPKRecoveryAgent alloc] init];
            [recoverer addRecoveryOption:  [EPKRecoveryOption okRecoveryOption]];

            UIAlertAction *action = [UIAlertAction actionWithTitle: recoverer.recoveryOptionsTitles.firstObject
                                                             style: UIAlertActionStyleCancel
                                                           handler: ^(UIAlertAction *action){
                                                               BOOL recoveryResult = [recoverer attemptRecoveryFromError: theErrorToPresent optionIndex: 0];
                                                               handler ? handler(recoveryResult) : NULL;
                                                           }];
            [alert addAction: action];
        }
        UIViewController *presenter = self.keyWindow.rootViewController;
        while (presenter.presentedViewController) {
            presenter = presenter.presentedViewController;
        }
        [presenter presentViewController: alert animated: YES completion: NULL];
    }
}

- (void)presentError:(NSError *)error modalForWindow:(UIWindow *)window delegate:(nullable id)delegate didPresentSelector:(nullable SEL)didPresentSelector contextInfo:(nullable void *)contextInfo
{
    NSError *theErrorToPresent = [self willPresentError: error];
    
    if (theErrorToPresent && ![theErrorToPresent epk_isCancelledError]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: theErrorToPresent.localizedDescription
                                                                       message: [theErrorToPresent recoveryAttempter] ? theErrorToPresent.localizedRecoverySuggestion : nil
                                                                preferredStyle: UIAlertControllerStyleAlert];
        
        [theErrorToPresent.localizedRecoveryOptions enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            UIAlertAction *action = [UIAlertAction actionWithTitle: title
                                                             style: idx == 0 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault
                                                           handler: ^(UIAlertAction *action){
                                                               id recoverer = [theErrorToPresent recoveryAttempter];
                                                               [recoverer attemptRecoveryFromError: theErrorToPresent
                                                                                       optionIndex: idx
                                                                                          delegate: delegate
                                                                                didRecoverSelector: didPresentSelector
                                                                                       contextInfo: contextInfo];
                                                           }];
            [alert addAction: action];
        }];
        
        if (alert.actions.count == 0) {
            //
            EPKRecoveryAgent *recoverer = [[EPKRecoveryAgent alloc] init];
            [recoverer addRecoveryOption:  [EPKRecoveryOption okRecoveryOption]];
            
            UIAlertAction *action =  [UIAlertAction actionWithTitle: recoverer.recoveryOptionsTitles.firstObject
                                                              style: UIAlertActionStyleCancel
                                                            handler: ^(UIAlertAction *action){
                                                                [recoverer attemptRecoveryFromError: theErrorToPresent
                                                                                        optionIndex: 0
                                                                                           delegate: delegate
                                                                                 didRecoverSelector: didPresentSelector
                                                                                        contextInfo: contextInfo];
                                                            }];
            [alert addAction: action];
        }
        if (!window) {
            window = [self keyWindow];
        }
        UIViewController *presenter = window.rootViewController;
        while (presenter.presentedViewController) {
            presenter = presenter.presentedViewController;
        }
        [presenter presentViewController: alert animated: YES completion: NULL];
    }
}

@end

#endif
