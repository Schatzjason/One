//
//  ONConfigureViewController.m
//  One
//
//  Created by Jason Schatz on 6/9/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONLayoutViewController.h"
#import "UIColor+AppColors.h"
#import "ONModel.h"

@interface ONLayoutViewController ()
-(void) addConstraints;
@end

@implementation ONLayoutViewController {
    UILabel *_welcomeLabel;
    UILabel *_descriptionLabel;
    UILabel *_pickerInstructionsLabel;
    UILabel *_recipientsLabel;
    UIButton *_recipientsButton;
    ONModel *_model;
}


- (void)viewDidLoad
{
    NSLog(@"ConfigureViewController");
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appLightColor];
    _model = [ONModel sharedInstance];
    
    [self.view addSubview: self.welcomeLabel];
    [self.view addSubview: self.descriptionLabel];
    [self.view addSubview: self.pickerInstructionsLabel];
    [self.view addSubview: self.recipientsLabel];
    [self.view addSubview: self.recipientsButton];
    
    [self addConstraints];
}

- (void)addConstraints {
    id views = @{@"welcomeLabel" : self.welcomeLabel,
                 @"descriptionLabel" : self.descriptionLabel,
                 @"pickerInstructionsLabel" : self.pickerInstructionsLabel,
                 @"recipientsButton" : self.recipientsButton,
                 @"recipientsLabel" : self.recipientsLabel,
                 };
    
    id metrics = @{@"topGap": @"150p",
                   @"sideGap" : @"20p"
                   };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideGap-[welcomeLabel]-sideGap-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topGap-[welcomeLabel]" options:0 metrics:metrics views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideGap-[descriptionLabel]-sideGap-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[welcomeLabel]-[descriptionLabel]" options:0 metrics:metrics views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideGap-[pickerInstructionsLabel]-sideGap-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[descriptionLabel]-[pickerInstructionsLabel]" options:0 metrics:metrics views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[recipientsButton]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pickerInstructionsLabel]-[recipientsButton]" options:0 metrics:metrics views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideGap-[recipientsLabel]-sideGap-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[recipientsButton]-[recipientsLabel]" options:0 metrics:metrics views:views]];}

- (UIButton*) recipientsButton {
    if (!_recipientsButton) {
        _recipientsButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _recipientsButton.titleLabel.textColor = [UIColor whiteColor];
        _recipientsButton.enabled = YES;
        [_recipientsButton setTitle: @"Who will get the pictures?" forState: UIControlStateNormal];
        [_recipientsButton addTarget: self action: @selector(setRecipients) forControlEvents: UIControlEventTouchDown];
        [_recipientsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _recipientsButton;
}

- (UILabel*) welcomeLabel {
    if (!_welcomeLabel) {
        _welcomeLabel = [[UILabel alloc] init];
        _welcomeLabel.text = @"Welcome!";
        _welcomeLabel.textAlignment = NSTextAlignmentCenter;
        _welcomeLabel.textColor = [UIColor whiteColor];
        _welcomeLabel.adjustsFontSizeToFitWidth = YES;
        _welcomeLabel.font = [UIFont systemFontOfSize: 45];
        [_welcomeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _welcomeLabel;
}

- (UILabel*) pickerInstructionsLabel {
    if (!_pickerInstructionsLabel) {
        _pickerInstructionsLabel = [[UILabel alloc] init];
        _pickerInstructionsLabel.text = @"Who will get your pictures? Click below to choose.";
        _pickerInstructionsLabel.textAlignment = NSTextAlignmentCenter;
        _pickerInstructionsLabel.textColor = [UIColor whiteColor];
        _pickerInstructionsLabel.adjustsFontSizeToFitWidth = YES;
        [_pickerInstructionsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _pickerInstructionsLabel;
}

- (UILabel*) descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.text = @"A picture a day is a great way to stay in touch.";
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.adjustsFontSizeToFitWidth = YES;
        [_descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _descriptionLabel;
}

- (UILabel*) recipientsLabel {
    if (!_recipientsLabel) {
        _recipientsLabel = [[UILabel alloc] init];
        _recipientsLabel.text = @"";
        _recipientsLabel.textAlignment = NSTextAlignmentCenter;
        _recipientsLabel.textColor = [UIColor whiteColor];
        _recipientsLabel.adjustsFontSizeToFitWidth = YES;
        [_recipientsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _recipientsLabel;
}

- (void) setRecipients {
    NSLog(@"set recipients...");
}

@end
