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
    
    userInfo[NSLocalizedRecoveryOptionsErrorKey] = @[@"Yes", @"No", @"Maybe"];
    
    userInfo[NSRecoveryAttempterErrorKey] = [[EPKBlockRecoveryAgent alloc] initWithRecoveryBlock: ^BOOL(NSError *error, NSUInteger recoveryOptionIndex) {
        //
        NSString *option = error.localizedRecoveryOptions[recoveryOptionIndex];
        NSLog(@"You choose %@", option);
        return ![@"No" isEqualToString: option];
    }];
    NSError *error = [NSError errorWithDomain: NSStringFromClass(self.class) code: -1 userInfo: userInfo];
    
    [self presentError: error
              delegate: self
    didPresentSelector: @selector(didPresentErrorWithRecovery:contextInfo:)
           contextInfo: (__bridge void *)(sender)];
}

#pragma mark -

- (void)didPresentErrorWithRecovery:(BOOL)didRecover contextInfo:(void *)contextInfo
{
    UIButton *button = (__bridge UIButton *)(contextInfo);
    
    if (didRecover) {
        [button setTitle: @"Do it again!" forState: UIControlStateNormal];
    } else {
        [button setEnabled: NO];
    }
}

@end
