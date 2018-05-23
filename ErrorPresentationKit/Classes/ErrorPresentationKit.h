//
//  ErrorPresentationKit.h
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 29.01.17.
//  Copyright © 2017 Sergey Starukhin. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

//! Project version number for ErrorPresentationKit.
FOUNDATION_EXPORT double ErrorPresentationKitVersionNumber;

//! Project version string for ErrorPresentationKit.
FOUNDATION_EXPORT const unsigned char ErrorPresentationKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ErrorPresentationKit/PublicHeader.h>
#import <ErrorPresentationKit/EPKRecoveryAgent.h>
#import <ErrorPresentationKit/EPKRecoveryOption.h>
#import <ErrorPresentationKit/UIApplication+ErrorPresentation.h>
#import <ErrorPresentationKit/UIResponder+ErrorPresentation.h>
#import <ErrorPresentationKit/Responder+ErrorPresentationLegacy.h>
