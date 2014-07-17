//
//  ONNoTextViewController.m
//  One
//
//  Created by Jason Schatz on 6/19/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONNoTextViewController.h"
#import "UIColor+AppColors.h"

@interface ONNoTextViewController ()

@end

@implementation ONNoTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor appLightColor];
    self.textView.text = @"The One Picture App can only be run on devices that have a camera and can send text messages";
}

@end
