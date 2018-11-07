//
//  NSInvocation+RecoveryDelegate.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 03/10/2018.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (RecoveryDelegate)

+ (instancetype)invocationWithRecoveryDelegate:(id)delegate
                            didRecoverSelector:(SEL)didRecoverSelector;

- (void)invokeWithRecoveryResult:(BOOL)result contextInfo:(nullable void *)contextInfo;

@end
