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

#define kDownwardPixelCount 10
#define kDownwardDuration 1.0
#define kUpwardDuration 1.0
#define kUpwardDurationWithoutCelebration 0.5

@interface ONCongratulationsViewController ()
- (void) slightDownwardShift;
- (void) upwardShiftAnimationWithCelebration: (BOOL) needsCelebration;
- (void) releaseTheBaloonsAnimationWithCelebration: (BOOL) celebration;
- (void) transitionToTakeAnotherPicture;
- (NSString*) displayString: (NSInteger) number;

- (void) generateBaloonsForCelebration: (BOOL) celebration;

@end

@implementation ONCongratulationsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ONModel *model = [ONModel sharedInstance];
    
    NSLog(@"Congratulations View Controller - viewDidLoad. celebration: %@", model.needsCelebration ? @"Y" : @"N");
    
    // Color up
    self.view.backgroundColor = [UIColor appLightColor];
    self.middleShieldView.backgroundColor = [UIColor appLightColor];
    self.topShieldView.backgroundColor = [UIColor appLightColor];
    self.bottomShieldView.backgroundColor = [UIColor appLightColor];
    self.recordLabel.alpha = 0.0f;
    
    if (model.count < model.highestCount) {
        self.tinyRecordLabel.text = [self displayString: model.highestCount];
    } else {
        self.tinyRecordLabel.text = @"";
    }
    
    [self generateBaloonsForCelebration: model.needsCelebration];
    
    if (model.needsCelebration) {
        
        self.numberCenteredLabel.text = [self displayString: model.count - 1];
        self.numberBelowLabel.text = [self displayString: model.count];
        
        if (model.count == model.highestCount) {
            self.recordLabel.text = @"New Record!";
        }
        
    } else {
        self.numberBelowLabel.text = @"";
        self.numberCenteredLabel.text = [self displayString: model.count];
        self.recordLabel.text = @"";
    }
}

- (void) viewDidAppear:(BOOL)animated {
    ONModel *model = [ONModel sharedInstance];
    
    self.aboveRect = self.numberAboveLabel.frame;
    self.centeredRect = self.numberCenteredLabel.frame;
    
    [UIView animateWithDuration: kDownwardDuration animations: ^{
        [self slightDownwardShift];
    } completion: ^(BOOL finished) {
        [self upwardShiftAnimationWithCelebration: model.needsCelebration];
    }];
}

- (void) viewWillDisappear:(BOOL)animated {
    // Celebrations are over
    ONModel *model = [ONModel sharedInstance];

    if (model.needsCelebration) {
        model.needsCelebration = NO;
    }
}

- (void) slightDownwardShift {
    self.numberCenteredLabel.frame = CGRectOffset(self.numberCenteredLabel.frame, 0, kDownwardPixelCount);
    self.numberBelowLabel.frame = CGRectOffset(self.numberBelowLabel.frame, 0, kDownwardPixelCount);
}

- (void) upwardShiftAnimationWithCelebration:(BOOL)needsCelebration {
    

    if (needsCelebration) {

        [UIView animateWithDuration: kUpwardDuration animations: ^ {
            self.numberBelowLabel.frame = self.centeredRect;
            self.numberCenteredLabel.frame = self.aboveRect;
        } completion: ^ (BOOL finished) {
            [self releaseTheBaloonsAnimationWithCelebration: needsCelebration];
        }];
    } else {
        [UIView animateWithDuration: kUpwardDurationWithoutCelebration animations: ^{
            //self.numberCenteredLabel.frame = self.centeredRect;
        }completion: ^ (BOOL finished) {
            [self releaseTheBaloonsAnimationWithCelebration: needsCelebration];
        }];
    }
}

- (void) releaseTheBaloonsAnimationWithCelebration: (BOOL) celebration {
    self.topShieldView.alpha = 0;
    self.bottomShieldView.alpha = 0;
    self.numberAboveLabel.alpha = 0;
    
    if (celebration) self.numberCenteredLabel.alpha = 0;
    
    for (ONBaloonView *b in self.baloons) {
        ;
        [UIView animateWithDuration: 1.0 delay: b.delay options: UIViewAnimationOptionCurveEaseIn animations: ^{
            b.alpha = 0.2 + ((1 - b.distance) * 0.8);
        } completion: ^(BOOL f){
            [UIView animateWithDuration: 1.0  animations: ^ {
                b.alpha = 0.0f;
                self.recordLabel.alpha = 1.0f;
            }];
        }];
    }
}

#define kBaloonDesityConstantHigh 0.04
#define kBaloonDesityConstantLow 0.004

- (void) generateBaloonsForCelebration: (BOOL) celebration {
    
    NSMutableArray *array = [NSMutableArray array];
    
    // Baloon values
    CGSize size =  [UIScreen mainScreen].bounds.size;
    CGFloat viewSize = 30;
    CGFloat density = celebration ? kBaloonDesityConstantHigh : kBaloonDesityConstantLow;
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
        
        if (distance > 0.12) {
            [self.view sendSubviewToBack: b];
        } else {
            [self.view bringSubviewToFront: b];
        }
        
        [array addObject: b];
        
    }
    
    self.baloons = array;
}

- (void) transitionToTakeAnotherPicture {
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated: YES];
    } else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
        UIViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONRetakeViewController"];
        [self.navigationController pushViewController: controller animated: YES];
    }
}

- (IBAction)tappedForAnotherPicture:(id)sender {
    [self transitionToTakeAnotherPicture];
}
                                
- (NSString*) displayString: (NSInteger) number {
    return [NSString stringWithFormat: @"%ld", (long) number];
}

@end
