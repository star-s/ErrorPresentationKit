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

- (void)presentError:(NSError *)anError
{
    NSError *theErrorToPresent = [self willPresentError: anError];
    
    if (theErrorToPresent) {
        [self.nextResponder presentError: theErrorToPresent];
    }
}

- (void)presentError:(NSError *)error delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
{
    NSError *theErrorToPresent = [self willPresentError: error];
    
    if (theErrorToPresent) {
        [self.nextResponder presentError: theErrorToPresent delegate: delegate didPresentSelector: didPresentSelector contextInfo: contextInfo];
    }
}

@end
