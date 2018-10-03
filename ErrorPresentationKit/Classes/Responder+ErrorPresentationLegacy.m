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
    [self presentError: anError didPresentHandler: NULL];
}

- (void)presentError:(NSError *)error delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
{
    [self presentError: error
        modalForWindow: nil
              delegate: delegate
    didPresentSelector: didPresentSelector
           contextInfo: contextInfo];
}

@end
