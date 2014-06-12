//
//  ONNotificationsViewController.h
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONNotificationsViewController : UIViewController
- (IBAction)remindMeButtonClicked:(id)sender;
- (IBAction)noThanksButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *remindMeButton;
@property (weak, nonatomic) IBOutlet UIButton *noThanksButton;
@property (weak, nonatomic) IBOutlet UIButton *takeFirstPictureButton;

@end
