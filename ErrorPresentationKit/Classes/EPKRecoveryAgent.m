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
#import "NSObject+ErrorRecoveryAttempting.h"

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
    return [self initWithRecoverySuggestion: suggestion background: NO];
}

- (instancetype)initWithRecoverySuggestion:(NSString *)suggestion background:(BOOL)flag
{
    self = [super init];
    if (self) {
        _recoveryInBackground = flag;
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

 -(NSError *)injectIntoError:(NSError *)error
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary: error.userInfo];
    
    if (self.recoverySuggestion) {
        userInfo[NSLocalizedRecoverySuggestionErrorKey] = self.recoverySuggestion;
    }
    userInfo[NSLocalizedRecoveryOptionsErrorKey] = self.recoveryOptionsTitles;
    userInfo[NSRecoveryAttempterErrorKey] = self;
    
    return [[[error class] alloc] initWithDomain: error.domain code: error.code userInfo: userInfo];
}

#pragma mark - Attempt Recovery From Error

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex
{
    return [self.options[recoveryOptionIndex] recoveryFromError: error contextInfo: NULL];
}

- (void)attemptRecoveryFromError:(NSError *)error
                     optionIndex:(NSUInteger)recoveryOptionIndex
                        delegate:(id)delegate
              didRecoverSelector:(SEL)didRecoverSelector
                     contextInfo:(void *)contextInfo
{
    NSInvocation *invocation = [NSInvocation invocationWithRecoveryDelegate: delegate didRecoverSelector: didRecoverSelector];
    [invocation invokeWithRecoveryResult: [self.options[recoveryOptionIndex] recoveryFromError: error contextInfo: &contextInfo]
                             contextInfo: contextInfo];
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex resultHandler:(void (^)(BOOL))handler
{
    if (self.recoveryInBackground) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL recoveryResult = [self attemptRecoveryFromError: error optionIndex: recoveryOptionIndex];
            dispatch_async(dispatch_get_main_queue(), ^{
                handler ? handler(recoveryResult) : NULL;
            });
        });
    } else {
        [super attemptRecoveryFromError: error optionIndex: recoveryOptionIndex resultHandler: handler];
    }
}

@end
