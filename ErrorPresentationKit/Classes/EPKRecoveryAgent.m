//
//  EPKRecoveryAgent.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "EPKRecoveryAgent.h"

@implementation EPKAbstractRecoveryAgent

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex contextInfo:(void **)contextInfo
{
    return NO;
}

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex
{
    return [self attemptRecoveryFromError: error optionIndex: recoveryOptionIndex contextInfo: NULL];
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo
{
    BOOL recoveryResult = [self attemptRecoveryFromError: error optionIndex: recoveryOptionIndex contextInfo: &contextInfo];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: [delegate methodSignatureForSelector: didRecoverSelector]];
    
    [invocation setSelector: didRecoverSelector];
    
    [invocation setArgument: &recoveryResult atIndex: 2];
    [invocation setArgument: &contextInfo    atIndex: 3];
    
    [invocation invokeWithTarget: delegate];
}

@end

@implementation EPKBlockRecoveryAgent

- (instancetype)initWithRecoveryBlock:(EPKRecoveryBlock)block
{
    self = [super init];
    if (self) {
        _recoveryBlock = [block copy];
    }
    return self;
}

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex contextInfo:(void **)contextInfo
{
    return self.recoveryBlock ? self.recoveryBlock(error, recoveryOptionIndex, contextInfo) : NO;
}

@end
