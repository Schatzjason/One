//
//  ONCongratulationsViewController.h
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONCongratulationsViewController : UIViewController

@property (nonatomic, assign) CGRect aboveRect;
@property (nonatomic, assign) CGRect centeredRect;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UILabel *tinyRecordLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberAboveLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberCenteredLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberBelowLabel;

@property (weak, nonatomic) IBOutlet UIView *middleShieldView;
@property (weak, nonatomic) IBOutlet UIView *topShieldView;
@property (weak, nonatomic) IBOutlet UIView *bottomShieldView;

- (IBAction)tappedForAnotherPicture:(id)sender;

@property (nonatomic, strong) NSArray *baloons;

@end
