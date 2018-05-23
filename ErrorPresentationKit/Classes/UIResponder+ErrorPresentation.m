//
//  UIResponder+ErrorPresentation.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "UIResponder+ErrorPresentation.h"

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

- (BOOL)presentError:(NSError *)error
{
    return [self.nextResponder presentError: [self willPresentError: error]];
}

- (NSError *)willPresentError:(NSError *)error
{
    return error;
}

@end

#endif
