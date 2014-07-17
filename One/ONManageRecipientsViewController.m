//
//  ONManageRecipientsTableViewController.m
//  One
//
//  Created by Jason Schatz on 7/5/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONManageRecipientsViewController.h"
#import "UIColor+AppColors.h"

#define kCellReuseIdentifier @"CellReuseIdentifier"

@interface ONManageRecipientsViewController ()
- (void) addButtonClicked;
- (void) adjustAlphas;
@end

@implementation ONManageRecipientsViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.model = [ONModel sharedInstance];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 33;
    
    UIBarButtonItem *ab;
    ab = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(addButtonClicked)];
    self.navigationItem.rightBarButtonItem = ab;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: kCellReuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.toLabel.textColor = [UIColor appLightColor];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.navigationController setNavigationBarHidden: NO];
    
    [self adjustAlphas];
}

- (void) adjustAlphas {
    self.clickToAddImage.alpha = self.model.recipients.count > 0 ? 0.0f : 1.0f;
    self.toLabel.alpha = self.model.recipients.count > 0 ? 1.0f : 0.0f;
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.recipients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellReuseIdentifier forIndexPath:indexPath];
    
    NSString *name = [self.model.recipientNames objectAtIndex: indexPath.row];
    
    if (indexPath.row < self.model.recipients.count - 1) {
        name = [NSString stringWithFormat: @"%@,", name];
    }
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [self.model.recipients objectAtIndex: indexPath.row];
    cell.textLabel.textColor = [UIColor appLightColor];
    cell.detailTextLabel.textColor = [UIColor appLightColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"backspaceButton.jpg"]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *recipient = [self.model.recipients objectAtIndex: indexPath.row];
    NSString *recipientName = [self.model.recipientNames objectAtIndex: indexPath.row];
    
    [self.model removeRecipient: recipient withName: recipientName];
    
    [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
    
    if (self.model.recipients.count == 0) {
        self.model.state = ONStateNotConfigured;
    }
    
    [self adjustAlphas];
}


#pragma mark - Actions

- (void) addButtonClicked {
    NSLog(@"ONManageRecipients... add button clicked...");

    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
    
    [self.navigationController presentViewController: picker animated: YES completion: nil];
}

#pragma mark - People Picking

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSLog(@"picked: %@", person);
    
    NSString* name = [ONModel displayNameFromPerson: person];
    NSString* number = [ONModel mobileNumberFromPerson: person];
    NSString* email = [ONModel emailFromPerson: person];
    NSString* recipient;
    
    NSLog(@"shouldContinueAfterSelectingPerson. name: %@, number: %@, email: %@", name, number, email);
    
    if (name == nil || (number == nil && email == nil)) {
        return NO;
    }
    
    
    if (number != nil) {
        recipient = number;
    } else {
        recipient = email;
    }
    
    [self.model addRecipient:recipient withName: name];
    
    if (self.model.state == ONStateNotConfigured) {
        self.model.state = self.model.count == 0 ? ONStateConfiguredButZero : ONStateConfiguredUpAndRunning;
    }
    
    [peoplePicker dismissViewControllerAnimated: YES completion:^{}];
    
    [self.tableView reloadData];
    
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    NSLog(@"picked: %@ : %d", person, property);
    return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    NSLog(@"canceled");
}


@end
