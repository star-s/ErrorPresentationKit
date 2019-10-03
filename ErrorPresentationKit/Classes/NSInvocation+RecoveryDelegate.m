//
//  NSInvocation+RecoveryDelegate.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 03/10/2018.
//

#import "NSInvocation+RecoveryDelegate.h"

@implementation NSInvocation (RecoveryDelegate)

+ (instancetype)invocationWithRecoveryDelegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector
{
    NSInvocation *invocation = delegate ? [self invocationWithMethodSignature: [delegate methodSignatureForSelector: didRecoverSelector]] : nil;
    [invocation setSelector: didRecoverSelector];
    [invocation setTarget: delegate];
    return invocation;
}

- (void)invokeWithRecoveryResult:(BOOL)result contextInfo:(void *)context
{
    [self setArgument: &result  atIndex: 2];
    [self setArgument: &context atIndex: 3];
    
    [self invoke];
}

@end
