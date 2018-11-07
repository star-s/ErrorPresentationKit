//
//  Responder+ErrorPresentationLegacy.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 23.05.2018.
//

#import "Responder+ErrorPresentationLegacy.h"
#import "NSInvocation+RecoveryDelegate.h"
#import "UIResponder+ErrorPresentation.h"

#if TARGET_OS_IPHONE

@implementation UIResponder (ErrorPresentationLegacy)

- (void)presentError:(NSError *)anError
{
    [self presentError: anError didPresentHandler: NULL];
}

#else
@implementation NSResponder (ErrorPresentationLegacy)
#endif

- (void)presentError:(NSError *)error delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
{
    [self presentError: error didPresentHandler: ^(BOOL recovered) {
        [[NSInvocation invocationWithRecoveryDelegate: delegate didRecoverSelector: didPresentSelector] invokeWithRecoveryResult: recovered contextInfo: contextInfo];
    }];
}

@end
