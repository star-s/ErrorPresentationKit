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

- (void)presentError:(NSError *)error
      modalForWindow:(UIWindow *)window
            delegate:(nullable id)delegate
  didPresentSelector:(nullable SEL)didPresentSelector
         contextInfo:(nullable void *)contextInfo;

@end

#else

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSApplication (ErrorPresentation)

- (void)presentError:(NSError *)error didPresentHandler:(void (^)(BOOL recovered))handler;

@end

NS_ASSUME_NONNULL_END

#endif
