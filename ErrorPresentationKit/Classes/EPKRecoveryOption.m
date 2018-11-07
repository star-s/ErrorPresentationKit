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

@interface EPKBlockRecoveryOption ()

@property (atomic, getter=isRecoveryComplete) BOOL recoveryComplete;

@end

@implementation EPKBlockRecoveryOption

+ (instancetype)recoveryOptionWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block
{
    return [[self alloc] initWithTitle: title recoveryBlock: block];
}

- (instancetype)initWithTitle:(NSString *)title recoveryBlock:(EPKRecoveryBlock)block
{
    NSParameterAssert(block != nil);
    self = [super initWithTitle: title];
    if (self) {
        _recoveryBlock = [block copy];
    }
    return self;
}

- (BOOL)recoveryFromError:(NSError *)error contextInfo:(void **)contextInfo
{
    return self.recoveryBlock(error, contextInfo);
}

@end
