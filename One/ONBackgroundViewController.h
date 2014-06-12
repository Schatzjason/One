//
//  ONBackgroundViewController.h
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ONBackgroundViewController : UIViewController  <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImagePickerController* pickerController;
@property (strong, nonatomic) MFMessageComposeViewController* messageController;
@property (nonatomic, assign) BOOL firstTime;

@end
