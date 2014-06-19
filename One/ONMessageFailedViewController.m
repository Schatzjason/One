//
//  ONMessageFailedViewController.m
//  One
//
//  Created by Jason Schatz on 6/12/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONMessageFailedViewController.h"
#import "ONModel.h"

@interface ONMessageFailedViewController ()

@end

@implementation ONMessageFailedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tryAgainButton.alpha = 0.0f;
    self.anotherPictureButton.alpha = 0.0f;
    
    [self.tryAgainButton setTitle: @"Send Again" forState: UIControlStateNormal];
    [self.anotherPictureButton setTitle: @"Take Another Picture" forState: UIControlStateNormal];
}

- (void) viewDidAppear:(BOOL)animated {
    [UIView animateKeyframesWithDuration: 0.3 delay:0.3 options: UIViewKeyframeAnimationOptionBeginFromCurrentState animations: ^{
        self.tryAgainButton.alpha = 1.0f;
        self.anotherPictureButton.alpha = 1.0f;
    } completion: nil];
}


- (IBAction)tryAgainButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)anotherPictureButtonClicked:(id)sender {
    [ONModel sharedInstance].image = nil;
    [self.navigationController popViewControllerAnimated: YES];
}

@end
