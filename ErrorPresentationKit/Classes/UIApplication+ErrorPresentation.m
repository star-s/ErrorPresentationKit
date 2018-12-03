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
#import "NSObject+ErrorRecoveryAttempting.h"

#if TARGET_OS_IPHONE

#import "UIAlertController+Error.h"

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

- (void)presentError:(NSError *)anError
{
    [self presentError: anError didPresentHandler: NULL];
}

- (void)presentError:(NSError *)error didPresentHandler:(void (^)(BOOL recovered))handler;
{
    NSError *theErrorToPresent = [self willPresentError: error];
    
    if (theErrorToPresent && ![theErrorToPresent epk_isCancelledError]) {
        
        id recoverer = [theErrorToPresent recoveryAttempter];
        if (!recoverer) {
            EPKRecoveryAgent *agent = [[EPKRecoveryAgent alloc] init];
            [agent addRecoveryOption:  [EPKRecoveryOption okRecoveryOption]];
            recoverer = agent;
        }
        UIAlertController *alert = [UIAlertController alertWithError: theErrorToPresent handler: ^(NSInteger recoveryOptionIndex) {
            [recoverer attemptRecoveryFromError: theErrorToPresent optionIndex: recoveryOptionIndex resultHandler: ^(BOOL recovered) {
                handler ? handler(recovered) : NULL;
            }];
        }];
        UIViewController *presenter = self.keyWindow.rootViewController;
        while (presenter.presentedViewController) {
            presenter = presenter.presentedViewController;
        }
        [presenter presentViewController: alert animated: YES completion: NULL];
    }
}

- (void)presentError:(NSError *)error
      modalForWindow:(UIWindow *)window
            delegate:(id)delegate
  didPresentSelector:(SEL)didPresentSelector
         contextInfo:(void *)contextInfo
{
    NSError *theErrorToPresent = [self willPresentError: error];
    
    if (theErrorToPresent && ![theErrorToPresent epk_isCancelledError]) {
        
        id recoverer = [theErrorToPresent recoveryAttempter];
        if (!recoverer) {
            EPKRecoveryAgent *agent = [[EPKRecoveryAgent alloc] init];
            [agent addRecoveryOption:  [EPKRecoveryOption okRecoveryOption]];
            recoverer = agent;
        }
        UIAlertController *alert = [UIAlertController alertWithError: theErrorToPresent handler: ^(NSInteger recoveryOptionIndex) {
            //
            [recoverer attemptRecoveryFromError: theErrorToPresent
                                    optionIndex: recoveryOptionIndex
                                       delegate: delegate
                             didRecoverSelector: didPresentSelector
                                    contextInfo: contextInfo];
        }];
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

- (void)presentError:(NSError *)error
            delegate:(id)delegate
  didPresentSelector:(SEL)didPresentSelector
         contextInfo:(void *)contextInfo
{
    [self presentError: error
        modalForWindow: self.keyWindow
              delegate: delegate
    didPresentSelector: didPresentSelector
           contextInfo: contextInfo];
}

@end

#else

@implementation NSApplication (ErrorPresentation)

- (void)presentError:(NSError *)error didPresentHandler:(void (^)(BOOL))handler
{
    NSError *theErrorToPresent = [self willPresentError: error];
    
    if (theErrorToPresent) {
        
        id recoverer = [theErrorToPresent recoveryAttempter];
        if (!recoverer) {
            EPKRecoveryAgent *agent = [[EPKRecoveryAgent alloc] init];
            [agent addRecoveryOption:  [EPKRecoveryOption okRecoveryOption]];
            recoverer = agent;
        }
        NSAlert *alert = [NSAlert alertWithError: theErrorToPresent];
        [recoverer attemptRecoveryFromError: error optionIndex: [alert runModal] resultHandler: handler];
    }
}

@end

#endif
