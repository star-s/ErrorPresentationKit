//
//  UIAlertController+ErrorPresentation.h
//  Pods
//
//  Created by Sergey Starukhin on 07/11/2018.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Error)

+ (instancetype)alertWithError:(NSError *)error handler:(void (^ __nullable)(NSInteger recoveryOptionIndex))handler;;

@end

NS_ASSUME_NONNULL_END

#endif
