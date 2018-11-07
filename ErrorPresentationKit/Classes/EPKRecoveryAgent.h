//
//  EPKRecoveryAgent.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EPKAbstractRecoveryOption;

NS_ASSUME_NONNULL_BEGIN

@interface EPKRecoveryAgent : NSObject

@property (nonatomic, readonly) BOOL recoveryInBackground;

@property (nullable, readonly, copy) NSString *recoverySuggestion;

@property (nonatomic, readonly) NSArray <NSString *> *recoveryOptionsTitles;

- (instancetype)initWithRecoverySuggestion:(nullable NSString *)suggestion;

- (instancetype)initWithRecoverySuggestion:(nullable NSString *)suggestion background:(BOOL)flag;

- (void)addRecoveryOption:(EPKAbstractRecoveryOption *)option;

- (NSError *)injectIntoError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
