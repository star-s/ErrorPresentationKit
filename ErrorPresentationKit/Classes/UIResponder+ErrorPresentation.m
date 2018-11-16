//
//  UIResponder+ErrorPresentation.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "UIResponder+ErrorPresentation.h"
#import "Responder+ErrorPresentation.h"

#if TARGET_OS_IPHONE

@implementation UIResponder (ErrorPresentationAdditions)

- (void)presentError:(NSError *)error
      modalForWindow:(UIWindow *)window
            delegate:(id)delegate
  didPresentSelector:(SEL)didPresentSelector
         contextInfo:(void *)contextInfo
{
    [self.nextResponder presentError: [self willPresentError: error]
                      modalForWindow: window
                            delegate: delegate
                  didPresentSelector: didPresentSelector
                         contextInfo: contextInfo];
}

- (NSError *)willPresentError:(NSError *)error
{
    return error;
}

- (void)presentError:(NSError *)anError
{
    [self presentError: anError didPresentHandler: NULL];
}

- (void)presentError:(NSError *)error
            delegate:(id)delegate
  didPresentSelector:(SEL)didPresentSelector
         contextInfo:(void *)contextInfo
{
    [self.nextResponder presentError: error
                            delegate: delegate
                  didPresentSelector: didPresentSelector
                         contextInfo: contextInfo];
}

@end

#endif
