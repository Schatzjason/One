//
//  ONRetakeViewController.m
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONRetakeViewController.h"
#import "UIColor+AppColors.h"
#import "ONBackgroundViewController.h"

@interface ONRetakeViewController ()

@end

@implementation ONRetakeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appLightColor];
}


- (IBAction)tapped:(id)sender {
    UIStoryboard *mainStoryboard;
    id backgroundController;
    UIViewController *controller;
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass: [ONBackgroundViewController class]]) {
            backgroundController = vc;
        }
    }
    
    if (backgroundController != nil) {
        [self.navigationController popToViewController: backgroundController animated: YES];
    } else {
         mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
         controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONBackgroundViewController"];
        
        [self.navigationController pushViewController: controller animated: YES];
    }
    
}


@end
