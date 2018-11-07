//
//  Responder+ErrorPresentation.m
//  Pods
//
//  Created by Sergey Starukhin on 07/11/2018.
//

#import "Responder+ErrorPresentation.h"
#if TARGET_OS_IPHONE
#import "UIResponder+ErrorPresentation.h"
#endif

@implementation Responder (ErrorPresentation)

- (void)presentError:(NSError *)error didPresentHandler:(void (^)(BOOL recovered))handler;
{
    [self.nextResponder presentError: [self willPresentError: error] didPresentHandler: handler];
}

- (void)dismissError
{
    [self.nextResponder dismissError];
}

@end
