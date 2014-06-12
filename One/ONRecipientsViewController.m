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
- (NSString*) mobileNumberFromPerson: (ABRecordRef) person;
- (NSString*) emailFromPerson: (ABRecordRef) person;
- (NSString*) displayNameFromPerson: (ABRecordRef) person;
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


#pragma mark - People Picking

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSLog(@"picked: %@", person);
    
    self.addReciepientsButton.alpha = 0.0f;
    self.userImageView.alpha = 1.0f;
    self.userNameLabel.alpha = 1.0f;
    self.changeUserButton.alpha = 1.0f;
    self.nextButton.alpha = 1.0f;
    
    self.userNameLabel.text = [self displayNameFromPerson: person];
    self.userNameLabel.textColor = [UIColor yellowColor];
    
    ONModel *model = [ONModel sharedInstance];
    NSString* name = [self displayNameFromPerson: person];
    NSString* number = [self mobileNumberFromPerson: person];
    
    model.recipientNames = @[name];
    model.recipients = @[number];
    
    [self.navigationController dismissViewControllerAnimated: YES completion: nil];
    
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

@end
