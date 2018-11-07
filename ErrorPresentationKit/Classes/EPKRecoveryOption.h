//
//  EPKRecoveryOption.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 20.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPKAbstractRecoveryOption : NSObject

@property (nonnull, readonly) NSString *title;

@property (nonatomic, readonly) BOOL recoveryInBackground;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTitle:(NSString *)title;

- (BOOL)recoveryFromError:(NSError *)error;

@end

@interface EPKRecoveryOption : EPKAbstractRecoveryOption

@property (nonatomic, readonly) BOOL recoveryResult;

- (instancetype)initWithTitle:(NSString *)title recoveryResult:(BOOL)result;

+ (instancetype)okRecoveryOption;

+ (instancetype)cancelRecoveryOption;

@end

typedef BOOL(^EPKRecoveryBlock)(NSError *error);

@interface EPKBlockRecoveryOption : EPKAbstractRecoveryOption

@property (nonatomic, copy, readonly) EPKRecoveryBlock recoveryBlock;

+ (instancetype)recoveryOptionWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block;

- (instancetype)initWithTitle:(NSString *)title NS_UNAVAILABLE;

- (instancetype)initWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block;

@end

@interface EPKBackgroundRecoveryOption : EPKBlockRecoveryOption

@end

NS_ASSUME_NONNULL_END
