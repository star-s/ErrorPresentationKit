//
//  UIResponder+ErrorPresentation.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "UIResponder+ErrorPresentation.h"

#if TARGET_OS_IPHONE

@implementation UIResponder (ErrorPresentation)

- (void)presentError:(NSError *)error
      modalForWindow:(nullable UIWindow *)window
            delegate:(nullable id)delegate
  didPresentSelector:(nullable SEL)didPresentSelector
         contextInfo:(nullable void *)contextInfo
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

#else
@implementation NSResponder (ErrorPresentation)
#endif

- (void)presentError:(NSError *)error didPresentHandler:(void (^)(BOOL recovered))handler;
{
    [self.nextResponder presentError: [self willPresentError: error] didPresentHandler: handler];
}

- (void)dismissError
{
    [self.nextResponder dismissError];
}

@end
