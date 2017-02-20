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
    NSError *error = [NSError errorWithDomain: NSStringFromClass(self.class) code: -1 userInfo: @{NSLocalizedDescriptionKey: @"Something went wrong"}];
    
    [self presentError: error
              delegate: self
    didPresentSelector: @selector(didPresentErrorWithRecovery:contextInfo:)
           contextInfo: NULL];
}

#pragma mark -

- (NSError *)willPresentError:(NSError *)error
{
    NSError *result = nil;
    
    if ([error.domain isEqualToString: NSStringFromClass(self.class)]) {
        //
        EPKRecoveryAgent *agent = [[EPKRecoveryAgent alloc] initWithRecoverySuggestion: @"please try again"];
        
        [agent addRecoveryOption: [EPKBlockRecoveryOption recoveryOptionWithTitle: @"Try" recoveryBlock: ^BOOL(NSError * _Nonnull error, void **contextInfo) {
            //
            if (contextInfo) {
                *contextInfo = (__bridge_retained void *)error;
            }
            return NO;
        }]];
        
        [agent addRecoveryOption: [EPKBlockRecoveryOption recoveryOptionWithTitle: @"Stop trying" recoveryBlock: ^BOOL(NSError * _Nonnull error, void **contextInfo) {
            //
            return YES;
        }]];
        
        result = [error errorWithAdditionRecoveryAgent: agent];
    } else {
        result = [super willPresentError: error];
    }
    return result;
}

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
