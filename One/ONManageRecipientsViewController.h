//
//  ONManageRecipientsTableViewController.h
//  One
//
//  Created by Jason Schatz on 7/5/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "ONModel.h"

@interface ONManageRecipientsViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) ONModel* model;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *clickToAddImage;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;

@end
