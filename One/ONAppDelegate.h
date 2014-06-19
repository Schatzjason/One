//
//  ONAppDelegate.h
//  One
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ONAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) scheduleNotificationStartingTomorrow;

+ (UIImagePickerController*) sharedImagePickerController;
+ (MFMessageComposeViewController*) sharedMessageController;

@end
