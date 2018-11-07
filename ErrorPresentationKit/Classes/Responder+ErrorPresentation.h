//
//  Responder+ErrorPresentation.h
//  Pods
//
//  Created by Sergey Starukhin on 07/11/2018.
//

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define Responder UIResponder
#else
    #import <AppKit/AppKit.h>
    #define Responder NSResponder
#endif

NS_ASSUME_NONNULL_BEGIN

@interface Responder (ErrorPresentation)

- (void)presentError:(NSError *)error didPresentHandler:(void (^__nullable)(BOOL recovered))handler;

- (void)dismissError;

@end

NS_ASSUME_NONNULL_END
