//
//  UIApplication+ErrorPresentation.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@protocol ApplicationDelegateWithErrorPresentation <UIApplicationDelegate>

@optional

- (NSError *)application:(UIApplication *)application willPresentError:(NSError *)error;

@end

@interface UIApplication (ErrorPresentation)

- (NSError *)willPresentError:(NSError *)error;

//- (BOOL)presentError:(NSError *)anError;

- (void)presentError:(NSError *)error
      modalForWindow:(nullable UIWindow *)window
            delegate:(nullable id)delegate
  didPresentSelector:(nullable SEL)didPresentSelector
         contextInfo:(nullable void *)contextInfo;

@end

#endif
