//
//  Responder+ErrorPresentationLegacy.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 23.05.2018.
//

#import "Responder+ErrorPresentationLegacy.h"

#if TARGET_OS_IPHONE
#import "UIResponder+ErrorPresentation.h"

@implementation UIResponder (ErrorPresentationLegacy)
#else
@implementation NSResponder (ErrorPresentationLegacy)
#endif

- (void)presentError:(NSError *)anError
{
    [self presentError: anError
        modalForWindow: nil
              delegate: nil
    didPresentSelector: NULL
           contextInfo: NULL];
}

- (void)presentError:(NSError *)error delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
{
    [self presentError: error
        modalForWindow: nil
              delegate: delegate
    didPresentSelector: didPresentSelector
           contextInfo: contextInfo];
}

- (void)presentError:(NSError *)error didPresentHandler:(void (^)(BOOL recovered))handler;
{
#if TARGET_OS_IPHONE
    [self.nextResponder presentError: [self willPresentError: error] didPresentHandler: handler];
#else
    dispatch_async(dispatch_get_main_queue(), ^{
        handler ? handler([self presentError: error]) : [self presentError: error];
    });
#endif
}

@end
