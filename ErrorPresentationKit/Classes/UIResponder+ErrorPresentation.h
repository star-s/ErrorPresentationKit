//
//  UIResponder+ErrorPresentation.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (ErrorPresentation)

- (NSError *)willPresentError:(NSError *)error;

- (BOOL)presentError:(NSError *)anError;

- (void)presentError:(NSError *)error delegate:(nullable id)delegate didPresentSelector:(nullable SEL)didPresentSelector contextInfo:(nullable void *)contextInfo;

@end
