//
//  EPKRecoveryAgent.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "EPKRecoveryAgent.h"
#import "EPKRecoveryOption.h"
#import "NSInvocation+RecoveryDelegate.h"

@implementation NSError (RecoveryAgentInjection)

- (NSError *)errorWithAdditionRecoveryAgent:(EPKRecoveryAgent *)agent
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary: self.userInfo];
    
    if (agent.recoverySuggestion) {
        userInfo[NSLocalizedRecoverySuggestionErrorKey] = agent.recoverySuggestion;
    }
    userInfo[NSLocalizedRecoveryOptionsErrorKey] = agent.recoveryOptionsTitles;
    userInfo[NSRecoveryAttempterErrorKey] = agent;
    
    return [self.class errorWithDomain: self.domain code: self.code userInfo: userInfo];
}

@end

@interface EPKRecoveryAgent ()

@property (nonatomic, readonly) NSArray <__kindof EPKAbstractRecoveryOption *> *options;

@end

@implementation EPKRecoveryAgent

- (instancetype)init
{
    return [self initWithRecoverySuggestion: nil];
}

- (instancetype)initWithRecoverySuggestion:(NSString *)suggestion
{
    self = [super init];
    if (self) {
        _recoverySuggestion = [suggestion copy];
        _options = @[];
    }
    return self;
}

- (NSArray <NSString *> *)recoveryOptionsTitles
{
    return [self.options valueForKey: @"title"];
}

- (void)addRecoveryOption:(EPKRecoveryOption *)option
{
    _options = [_options arrayByAddingObject: option];
}

#pragma mark - Attempt Recovery From Error

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex
{
    return [self.options[recoveryOptionIndex] recoveryFromError: error contextInfo: NULL];
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo
{
    NSInvocation *invocation = [NSInvocation invocationWithRecoveryDelegate: delegate didRecoverSelector: didRecoverSelector];
    [invocation invokeWithRecoveryResult: [self.options[recoveryOptionIndex] recoveryFromError: error contextInfo: &contextInfo]
                             contextInfo: contextInfo];
}

@end
