//
//  ONAppDelegate.m
//  One
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONAppDelegate.h"
#import "ONModel.h"
#import "ONWelcomeViewController.h"
#import "ONLayoutViewController.h"
#import "ONRecipientsViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>

#define kRecipientsViewController @"ONRecipientsViewController"
#define kBackgroundViewController @"ONBackgroundViewController"
#define kCongratulationsViewController @"ONCongratulationsViewController"
#define kNotificationsViewController @"ONNotificationsViewController"
#define kGetStartedViewController @"ONGetStartedViewController"

@implementation ONAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Determine the first view, based on model state

    ONModel *model = [ONModel sharedInstance];
    NSArray *controllers;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
    UIViewController *firstController;
    UIViewController *backgroundController = [mainStoryboard instantiateViewControllerWithIdentifier: kBackgroundViewController];
    
    if (model.state == ONStateNotConfigured) {
        firstController = [mainStoryboard instantiateViewControllerWithIdentifier: kRecipientsViewController];
        controllers = @[backgroundController, firstController];
    }
    
    else if (model.state == ONStateConfiguredButZero) {
        firstController = [mainStoryboard instantiateViewControllerWithIdentifier: kGetStartedViewController];
        controllers = @[backgroundController, firstController];
    }
    
    else {
        controllers = @[backgroundController];
    }
    
    // Check to see that the device is capable
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    BOOL hasMessages = [MFMessageComposeViewController canSendText];
    
    if (!(hasCamera && hasMessages)) {
        firstController = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONNOTextViewController"];
        controllers = @[firstController];
    }

    // Set the View Controller
    UINavigationController* navController = (UINavigationController*) _window.rootViewController;
    [navController setViewControllers: controllers];

    // load the image picker
    [ONAppDelegate sharedImagePickerController];
    
    return YES;
}

- (void) scheduleNotificationStartingTomorrow {
    NSCalendar* calendar;
    NSDateComponents* components;
    UILocalNotification *notification;
    NSInteger hour;
    
    calendar = [NSCalendar currentCalendar];
    components = [calendar components: NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    // find an hour between 9:00am and 8:00pm
    hour = components.hour - 1;
    if (components.hour < 9) components.hour = 9;
    if (components.hour > 20) components.hour = 20;
    
    notification = [[UILocalNotification alloc] init];
    
    if (notification == nil) {
        NSLog(@"*** unable to create notification ***");
        return;
    }
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.repeatInterval = NSDayCalendarUnit;
    notification.alertBody = @"Don't forget today's picture";
    notification.fireDate = [calendar dateFromComponents: components];
    
    // Cancel all previous notifications, and create a new one tomorrow
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
    //[[UIApplication sharedApplication] presentLocalNotificationNow: notification];

}

+ (UIImagePickerController*) sharedImagePickerController {
    static UIImagePickerController* sharedPicker;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedPicker = [[UIImagePickerController alloc] init];
        sharedPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        sharedPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        sharedPicker.allowsEditing = NO;
    });
    
    return sharedPicker;
}

+ (MFMessageComposeViewController*) sharedMessageController {
    static MFMessageComposeViewController* shared;
    static dispatch_once_t once;
    
    //dispatch_once(&once, ^{
        shared = [[MFMessageComposeViewController alloc] init];
    //});
    
    return shared;
}

@end
