//
//  ONRecipientsViewController.h
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONRecipientsViewController : UIViewController

@property (nonatomic, assign) BOOL firstTime;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *addReciepientsButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *changeUserButton;

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

- (IBAction)recipientsButtonClicked:(id)sender;
- (IBAction)changeUserButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *allViews;
@end
