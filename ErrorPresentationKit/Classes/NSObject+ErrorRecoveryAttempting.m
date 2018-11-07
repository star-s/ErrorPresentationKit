//
//  NSObject+ErrorRecoveryAttempting.m
//  Pods
//
//  Created by Sergey Starukhin on 07/11/2018.
//

#import "NSObject+ErrorRecoveryAttempting.h"
#import <objc/runtime.h>

@interface PrivateRecoveryDelegate : NSObject

@property (nonatomic, weak, readonly) id owner;
@property (nonatomic, copy) void (^handler)(BOOL);

- (instancetype)initOwner:(id)owner resultHandler:(void (^)(BOOL))handler;

- (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo;

@end

@implementation PrivateRecoveryDelegate

- (instancetype)initOwner:(id)owner resultHandler:(void (^)(BOOL))handler
{
    self = [super init];
    if (self) {
        _owner = owner;
        self.handler = handler;
        objc_setAssociatedObject(owner, (__bridge const void *)(self), self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return self;
}

- (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo
{
    self.handler(didRecover);
    objc_setAssociatedObject(self.owner, (__bridge const void *)(self), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation NSObject (ErrorRecoveryAttempting)

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex resultHandler:(void (^)(BOOL))handler
{
    if ([self respondsToSelector: @selector(attemptRecoveryFromError:optionIndex:)]) {
        handler([self attemptRecoveryFromError: error optionIndex: recoveryOptionIndex]);
    } else if ([self respondsToSelector: @selector(attemptRecoveryFromError:optionIndex:delegate:didRecoverSelector:contextInfo:)]) {
        [self attemptRecoveryFromError: error
                           optionIndex: recoveryOptionIndex
                              delegate: [[PrivateRecoveryDelegate alloc] initOwner: self resultHandler: handler]
                    didRecoverSelector: @selector(didPresentErrorWithRecovery:contextInfo:)
                           contextInfo: NULL];
    } else {
        handler(NO);
    }
}

@end
