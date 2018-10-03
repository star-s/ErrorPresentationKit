//
//  UIResponder+ErrorPresentation.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

@interface UIResponder (ErrorPresentation)

/* Present an error alert to the user. When the user has dismissed the alert and any recovery possible for the error and chosen by the user has been attempted, send the selected message to the specified delegate. The method selected by didPresentSelector must have the same signature as:
 
 - (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo;
 
 The default implementation of this method always invokes [self willPresentError:error] to give subclassers an opportunity to customize error presentation. It then forwards the message, passing the customized error, to the next responder or, if there is no next responder, UIApplication. UIApplication's override of this method invokes [[NSAlert alertWithError:errorToPresent] beginSheetModalForWindow:window modalDelegate:self didEndSelector:selectorForAPrivateMethod contextInfo:privateContextInfo]. When the user has dismissed the alert, the error's recovery attempter is sent an -attemptRecoveryFromError:optionIndex:delegate:didRecoverSelector:contextInfo: message, if the error had recovery options and a recovery delegate.
 
 Errors for which ([[error domain] isEqualToString:NSCocoaErrorDomain] && [error code]==NSUserCancelledError) are a special case,  because they do not actually represent errors and should not be presented as such to the user. UIApplication's override of this method does not present an alert to the user for these kinds of errors. Instead it merely invokes the delegate specifying didRecover==NO.
 
 Between the responder chain in a typical application and various overrides of this method in UIKit classes, objects are given the opportunity to present errors in orders like these:
 
 For windows owned by documents:
 view -> superviews -> view controller -> window ->  application delegate -> application
 
 For windows that have window controllers but aren't associated with documents:
 view -> superviews -> window -> window controller -> application
 
 For windows that have no window controller at all:
 view -> superviews -> window -> application
 
 You can invoke this method to present error alert sheets. For example, Cocoa's own -[NSDocument saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:] invokes this method when it's just invoked -saveToURL:ofType:forSaveOperation:completionHandler: and that method has signalled an error.
 
 You probably shouldn't override this method, because you have no way of reliably predicting whether this method vs. -presentError will be invoked for any particular error. You should instead override the -willPresentError: method described below.
 */
- (void)presentError:(NSError *)error modalForWindow:(nullable UIWindow *)window delegate:(nullable id)delegate didPresentSelector:(nullable SEL)didPresentSelector contextInfo:(nullable void *)contextInfo;

/* Present an error alert to the user, as an application-modal panel, and return YES if error recovery was done, NO otherwise. This method behaves much like the previous one except it does not return until the user has dismissed the alert and, if the error had recovery options and a recovery delegate, the error's recovery delegate has been sent an -attemptRecoveryFromError:optionIndex: message.
 
 You can invoke this method to present error alert dialog boxes.
 
 You probably shouldn't override this method, because you have no way of reliably predicting whether this method vs. -presentError:modalForWindow:delegate:didPresentSelector:contextInfo: will be invoked for any particular error. You should instead override the -willPresentError: method described below.
 */
//- (BOOL)presentError:(NSError *)error;

/* Given that the receiver is about to present an error (perhaps by just forwarding it to the next responder), return the error that should actually be presented. The default implementation of this method merely returns the passed-in error.
 
 You can override this method to customize the presentation of errors by examining the passed-in error and if, for example, its localized description or recovery information is unsuitably generic, returning a more specific one. When you override this method always check the NSError's domain and code to discriminate between errors whose presentation you want to customize and those you don't. For those you don't just return [super willPresentError:error]. Don't make decisions based on the NSError's localized description, recovery suggestion, or recovery options because it's usually not a good idea to try to parse localized text.
 */
- (NSError *)willPresentError:(NSError *)error;

@end

#endif
