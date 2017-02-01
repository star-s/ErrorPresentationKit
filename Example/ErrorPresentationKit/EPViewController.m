//
//  EPViewController.m
//  ErrorPresentationKit
//
//  Created by Sergey Starukhin on 01/28/2017.
//  Copyright (c) 2017 Sergey Starukhin. All rights reserved.
//

#import "EPViewController.h"

@import ErrorPresentationKit;

@interface EPViewController ()

@end

@implementation EPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - IBActions

- (IBAction)doIt:(UIButton *)sender
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    userInfo[NSLocalizedDescriptionKey] = @"Something went wrong";
    userInfo[NSLocalizedRecoverySuggestionErrorKey] = @"please try again";
    
    userInfo[NSLocalizedRecoveryOptionsErrorKey] = @[@"Try", @"Stop trying"];
    
    userInfo[NSRecoveryAttempterErrorKey] = [[EPKBlockRecoveryAgent alloc] initWithRecoveryBlock: ^BOOL(NSError *error, NSUInteger recoveryOptionIndex, void **context) {
        //
        NSString *option = error.localizedRecoveryOptions[recoveryOptionIndex];
        
        NSLog(@"You choose %@", option);
        
        BOOL result = [@"Stop trying" isEqualToString: option];
        
        if (context && !result) {
            *context = (__bridge void *)error;
        }
        return result;
    }];
    NSError *error = [NSError errorWithDomain: NSStringFromClass(self.class) code: -1 userInfo: userInfo];
    
    [self presentError: error
              delegate: self
    didPresentSelector: @selector(didPresentErrorWithRecovery:contextInfo:)
           contextInfo: NULL];
}

#pragma mark -

- (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo
{
    NSError *recoveryError = (__bridge NSError *)(contextInfo);
    
    if (didRecover) {
        //
        NSLog(@"Error recovered!");
        
    } else if ([recoveryError isKindOfClass: [NSError class]]) {
        //
        [self presentError: recoveryError delegate: self didPresentSelector: _cmd contextInfo: contextInfo];
        
    } else {
        NSLog(@"Error not recovered!");
    }
}

@end
