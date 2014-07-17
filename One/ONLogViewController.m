//
//  ONLogViewController.m
//  One
//
//  Created by Jason Schatz on 6/25/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONLogViewController.h"
#import "ONModel.h"
#import "UIColor+AppColors.h"
#import "ONLogTableViewCell.h"
#import "ONRecord.h"

#define kCellReuseIdentifier @"ONLogCell"

@interface ONLogViewController ()
@property (nonatomic, weak) ONModel* model;
@end

@implementation ONLogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.model = [ONModel sharedInstance];
    
    UIImage *gearImage = [UIImage imageNamed: @"gearIcon.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage: gearImage style:UIBarButtonItemStylePlain target: self action: @selector(settingsButtonClicked)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerClass: [ONLogTableViewCell class] forCellReuseIdentifier: kCellReuseIdentifier];
    self.tableView.rowHeight = 60;
    
    // Temporary
    //[self.model addTestRecords];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.navigationController setNavigationBarHidden: NO animated: NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    
    [self.navigationController setNavigationBarHidden: YES animated: YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseIdentifier = kCellReuseIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ReuseIdentifier forIndexPath:indexPath];
    ONRecord *record = [self.model.records objectAtIndex: self.model.records.count - 1 - indexPath.row];
    
    if (record.isDummy) {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.imageView.alpha = 0.5;
        cell.imageView.image = nil;
    } else {
        cell.textLabel.text = record.isDummy ? @"" : [record formattedDateString];
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%ld", (long) record.count];
        cell.imageView.alpha = 1.0;
    }
    
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}


#pragma mark - Actions

- (void) settingsButtonClicked {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName: @"Main_iPhone" bundle:nil];
    UIViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ONSettingsTableViewController"];
    [self.navigationController pushViewController: controller animated: YES];
}

@end
