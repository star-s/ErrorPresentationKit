//
//  UIAlertController+ErrorPresentation.m
//  Pods
//
//  Created by Sergey Starukhin on 07/11/2018.
//

#if TARGET_OS_IPHONE

#import "UIAlertController+Error.h"

@implementation UIAlertController (Error)

+ (instancetype)alertWithError:(NSError *)error handler:(void (^)(NSInteger))handler
{
    UIAlertController *alert = [self alertControllerWithTitle: error.localizedDescription
                                                      message: [error recoveryAttempter] ? error.localizedRecoverySuggestion : nil
                                               preferredStyle: UIAlertControllerStyleAlert];
    
    [error.localizedRecoveryOptions enumerateObjectsWithOptions: NSEnumerationReverse usingBlock: ^(NSString *title, NSUInteger idx, BOOL *stop) {
        UIAlertActionStyle style = idx == 0 ? UIAlertActionStyleCancel : UIAlertActionStyleDefault;
        [alert addAction: [UIAlertAction actionWithTitle: title style: style handler: handler ? ^(UIAlertAction *action){
            handler(idx);
        } : NULL]];
    }];
    if (alert.actions.count == 0) {
        [alert addAction: [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: handler ? ^(UIAlertAction *action){
            handler(0);
        } : NULL]];
    }
    return alert;
}

@end

#endif
