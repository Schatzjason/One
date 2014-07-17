//
//  ONCongratulationsViewController.m
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONCongratulationsViewController.h"
#import "UIColor+AppColors.h"
#import "ONModel.h"
#import "ONBaloonView.h"

#define kDownwardPixelCount 40
#define kDownwardDuration 0.50
#define kUpwardDuration 0.70
#define kUpwardDurationWithoutCelebration 0.5
#define kBaloonDuration 2.0

typedef enum : NSUInteger {
    NoCelebration,
    SmallCelebration,
    FullCelebration,
} CelebrationSize;

@interface ONCongratulationsViewController ()

- (void) moveNumbersStepOneForCelebration: (CelebrationSize) celebrationSize;
- (void) moveNumbersStepTwoForCelebration: (CelebrationSize) celebrationSize;

- (void) generateBaloonsForCelebration: (CelebrationSize) celebrationSize;
- (void) releaseTheBaloonsAnimationWithCelebration: (CelebrationSize) celebrationSize;

- (void) transitionToTakeAnotherPicture;
- (NSString*) displayString: (NSInteger) number;

- (void) standardConfigurationForLabel: (UILabel*) label;

- (CelebrationSize) figureCelebrationSize;

@end

@implementation ONCongratulationsViewController {
    BOOL _baloonsHaveAlreadyPopped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _baloonsHaveAlreadyPopped = NO;
    
    self.aboveRect = self.numberAboveLabel.frame;
    self.belowRect = self.numberBelowLabel.frame;
    self.centeredRect = self.numberCenteredLabel.frame;
    
    NSLog(@"Congratulations View Controller Initial Rects....");
    NSLog(@"above : %@", NSStringFromCGRect(self.aboveRect));
    NSLog(@"center: %@", NSStringFromCGRect(self.centeredRect));
    NSLog(@"below : %@", NSStringFromCGRect(self.belowRect));
    
    [self standardConfigurationForLabel: self.numberAboveLabel];
    [self standardConfigurationForLabel: self.numberCenteredLabel];
    [self standardConfigurationForLabel: self.numberBelowLabel];
    
    UIColor *backgroundColor = [UIColor appLightColor];
    self.view.backgroundColor = backgroundColor;
    self.topShieldView.backgroundColor = backgroundColor;
    self.middleShieldView.backgroundColor = backgroundColor;
    self.bottomShieldView.backgroundColor = backgroundColor;
    
    ONModel *model = [ONModel sharedInstance];
    
    if ([self figureCelebrationSize] == FullCelebration) {
        self.numberAboveLabel.text = [self displayString: model.count];
        self.numberCenteredLabel.text = [self displayString: model.count - 1];
    } else {
        self.numberCenteredLabel.text = [self displayString: model.count];
    }
    
    // Way Back
    [self.view bringSubviewToFront: self.middleShieldView];
    
    // Middle ground
    [self.view bringSubviewToFront: self.numberAboveLabel];
    [self.view bringSubviewToFront: self.numberBelowLabel];
    [self.view bringSubviewToFront: self.numberCenteredLabel];

    // Farthest Forward
    [self.view bringSubviewToFront: self.topShieldView];
    [self.view bringSubviewToFront: self.bottomShieldView];
    [self.view bringSubviewToFront: self.cameraFrame];
}

- (void) viewDidAppear:(BOOL)animated {
    CelebrationSize celebrationSize = [self figureCelebrationSize];
    
    // Punch out now if nothing needs to be done
    if (celebrationSize == NoCelebration) {
        return;
    }
    
    // Generate the baloons
    [self generateBaloonsForCelebration: celebrationSize];
    
    // These seemed to help with the animations.
    if (celebrationSize == FullCelebration)
        [self performSelectorOnMainThread: @selector(startFull) withObject: nil waitUntilDone: NO];
    else if (celebrationSize == SmallCelebration)
        [self performSelectorOnMainThread: @selector(startSmall) withObject: nil waitUntilDone: NO];
    
    // Once this view shows up, it only has one shot to show a celebration
    ONModel *model = [ONModel sharedInstance];
    
    if (model.needsCelebration) {
        model.needsCelebration = NO;
    }
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    
    // Get the labels set up for when we return
    self.numberCenteredLabel.text = [self displayString: [ONModel sharedInstance].count];
    self.numberCenteredLabel.alpha = 1;
    self.numberAboveLabel.alpha = 0;
    self.numberBelowLabel.alpha = 0;
}


#pragma mark - helpers

- (void) standardConfigurationForLabel: (UILabel*) label {
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize: 64];
    label.textAlignment = NSTextAlignmentCenter;
}


- (CelebrationSize) figureCelebrationSize {
    CelebrationSize celebrationSize;

    if (self.celebrationIsCanceled || _baloonsHaveAlreadyPopped) {
        celebrationSize = NoCelebration;
        NSLog(@"Congratulations View Controller. Celebration: No");
    }
    
    else if ([ONModel sharedInstance].needsCelebration) {
        celebrationSize = FullCelebration;
        NSLog(@"Congratulations View Controller. Celebration: Full");
    }
    
    else {
        celebrationSize = SmallCelebration;
        NSLog(@"Congratulations View Controller. Celebration: Small");
    }

    return celebrationSize;
}

