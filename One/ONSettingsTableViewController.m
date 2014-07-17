//
//  ONSettingsViewController.m
//  One
//
//  Created by Jason Schatz on 6/26/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONSettingsTableViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ONModel.h"
#import "UIColor+AppColors.h"
#import "ONManageRecipientsViewController.h"

#define kFontSize 14
#define kManageRecipientsController @"ONManageRecipientsViewController"

@interface ONSettingsTableViewController ()
- (UITextField*) createStandardTextField;
- (void) updateModelForTextField: (UITextField*) textField;
- (void) updateModelForSwitch: (UISwitch*) s;
- (void) showPickerToSelectNewRecipient;
@end

@implementation ONSettingsTableViewController {
    UISwitch *_notificationSwitch;
    UITextField *_messagePhraseTextField;
    UITextField *_recipientsNickeNameTextField;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [ONModel sharedInstance];
    self.navigationItem.title = @"Settings";
    
    // Footer Texts
    NSString *recipientInstructions = @"Click on this row to choose a new person from your contacts.";
    NSString *notificationInstructions = @"Choose ON to receive a notification each day reminding you to send your picture.";
    NSString *phraseInstruction = @"Set the text that should appeare in the message that accompanies your picture.";
    NSString *recipientsNicknameInstructions = @"Choose a nickname for the recipient. Used in the daily notification.";
    self.footerTexts = @[recipientInstructions, notificationInstructions, phraseInstruction, recipientsNicknameInstructions];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: NO];
    
    [self.tableView reloadData];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: YES];

    if (![self.model.phrase isEqualToString: self.messagePhraseTextField.text]) {
        self.model.phrase = self.messagePhraseTextField.text;
    }
    
    if (![self.model.recipientNickname isEqualToString: self.recipientsNicknameTextField.text]) {
        self.model.recipientNickname = self.recipientsNicknameTextField.text;
    }
    
    //[self.navigationController setNavigationBarHidden: YES];
}


#pragma mark - helpers

- (void) updateModelForTextField: (UITextField*) textField {
    
    if (textField == self.recipientsNicknameTextField) {
        self.model.recipientNickname = textField.text;
    }
    
    else if (textField == self.messagePhraseTextField) {
        self.model.phrase = textField.text;
    }
    
    else {
        NSLog(@"SettingsTableViewController - updateModelForTextField. Something is wrong.");
    }
}

- (void) updateModelForSwitch: (UISwitch*) s {
    self.model.useNotifications = s.isOn;
}


#pragma mark - row control properties

- (UISwitch*) notificationSwitch {
    
    if (!_notificationSwitch) {
        _notificationSwitch = [[UISwitch alloc] init];
        [_notificationSwitch setOn: self.model.useNotifications animated: NO];
        
        [_notificationSwitch addTarget: self action: @selector(updateModelForSwitch:) forControlEvents: UIControlEventValueChanged];
    }
    
    return _notificationSwitch;
}

- (UITextField*) messagePhraseTextField {
    
    if (!_messagePhraseTextField) {
        _messagePhraseTextField = [self createStandardTextField];
        _messagePhraseTextField.text = self.model.phrase;
    }
    
    return _messagePhraseTextField;
}

- (UITextField*) recipientsNicknameTextField {
    
    if (!_recipientsNickeNameTextField) {
        _recipientsNickeNameTextField = [self createStandardTextField];
        _recipientsNickeNameTextField.text = self.model.recipientNickname;
        _recipientsNickeNameTextField.frame = CGRectMake(3, 3, 120, 50);
    }
    
    return _recipientsNickeNameTextField;
}

- (UITextField*) createStandardTextField {
    UITextField *tf;
    
    tf = [[UITextField alloc] init];
    tf.frame = CGRectMake(3, 3, 200, 50);
    tf.textColor = [UIColor lightGrayColor];
    tf.textAlignment = NSTextAlignmentRight;
    tf.text = @"One Picture.";
    tf.delegate = self;
    
    return tf;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* PlainSettingsCell = @"PlainSettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: PlainSettingsCell forIndexPath:indexPath];
    UITextField *textField;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Recipient";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [self.model.recipientNames firstObject];
            break;
        case 1:
            cell.textLabel.text = @"Notifications";
            cell.accessoryView = self.notificationSwitch;
            break;
        case 2:
            cell.textLabel.text = @"Phrase";
            cell.accessoryView = self.messagePhraseTextField;
            cell.accessoryView.alpha = 0.7f;
            break;
            
        case 3:
            cell.textLabel.text = @"Recipient's Name";
            textField = self.recipientsNicknameTextField;
            textField.text = self.model.recipientNickname;
            cell.accessoryView = textField;
            cell.accessoryView.alpha = 0.7f;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return (section < self.footerTexts.count) ? [self.footerTexts objectAtIndex: section] : nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section >= self.footerTexts.count ? 0 : 1;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self showPickerToSelectNewRecipient];
    }
    
    return nil;
}

- (void) showPickerToSelectNewRecipient {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
    UIViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: kManageRecipientsController];

    [self.navigationController pushViewController: controller animated: YES];
}


#pragma mark - Text Field Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateModelForTextField: textField];
    //NSLog(@"Settings View Controller. textFieldDidEndEditing.");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    //NSLog(@"Settings View Controller. textFieldShouldReturn.");
    return YES;
}

#pragma mark - People Picking

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSLog(@"picked: %@", person);
    
    NSString* name = [ONModel displayNameFromPerson: person];
    NSString* number = [ONModel mobileNumberFromPerson: person];
    NSString* email = [ONModel emailFromPerson: person];
    
    NSLog(@"shouldContinueAfterSelectingPerson. name: %@, number: %@, email: %@", name, number, email);
    
    if (name == nil || (number == nil && email == nil)) {
        return NO;
    }
    
    [peoplePicker dismissViewControllerAnimated: YES completion: nil];
    
    [self.tableView reloadData];
    
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    NSLog(@"picked: %@ : %d", person, property);
    return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated: YES completion: nil];
}




@end


























