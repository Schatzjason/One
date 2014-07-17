//
//  ONCongratulationsViewController.h
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONCongratulationsViewController : UIViewController

@property (nonatomic, assign) BOOL celebrationIsCanceled;
@property (nonatomic, assign) CGRect aboveRect;
@property (nonatomic, assign) CGRect centeredRect;
@property (nonatomic, assign) CGRect belowRect;

@property (weak, nonatomic) IBOutlet UILabel *numberAboveLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberCenteredLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberBelowLabel;
@property (weak, nonatomic) IBOutlet UIView *middleShieldView;
@property (weak, nonatomic) IBOutlet UIView *topShieldView;
@property (weak, nonatomic) IBOutlet UIView *bottomShieldView;
@property (weak, nonatomic) IBOutlet UIImageView *cameraFrame;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *navBarItems;

- (IBAction)logViewButtonTapped:(id)sender;
- (IBAction)backButtonTapped:(id)sender;

@property (nonatomic, strong) NSArray *baloons;

@end