- (void) startFull {
    [self moveNumbersStepOneForCelebration: FullCelebration];
}

- (void) startSmall {
    [self moveNumbersStepOneForCelebration: SmallCelebration];
}


#pragma  mark - number animations

- (void) moveNumbersStepOneForCelebration: (CelebrationSize) celebrationSize {
    
    if (celebrationSize == FullCelebration || celebrationSize == SmallCelebration) {
        [UIView animateWithDuration: 0.4f animations:^{
            CGPoint center = self.numberCenteredLabel.center;
            center.y -= 30;
            self.numberCenteredLabel.center = center;
        } completion:^(BOOL finished) {
            [self moveNumbersStepTwoForCelebration: celebrationSize];
        }];
    }
    
    else {
        // Do nothing
    }
}

- (void) moveNumbersStepTwoForCelebration: (CelebrationSize) celebrationSize {
    
    // Full
    
    if (celebrationSize == FullCelebration) {
        
        [UIView animateWithDuration: 0.4 animations:^{
            self.numberAboveLabel.frame = self.centeredRect;
            self.numberCenteredLabel.frame = self.belowRect;
        } completion:^(BOOL finished) {
            
            // hide the extra views, so that the baloons show
            self.topShieldView.alpha = 0;
            self.bottomShieldView.alpha = 0;
            self.numberCenteredLabel.alpha = 0;
            self.numberBelowLabel.alpha = 0;
            
            [self releaseTheBaloonsAnimationWithCelebration: celebrationSize];
        }];
    }
    
    // Small
    
    else if (celebrationSize == SmallCelebration) {

        [UIView animateWithDuration: 0.3 animations:^{
            self.numberCenteredLabel.frame = self.centeredRect;
        } completion:^(BOOL finished) {
            
            // hide the extra views, so that the baloons show
            self.topShieldView.alpha = 0;
            self.bottomShieldView.alpha = 0;
            self.numberAboveLabel.alpha = 0;
            self.numberBelowLabel.alpha = 0;

            [self releaseTheBaloonsAnimationWithCelebration: celebrationSize];
        }];
    }
    
    else {
        // Do nothing
    }
}


#pragma mark - baloon animations

- (void) releaseTheBaloonsAnimationWithCelebration: (CelebrationSize)celebrationSize {
    
    _baloonsHaveAlreadyPopped = YES;
    
    for (ONBaloonView *b in self.baloons) {
        
        [UIView animateWithDuration: kBaloonDuration delay: b.delay options: UIViewAnimationOptionCurveEaseIn animations: ^{
            b.alpha = 0.2 + ((1 - b.distance) * 0.8);
        } completion: ^(BOOL f){
            [UIView animateWithDuration: 1.0  animations: ^ {
                b.alpha = 0.0f;
            }];
        }];
    }
}

#define kBaloonDesityConstantHigh 0.04
#define kBaloonDesityConstantLow 0.004

- (void) generateBaloonsForCelebration: (CelebrationSize) celebrationSize {
    
    NSMutableArray *array = [NSMutableArray array];
    
    // Baloon values
    CGSize size =  [UIScreen mainScreen].bounds.size;
    CGFloat viewSize = 30;
    CGFloat density = celebrationSize == FullCelebration ? kBaloonDesityConstantHigh : kBaloonDesityConstantLow;
    NSInteger balloonCount = density * (size.height * size.width) / (CGFloat) viewSize;
    CGFloat newViewSize;
    CGFloat x;
    CGFloat y;
    CGFloat distance;
    
    ONBaloonView *b;
    
    for (int i = 0; i < balloonCount; i++) {
        distance = 0.1f + (arc4random() % 8) / (CGFloat) 10;
        newViewSize = viewSize + (viewSize * (0.5 - distance));
        x = arc4random() % (NSInteger) (size.width - newViewSize);
        y = arc4random() % (NSInteger) (size.height - newViewSize);
        b = [[ONBaloonView alloc] initWithFrame: CGRectMake(x, y, viewSize, viewSize)];
        b.alpha = 0.0f;
        b.image = [UIImage imageNamed: @"dot.png"];
        b.distance = distance;
        b.delay = (arc4random() % 10 + arc4random() % 10) / 5.0f;

        [self.view addSubview: b];
        [self.view sendSubviewToBack: b];
        
        [array addObject: b];
    }
    
    self.baloons = array;
}


#pragma mark - Actions

- (void) transitionToTakeAnotherPicture {
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated: YES];
    } else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
        UIViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONRetakeViewController"];
        [self.navigationController pushViewController: controller animated: YES];
    }
}

- (IBAction)backButtonTapped:(id)sender {
    [self transitionToTakeAnotherPicture];
}

- (IBAction) logViewButtonTapped:(id)sender {
    self.celebrationIsCanceled = YES;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
    UIViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONLogViewController"];
    [self.navigationController pushViewController: controller animated: YES];
}

- (NSString*) displayString: (NSInteger) number {
    return [NSString stringWithFormat: @"%ld", (long) number];
}

@end
