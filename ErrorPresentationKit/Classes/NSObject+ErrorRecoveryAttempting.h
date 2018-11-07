//
//  NSObject+ErrorRecoveryAttempting.h
//  Pods
//
//  Created by Sergey Starukhin on 07/11/2018.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ErrorRecoveryAttempting)

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex resultHandler:(void (^)(BOOL recovered))handler;

@end

NS_ASSUME_NONNULL_END
