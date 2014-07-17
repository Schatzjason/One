//
//  ONAppDelegate.m
//  One
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONAppDelegate.h"
#import "ONModel.h"
#import "ONLayoutViewController.h"
#import "ONRecipientsViewController.h"
#import "ONCongratulationsViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>

#define kRecipientsViewController @"ONRecipientsViewController"
#define kBackgroundViewController @"ONBackgroundViewController"
#define kCongratulationsViewController @"ONCongratulationsViewController"
#define kNotificationsViewController @"ONNotificationsViewController"
#define kGetStartedViewController @"ONGetStartedViewController"
#define kNoTextViewController @"ONNoTextViewController"
#define kLogTableViewControler @"ONLogViewController"
#define kSettingsTableViewController @"ONSettingsTableViewController"


@implementation ONAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Determine the first view, based on model state

    ONModel *model = [ONModel sharedInstance];
    NSArray *controllers;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
    UIViewController *firstController;
    UIViewController *backgroundController = [mainStoryboard instantiateViewControllerWithIdentifier: kBackgroundViewController];
    
    // If the reset recipient switch has been set in the settings bundle, reset. 
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"resetReceiver"]) {
        [[NSUserDefaults standardUserDefaults] setBool: NO forKey: @"resetReceiver"];
        
        model.state = ONStateNotConfigured;
    }
    
    // Temporary Rigging
    if (NO) {
        UIViewController *c1 = [mainStoryboard instantiateViewControllerWithIdentifier: kCongratulationsViewController];
        //UIViewController *c2 = [mainStoryboard instantiateViewControllerWithIdentifier: kLogTableViewControler];
        //UIViewController *c3 = [mainStoryboard instantiateViewControllerWithIdentifier: kSettingsTableViewController];
        
        [model pictureTakenOnDate: [NSDate date]];
        model.needsCelebration = YES;
        controllers = @[backgroundController, c1]; //, c2, c3];
    }
    
    else if (model.state == ONStateNotConfigured) {
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
        firstController = [mainStoryboard instantiateViewControllerWithIdentifier: kNoTextViewController];
        controllers = @[firstController];
    } else {
        // load the image picker
        [ONAppDelegate sharedImagePickerController];
    }

    // Set the View Controller
    UINavigationController* navController = (UINavigationController*) _window.rootViewController;
    [navController setViewControllers: controllers];

    return YES;
}

- (void) scheduleNotificationStartingTomorrow {
    NSCalendar* calendar;
    NSDateComponents* components;
    UILocalNotification *notification;
    ONModel *model = [ONModel sharedInstance];
    NSString *body = [NSString stringWithFormat: @"don't forget picture %ld for %@", (long) model.count + 1, model.recipientNickname];
    
    NSLog(@"notification body: %@", body);
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
    notification.alertBody = body;
    notification.fireDate = [calendar dateFromComponents: components];
    
    // Cancel all previous notifications, and create a new one tomorrow
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
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
    
    UIImagePickerControllerCameraDevice device = (UIImagePickerControllerCameraDevice) [ONModel sharedInstance].cameraDevice;
    
    if (device > 0) {
        sharedPicker.cameraDevice = device;
    }
    
    return sharedPicker;
}

static MFMessageComposeViewController* _cachedMessageViewController;

// Not a singleton. This oportunistic loading allows for experimenting with the timing of
// Creating the view controller

+ (MFMessageComposeViewController*) cachedMessageViewController {
    
    if (_cachedMessageViewController == nil) {
        _cachedMessageViewController = [[MFMessageComposeViewController alloc] init];
    }
    
    return _cachedMessageViewController;
}

+ (void) clearCachedMessageViewController {
    _cachedMessageViewController = nil;
}

- (void) applicationWillEnterForeground:(UIApplication *)application {

    // set the notifications
    [ONModel sharedInstance].useNotifications = [[NSUserDefaults standardUserDefaults] boolForKey: @"useNotifications"];
}


@end
