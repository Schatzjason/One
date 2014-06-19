//
//  ONMessageFailedViewController.h
//  One
//
//  Created by Jason Schatz on 6/12/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ONMessageFailedViewController : UIViewController
- (IBAction)tryAgainButtonClicked:(id)sender;
- (IBAction)anotherPictureButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *anotherPictureButton;

@end
