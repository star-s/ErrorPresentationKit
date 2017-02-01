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
    [self presentError: anError delegate: nil didPresentSelector: NULL contextInfo: NULL];
}

- (void)presentError:(NSError *)error delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
{
    NSError *theErrorToPresent = [self willPresentError: error];
    
    if (theErrorToPresent) {
        
        id recoverer = [theErrorToPresent recoveryAttempter];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: theErrorToPresent.localizedDescription
                                                                       message: recoverer ? theErrorToPresent.localizedRecoverySuggestion : nil
                                                                preferredStyle: UIAlertControllerStyleAlert];
        
        if (recoverer == nil) {
            recoverer = [[EPKAbstractRecoveryAgent alloc] init];
        }
        void (^actionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            //
            NSInteger optionIndex = [theErrorToPresent.localizedRecoveryOptions indexOfObject: action.title];
            
            if (delegate) {
                //
                [recoverer attemptRecoveryFromError: theErrorToPresent
                                        optionIndex: optionIndex
                                           delegate: delegate
                                 didRecoverSelector: didPresentSelector
                                        contextInfo: contextInfo];
            } else {
                //
                [recoverer attemptRecoveryFromError: theErrorToPresent
                                        optionIndex: optionIndex];
            }
        };
        [theErrorToPresent.localizedRecoveryOptions enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            UIAlertAction *action = [UIAlertAction actionWithTitle: title
                                                             style: idx == 0 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault
                                                           handler: actionHandler];
            [alert addAction: action];
        }];
        
        if (alert.actions.count == 0) {
            //
            [alert addAction: [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: actionHandler]];
        }
        [self.keyWindow.rootViewController presentViewController: alert animated: YES completion: NULL];
    }
}

@end
