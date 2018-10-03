//
//  Responder+ErrorPresentationLegacy.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 23.05.2018.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@interface UIResponder (ErrorPresentationLegacy)
#else
#import <AppKit/AppKit.h>

@interface NSResponder (ErrorPresentationLegacy)
#endif

- (void)presentError:(NSError *)anError;

- (void)presentError:(NSError *)error
            delegate:(nullable id)delegate
  didPresentSelector:(nullable SEL)didPresentSelector
         contextInfo:(nullable void *)contextInfo DEPRECATED_MSG_ATTRIBUTE("Don't use this method");

@end
