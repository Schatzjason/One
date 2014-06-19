//
//  ONGetStartedViewController.h
//  One
//
//  Created by Jason Schatz on 6/12/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONGetStartedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

- (IBAction)buttonClicked:(id)sender;
@end
