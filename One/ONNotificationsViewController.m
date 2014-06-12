//
//  ONNotificationsViewController.m
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONNotificationsViewController.h"
#import "UIColor+AppColors.h"

@interface ONNotificationsViewController ()

@end

@implementation ONNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appMediumColor];
    self.takeFirstPictureButton.alpha = 0.0f;
}

- (IBAction)remindMeButtonClicked:(id)sender {
    [UIView animateWithDuration: 0.3 animations: ^ {
        self.remindMeButton.alpha = 0.0f;
        self.noThanksButton.alpha = 0.0f;
        self.takeFirstPictureButton.alpha = 1.0f;
    }];
}

- (IBAction)noThanksButtonClicked:(id)sender {
    [UIView animateWithDuration: 0.3 animations: ^ {
        self.remindMeButton.alpha = 0.0f;
        self.noThanksButton.alpha = 0.0f;
        self.takeFirstPictureButton.alpha = 1.0f;
    }];
}

@end
