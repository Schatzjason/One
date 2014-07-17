//
//  ONSettingsViewController.h
//  One
//
//  Created by Jason Schatz on 6/26/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ONModel.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@interface ONSettingsTableViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, readonly) UISwitch *notificationSwitch;
@property (nonatomic, readonly) UITextField *messagePhraseTextField;
@property (nonatomic, readonly) UITextField *recipientsNicknameTextField;
@property (nonatomic, strong) NSArray* footerTexts;

@property (nonatomic, strong) ONModel* model;

@end
