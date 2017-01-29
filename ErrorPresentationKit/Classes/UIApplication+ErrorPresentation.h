//
//  UIApplication+ErrorPresentation.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplicationDelegateWithErrorPresentation <UIApplicationDelegate>

@optional

- (NSError *)application:(UIApplication *)application willPresentError:(NSError *)error;

@end

@interface UIApplication (ErrorPresentation)

- (NSError *)willPresentError:(NSError *)error;

- (void)presentError:(NSError *)anError;

- (void)presentError:(NSError *)error delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo;

@end
