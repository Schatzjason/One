//
//  ONNotificationsViewController.m
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONNotificationsViewController.h"
#import "UIColor+AppColors.h"
#import "ONModel.h"
#import "ONAppDelegate.h"

@interface ONNotificationsViewController ()
- (void) transition;
@end

@implementation ONNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.promptLabel.text = @"If you forget to send a picture:";
    [self.remindMeButton setTitle: @"Send a reminder" forState: UIControlStateNormal];
    [self.noThanksButton setTitle: @"No Reminders" forState: UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor appLightColor];
    self.takeFirstPictureButton.alpha = 0.0f;
}

- (IBAction)remindMeButtonClicked:(id)sender {
    ONModel *model = [ONModel sharedInstance];;
    ONAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    model.useNotifications = YES;
    [delegate scheduleNotificationStartingTomorrow];
    
    [self transition];
}

- (IBAction)noThanksButtonClicked:(id)sender {
    ONModel *model = [ONModel sharedInstance];
    model.useNotifications = NO;
    
    [self transition];
}

- (void) transition {
    [ONModel sharedInstance].state = ONStateConfiguredButZero;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
    UIViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONGetStartedViewController"];
    [self.navigationController pushViewController: controller animated: YES];
}

@end
