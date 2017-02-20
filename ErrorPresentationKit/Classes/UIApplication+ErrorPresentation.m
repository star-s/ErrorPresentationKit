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

- (void)presentError:(NSError *)anError
{
    [self presentError: anError delegate: nil didPresentSelector: NULL contextInfo: NULL];
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
            void (^actionHandler)(UIAlertAction *);
            
            if (delegate) {
                actionHandler = ^(UIAlertAction *action){
                    //
                    id recoverer = [theErrorToPresent recoveryAttempter];
                    
                    [recoverer attemptRecoveryFromError: theErrorToPresent
                                            optionIndex: idx
                                               delegate: delegate
                                     didRecoverSelector: didPresentSelector
                                            contextInfo: contextInfo];
                };
            } else {
                actionHandler = ^(UIAlertAction *action){
                    //
                    id recoverer = [theErrorToPresent recoveryAttempter];
                    
                    [recoverer attemptRecoveryFromError: theErrorToPresent
                                            optionIndex: idx];
                };
            }
            UIAlertAction *action = [UIAlertAction actionWithTitle: title
                                                             style: idx == 0 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault
                                                           handler: actionHandler];
            [alert addAction: action];
        }];
        
        if (alert.actions.count == 0) {
            //
            EPKRecoveryOption *defaultOption = [EPKRecoveryOption okRecoveryOption];
            
            void (^handler)(UIAlertAction *action) = delegate ? ^(UIAlertAction *action){
                //
                EPKRecoveryAgent *recoverer = [[EPKRecoveryAgent alloc] init];
                
                [recoverer addRecoveryOption: defaultOption];
                
                [recoverer attemptRecoveryFromError: theErrorToPresent
                                        optionIndex: 0
                                           delegate: delegate
                                 didRecoverSelector: didPresentSelector
                                        contextInfo: contextInfo];

            } : NULL;
            
            [alert addAction: [UIAlertAction actionWithTitle: defaultOption.title style: UIAlertActionStyleCancel handler: handler]];
        }
        [self.keyWindow.rootViewController presentViewController: alert animated: YES completion: NULL];
    }
}

@end
