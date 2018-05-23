//
//  EPKRecoveryOption.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 20.02.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#import "EPKRecoveryOption.h"

@implementation EPKAbstractRecoveryOption

- (instancetype)initWithTitle:(NSString *)title
{
    NSParameterAssert(title.length > 0);
    self = [super init];
    if (self) {
        _title = [title copy];
    }
    return self;
}

- (BOOL)recoveryFromError:(NSError *)error contextInfo:(void **)contextInfo
{
    [NSException raise: NSInvalidArgumentException format: @"*** -%@ only defined for abstract class. Define %s!", NSStringFromSelector(_cmd), __PRETTY_FUNCTION__];
    return NO;
}

@end

@implementation EPKRecoveryOption

+ (instancetype)okRecoveryOption
{
    return [[self alloc] initWithTitle: NSLocalizedString(@"OK", @"ErrorPresentationKit OK button title")];
}

+ (instancetype)cancelRecoveryOption
{
    return [[self alloc] initWithTitle: NSLocalizedString(@"Cancel", @"ErrorPresentationKit Cancel button title")];
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle: title recoveryResult: NO];
}

- (instancetype)initWithTitle:(NSString *)title recoveryResult:(BOOL)result
{
    self = [super initWithTitle: title];
    if (self) {
        _recoveryResult = result;
    }
    return self;
}

- (BOOL)recoveryFromError:(NSError *)error contextInfo:(void **)contextInfo
{
    return self.recoveryResult;
}

@end

@implementation EPKBlockRecoveryOption

+ (instancetype)recoveryOptionWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block
{
    return [[self alloc] initWithTitle: title recoveryBlock: block];
}

+ (instancetype)backgroundRecoveryOptionWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block
{
    return [[self alloc] initWithTitle: title recoveryBlock: block backgroundExecute: YES];
}

- (instancetype)initWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block
{
    return [self initWithTitle: title recoveryBlock: block backgroundExecute: NO];
}

- (instancetype)initWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block backgroundExecute:(BOOL)background
{
    NSParameterAssert(block != nil);
    self = [super initWithTitle: title];
    if (self) {
        _recoveryBlock = [block copy];
        _backgroundExecute = background;
    }
    return self;
}

- (BOOL)recoveryFromError:(NSError *)error contextInfo:(void **)contextInfo
{
    if (self.backgroundExecute) {
        //
        __block BOOL result = NO;
        __block BOOL jobsDone = NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            result = self.recoveryBlock(error, contextInfo);
            jobsDone = YES;
        });
        do {
            NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
            [runLoop runMode: runLoop.currentMode beforeDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
        } while (!jobsDone);
        return result;
    } else {
        return self.recoveryBlock(error, contextInfo);
    }
}

@end
