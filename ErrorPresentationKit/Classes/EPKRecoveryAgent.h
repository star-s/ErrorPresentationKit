//
//  EPKRecoveryAgent.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPKAbstractRecoveryAgent : NSObject

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex;

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo;

@end

typedef BOOL(^EPKRecoveryBlock)(NSError *error, NSUInteger recoveryOptionIndex);

@interface EPKBlockRecoveryAgent : EPKAbstractRecoveryAgent

@property (nonatomic, copy, readonly) EPKRecoveryBlock recoveryBlock;

- (instancetype)initWithRecoveryBlock:(EPKRecoveryBlock)block;

@end
