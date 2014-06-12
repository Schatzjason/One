//
//  ONIntroViewController.m
//  One
//
//  Created by Jason Schatz on 6/9/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONWelcomeViewController.h"
#import "ONModel.h"
#import "UIColor+AppColors.h"

@interface ONWelcomeViewController ()

@end

@implementation ONWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"IntroViewController");
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appMediumColor];
}

- (void) viewWillAppear:(BOOL)animated {
//    [UIView animateWithDuration: 1.0
//                          delay: 0.0
//                        options: UIViewAnimationOptionRepeat
//                     animations: ^ {self.nextButton.alpha = 0.5;}
//                     completion: ^ (BOOL done) {}
//     ];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

@end
