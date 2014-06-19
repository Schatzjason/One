//
//  ONRecipientsViewController.m
//  One
//
//  Created by Jason Schatz on 6/11/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONRecipientsViewController.h"
#import "UIColor+AppColors.h"
#import "ONModel.h"

@interface ONRecipientsViewController ()
- (void) showPickerToSelectNewRecipient;
- (void) dismissPickerAndDisplayRecipient;

- (NSString*) mobileNumberFromPerson: (ABRecordRef) person;
- (NSString*) displayNameFromPerson: (ABRecordRef) person;
- (NSString*) emailFromPerson: (ABRecordRef) person;

@end

@implementation ONRecipientsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appLightColor];
    self.userImageView.alpha = 0.0f;
    self.userNameLabel.alpha = 0.0f;
    self.changeUserButton.alpha = 0.0f;
    self.nextButton.alpha = 0;
    self.userNameLabel.adjustsFontSizeToFitWidth = YES;
    
    self.welcomeLabel.text = @"Welcome!";
    self.promptLabel.text = @"Who will get the pictures?";

    NSString *nextTitle = @"Next";
    [self.nextButton setTitle: nextTitle forState: UIControlStateNormal];
    
    NSString *changeUserTitle = @"(Click to change)";
    [self.changeUserButton setTitle: changeUserTitle forState: UIControlStateNormal];
    
    // hide the initial views.
    [self.allViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj setAlpha: 0.0f];
    }];
    
    self.firstTime = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    if (self.firstTime) {
        [UIView animateWithDuration: 0.6 animations: ^ {
            [self.allViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj setAlpha: 1.0f];
            }];
        }];
        
        self.firstTime = NO;
    }
}


- (IBAction)recipientsButtonClicked:(id)sender {
    [self showPickerToSelectNewRecipient];
}

- (IBAction)changeUserButtonClicked:(id)sender {
    [self showPickerToSelectNewRecipient];
}

- (void) showPickerToSelectNewRecipient {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
    
    [self.navigationController presentViewController: picker animated: YES completion: nil];
}

- (void) dismissPickerAndDisplayRecipient {
    self.welcomeLabel.alpha = 0;
    self.promptLabel.alpha = 0;
    
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
}


#pragma mark - People Picking

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSLog(@"picked: %@", person);
    
    self.addReciepientsButton.alpha = 0.0f;
    self.userImageView.alpha = 1.0f;
    self.userNameLabel.alpha = 1.0f;
    self.changeUserButton.alpha = 1.0f;
    self.nextButton.alpha = 1.0f;
    
    self.userNameLabel.text = [self displayNameFromPerson: person];
    
    ONModel *model = [ONModel sharedInstance];
    NSString* name = [self displayNameFromPerson: person];
    NSString* number = [self mobileNumberFromPerson: person];
    NSString* email = [self emailFromPerson: person];
    
    NSLog(@"shouldContinueAfterSelectingPerson. name: %@, number: %@, email: %@", name, number, email);

    if (name == nil || (number == nil && email == nil)) {
        return NO;
    }
    
    model.recipientNames = @[name];
    
    if (number != nil) {
        model.recipients = @[number];
    } else {
        model.recipients = @[email];
    }
    
    [self performSelectorOnMainThread: @selector(dismissPickerAndDisplayRecipient) withObject: nil waitUntilDone: NO];
    
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    NSLog(@"picked: %@ : %d", person, property);
    return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    NSLog(@"canceled");
}


#pragma mark - ABReferenceRef Helpers

- (NSString*) mobileNumberFromPerson: (ABRecordRef) person {
    
    ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString* mobile = nil;
    NSString* mobileLabel;
    NSInteger mobileIndex = -1;
    NSInteger count = ABMultiValueGetCount(phones);
    
    for (int i=0; i < count; i++) {
        
        mobileLabel = (__bridge_transfer NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
        
        if ([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel] || [mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel]) {
            mobileIndex = i;
        }
    }
    
    if (mobileIndex >= 0) {
        mobile = (__bridge_transfer NSString*) ABMultiValueCopyValueAtIndex(phones, mobileIndex);
    }
    
    return mobile;
}

- (NSString*) displayNameFromPerson: (ABRecordRef) person {
    NSString *first;
    NSString *last;
    
    first = (__bridge_transfer NSString*) ABRecordCopyValue(person, kABPersonFirstNameProperty);
    last = (__bridge_transfer NSString*) ABRecordCopyValue( person, kABPersonLastNameProperty);
    
    if (first && last) {
        return [NSString stringWithFormat: @"%@ %@", first, last];
    }
    
    if (first) return first;
    if (last) return last;
    
    return @"(non name)";
}

- (NSString*) emailFromPerson:(ABRecordRef)person {
    CFStringRef homeEmail = nil, workEmail = nil, otherEmail = nil, unlabeledEmail = nil;
    CFStringRef email;
    CFStringRef emailLabel;
    
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
    CFIndex emailCount = ABMultiValueGetCount(multi);
    
    for(int i = 0; i < emailCount; i++){
        emailLabel = ABMultiValueCopyLabelAtIndex(multi, i);
        
        if (emailLabel == nil) {
            unlabeledEmail = ABMultiValueCopyValueAtIndex(multi, i);
            continue;
        };
        
        if(CFStringCompare( emailLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
            homeEmail = ABMultiValueCopyValueAtIndex(multi, i);
        }
        
        if(CFStringCompare( emailLabel, kABOtherLabel, 0) == kCFCompareEqualTo) {
            otherEmail = ABMultiValueCopyValueAtIndex(multi, i);
        }
        
        if(CFStringCompare( emailLabel, kABWorkLabel, 0) == kCFCompareEqualTo) {
            workEmail = ABMultiValueCopyValueAtIndex(multi, i);
        }

    }
    
    CFRelease(multi);
    
    // Establish our preference
    if (unlabeledEmail != nil) email = unlabeledEmail;
    else if (homeEmail != nil)  email = homeEmail;
    else if (otherEmail != nil) email = otherEmail;
    else if (workEmail != nil)  email = workEmail;
    
    else {
        return nil;
    }

    NSLog(@"email extraction. home: %@, work: %@, other: %@", homeEmail, otherEmail, workEmail);
    
    return (__bridge NSString*) email;
}

@end
