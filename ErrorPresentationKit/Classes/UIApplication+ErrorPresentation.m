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

@interface EPKAlertAction : UIAlertAction

@property (nonatomic, readonly) NSInteger index;

+ (instancetype)actionWithTitle:(nullable NSString *)title index:(NSInteger)idx handler:(void (^ __nullable)(EPKAlertAction *action))handler;

@end

@implementation EPKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title index:(NSInteger)idx handler:(void (^)(EPKAlertAction *))handler
{
    EPKAlertAction *result = [self actionWithTitle: title
                                             style: idx == 0 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault
                                           handler: (void (^ __nullable)(UIAlertAction *action))handler];
    result->_index = idx;
    return result;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    EPKAlertAction *result = [super copyWithZone: zone];
    result->_index = self.index;
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
        void (^alertAction)(EPKAlertAction *);
        
        if (delegate) {
            //
            if (recoverer == nil) {
                recoverer = [[EPKAbstractRecoveryAgent alloc] init];
            }
            alertAction = ^(EPKAlertAction *action){
                //
                [recoverer attemptRecoveryFromError: theErrorToPresent
                                        optionIndex: action.index
                                           delegate: delegate
                                 didRecoverSelector: didPresentSelector
                                        contextInfo: contextInfo];
            };
        } else {
            //
            alertAction = ^(EPKAlertAction *action){
                //
                [recoverer attemptRecoveryFromError: theErrorToPresent
                                        optionIndex: action.index];
            };
        }
        [theErrorToPresent.localizedRecoveryOptions enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(NSString * _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            [alert addAction: [EPKAlertAction actionWithTitle: title index: idx handler: alertAction]];
        }];
        
        if (alert.actions.count == 0) {
            //
            [alert addAction: [EPKAlertAction actionWithTitle: @"OK" index: 0 handler: alertAction]];
        }
        [self.keyWindow.rootViewController presentViewController: alert animated: YES completion: NULL];
    }
}

@end
