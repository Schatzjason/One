//
//  ONGetStartedViewController.m
//  One
//
//  Created by Jason Schatz on 6/12/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONGetStartedViewController.h"
#import "UIColor+AppColors.h"
#import "ONModel.h"

@interface ONGetStartedViewController ()

@end

@implementation ONGetStartedViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.promptLabel.text = @"You are ready to go.";
    [self.button setTitle: @"Take the first picture" forState: UIControlStateNormal];
    self.view.backgroundColor = [UIColor appLightColor];
}

- (IBAction)buttonClicked:(id)sender {
    [ONModel sharedInstance].state = ONStateConfiguredUpAndRunning;

    [UIView animateWithDuration: 0.5 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.navigationController popToRootViewControllerAnimated: YES];
    }];
}

@end
