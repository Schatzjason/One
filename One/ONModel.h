//
//  ONModel.h
//  One
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONRecord.h"
#import <AddressBook/AddressBook.h>

typedef enum : NSUInteger {
    ONStateNotConfigured,
    ONStateConfiguredButZero,
    ONStateConfiguredUpAndRunning
} ONState;

@interface ONModel : NSObject <NSCoding>

@property (readonly, nonatomic) NSInteger count;
@property (readonly, nonatomic) NSInteger previousCount;
@property (readonly, nonatomic) NSInteger highestCount;

@property (nonatomic, readonly) NSArray* recipients;
@property (nonatomic, readonly) NSArray* recipientNames;
@property (nonatomic, assign) ONState state;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, assign) BOOL useNotifications;
@property (nonatomic, assign) BOOL needsCelebration;
@property (nonatomic, readonly) NSArray *records;
@property (nonatomic, strong) NSString *phrase;
@property (nonatomic, strong) NSString *recipientNickname;
@property (nonatomic, assign) NSInteger cameraDevice;

@property (nonatomic, strong) UIImage *image;

+ (instancetype) sharedInstance;
+ (instancetype) dangerousUnarchivedInstance;

+ (NSInteger) daysFromDate: (NSDate*) d1 toDate: (NSDate*) d2;

- (BOOL) isDoneForToday;
- (void) pictureWasJustTaken;
- (void) pictureTakenOnDate: (NSDate*) date;
- (void) addRecord: (ONRecord*) record;

- (void) addTestRecords;

// Used when the user picks a new person with ManageRecipientsTableViewController
- (BOOL) addRecipient: (NSString*) recipient withName: (NSString*) name;
- (void) removeRecipient: (NSString*) recipient withName: (NSString*) name;

#pragma mark - ABReferenceRef Helpers

+ (NSString*) mobileNumberFromPerson: (ABRecordRef) person;
+ (NSString*) displayNameFromPerson: (ABRecordRef) person;
+ (NSString*) emailFromPerson:(ABRecordRef)person;


@end
