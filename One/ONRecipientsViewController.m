//
//  ONRecipientsViewController.m
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONRecipientsViewController.h"
#import "UIColor+AppColors.h"
#import "ONModel.h"
#import "ONManageRecipientsViewController.h"

@interface ONRecipientsViewController ()
- (void) showPickerToSelectNewRecipient;
- (void) setAlphas;
@end

@implementation ONRecipientsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.userImageView.alpha = 0.0f;
    self.userNameLabel.alpha = 0.0f;
    self.changeUserButton.alpha = 0.0f;
    self.nextButton.alpha = 0;
    self.userNameLabel.adjustsFontSizeToFitWidth = YES;
    
    self.welcomeLabel.text = @"Welcome!";
    self.promptLabel.text = @"Who will get the pictures?";

    NSString *nextTitle = @"Next";
    [self.nextButton setTitle: nextTitle forState: UIControlStateNormal];
    
    NSString *changeUserTitle = @"(Click to change)";
    [self.changeUserButton setTitle: changeUserTitle forState: UIControlStateNormal];
    
    // hide the initial views.
    [self.allViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setAlpha: 0.0f];
    }];
    
    self.firstTime = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    ONModel *model = [ONModel sharedInstance];
    
    [self setAlphas];
    
    if (model.recipientNames.count == 1) {
        self.userNameLabel.text = [model.recipientNames firstObject];
    } else if (model.recipientNames.count > 1) {
        self.userNameLabel.text = [NSString stringWithFormat: @"%@, ...", [model.recipientNames firstObject]];
    } else {
        self.userNameLabel.text = @"";
    }
    
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.firstTime) {
        [UIView animateWithDuration: 0.6 animations: ^ {
            [self.allViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj setAlpha: 1.0f];
            }];
        }];
        
        self.firstTime = NO;
    }
}


#pragma mark - helpers

- (void) setAlphas {
    ONState state = [ONModel sharedInstance].state;
    CGFloat recipientChooserAlpha = (state == ONStateNotConfigured) ? 1.0f : 0.0f;
    CGFloat moveOnAlpha = 1.0f - recipientChooserAlpha;
    
    // Ready to move on
    self.nextButton.alpha = moveOnAlpha;
    self.userNameLabel.alpha = moveOnAlpha;
    self.changeUserButton.alpha = moveOnAlpha;
    
    // Should set the recipients
    self.addReciepientsButton.alpha = recipientChooserAlpha;
    self.promptLabel.alpha = recipientChooserAlpha;
    self.welcomeLabel.alpha = recipientChooserAlpha;
}


#pragma mark - IBActions

- (IBAction)recipientsButtonClicked:(id)sender {
    [self showPickerToSelectNewRecipient];
}

- (IBAction)changeUserButtonClicked:(id)sender {
    [self showPickerToSelectNewRecipient];
}

- (IBAction)nextButtonClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle: nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier: @"ONGetStartedViewController"];
    
    [self.navigationController pushViewController: controller animated: YES];
}

- (void) showPickerToSelectNewRecipient {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle: nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier: @"ONManageRecipientsViewController"];
    
    [self.navigationController pushViewController: controller animated: YES];
}

@end
