//
//  UIResponder+ErrorPresentation.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "UIResponder+ErrorPresentation.h"

@implementation UIResponder (ErrorPresentation)

- (NSError *)willPresentError:(NSError *)error
{
    return error;
}

- (BOOL)presentError:(NSError *)anError
{
    return [self.nextResponder presentError: [self willPresentError: anError]];
}

- (void)presentError:(NSError *)error delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
{
    [self.nextResponder presentError: [self willPresentError: error]
                            delegate: delegate
                  didPresentSelector: didPresentSelector
                         contextInfo: contextInfo];
}

@end
