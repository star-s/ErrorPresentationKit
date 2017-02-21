//
//  EPKRecoveryAgent.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EPKRecoveryOption;

NS_ASSUME_NONNULL_BEGIN

@interface EPKRecoveryAgent : NSObject

@property (nullable, readonly, copy) NSString *recoverySuggestion;

@property (nonatomic, readonly) NSArray <NSString *> *recoveryOptionsTitles;

- (instancetype)initWithRecoverySuggestion:(NSString * _Nullable)suggestion;

- (void)addRecoveryOption:(EPKRecoveryOption *)option;

@end

@interface NSError (RecoveryAgentInjection)

- (NSError *)errorWithAdditionRecoveryAgent:(EPKRecoveryAgent *)agent;

@end

NS_ASSUME_NONNULL_END
