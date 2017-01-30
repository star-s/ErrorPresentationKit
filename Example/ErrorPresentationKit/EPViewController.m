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

- (IBAction)doIt:(UIButton *)sender
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    userInfo[NSLocalizedDescriptionKey] = @"Something went wrong";
    userInfo[NSLocalizedRecoverySuggestionErrorKey] = @"please try again";
    
    userInfo[NSLocalizedRecoveryOptionsErrorKey] = @[@"Yes", @"No", @"Maybe"];
    
    userInfo[NSRecoveryAttempterErrorKey] = [[EPKBlockRecoveryAgent alloc] initWithRecoveryBlock: ^BOOL(NSError *error, NSUInteger recoveryOptionIndex) {
        //
        NSLog(@"You choose %@", error.localizedRecoveryOptions[recoveryOptionIndex]);
        return NO;
    }];
    NSError *error = [NSError errorWithDomain: NSStringFromClass(self.class) code: -1 userInfo: userInfo];
    [self presentError: error];
}

@end
