//
//  EPKRecoveryOption.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 20.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPKRecoveryOption : NSObject

@property (nonnull, readonly) NSString *title;

+ (instancetype)okRecoveryOption;

+ (instancetype)cancelRecoveryOption;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTitle:(NSString *)title;

- (BOOL)recoveryFromError:(NSError *)error contextInfo:(void **)contextInfo;

@end

typedef BOOL(^EPKRecoveryBlock)(NSError *error, void **contextInfo);

@interface EPKBlockRecoveryOption : EPKRecoveryOption

@property (nonatomic, copy, readonly) EPKRecoveryBlock recoveryBlock;

+ (instancetype)recoveryOptionWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block;

- (instancetype)initWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block;

@end

NS_ASSUME_NONNULL_END
