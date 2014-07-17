//
//  ONModel.m
//  One
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONModel.h"
#import "ONAppDelegate.h"
#import "ONRecord.h"

#define kModelFilename @"ONModel"
#define kRecipientsKey @"ONModelRecipients"
#define kRecipientsNamesKey @"ONModelRecipientsNames"
#define kCountKey @"ONModelCount"
#define kStateKey @"ONModelState"
#define kDateKey @"ONModelDate"
#define kNotificationsKey @"ONNotificationsKey"
#define kRecordsKey @"ONRecordsKey"
#define kPhraseKey @"ONPhraseKey"
#define kPreviousCountKey @"ONPreviousCount"
#define kRecipientNickname @"ONRecipientNickname"
#define kCameraDevice @"ONCameraDevice"

@interface ONModel (Private)
+ (NSString*) documentPath;
+ (instancetype) unarchive;
- (void) archive;
@end

@implementation ONModel {
    NSMutableArray *_records;
    NSMutableArray *_recipients;
    NSMutableArray *_recipientNames;
}

@synthesize recipients = _recipients;
@synthesize recipientNames = _recipientNames;

+ (NSString*) documentPath {
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent: kModelFilename];

    return path;
}

+ (instancetype) sharedInstance {
    
    static ONModel* shared = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        shared = [ONModel dangerousUnarchivedInstance];
    });
    
    return shared;
}

- (instancetype) init {
    
    if (self = [super init]) {
        _recipientNames = [NSMutableArray array];
        _recipients = [NSMutableArray array];
        _date = nil;
        _count = 0;
        _previousCount = 0;
        _highestCount = 0;
        _state = ONStateNotConfigured;
        _records = [NSMutableArray array];
        _phrase = @"One Picture.";
        _useNotifications = YES;
        _cameraDevice = -1;
    }
    
    return self;
}


#pragma mark - properties

- (NSArray*) records {
    return _records;
}

- (void) setRecipientNickname:(NSString *)recipientNickname {
    _recipientNickname = recipientNickname;
    [self archive];
}

- (void) setPhrase:(NSString *) value {
    _phrase = value;
    [self archive];
}

- (void) setCameraDevice:(NSInteger) value {
    
    if (value != _cameraDevice) {
        _cameraDevice = value;
        [self archive];
    }
}

- (void) setState:(ONState)value {
    _state = value;
    [self archive];
}

- (void) setDate:(NSDate*)value {
    _date = value;
    [self archive];
}

- (void) setUseNotifications:(BOOL) value {

    // Make the setting of the property effective
    if (!value) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    } else {
        [((ONAppDelegate*) [UIApplication sharedApplication].delegate) scheduleNotificationStartingTomorrow];
    }
    
    _useNotifications = value;
    
    [self archive];
}

#pragma mark - Working methods

- (void) incrementCount {
    _count++;
    [self archive];
}

- (BOOL) isDoneForToday {
    
    if (!self.date) {
        return NO;
    }
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* today = [calendar components:unitFlags fromDate: [NSDate date]];
    NSDateComponents* lastPictureDate = [calendar components:unitFlags fromDate:self.date];
    
    return  [today day]   == [lastPictureDate day] &&
            [today month] == [lastPictureDate month] &&
            [today year]  == [lastPictureDate year];
}

- (void) pictureWasJustTaken {
    [self pictureTakenOnDate: [NSDate date]];
}

- (void) pictureTakenOnDate: (NSDate*) date {

    // first picture
    if (self.date == nil) {
        _count = 1;
        _previousCount = 0;
        _highestCount = 1;
        _needsCelebration = YES;
        _date = date;
        
        // Record the picture and archive
        [_records addObject: [ONRecord recordWithDate: date count: _count]];
        
        return;
    }
    
    NSInteger daysSinceLastPicture = [ONModel daysFromDate: _date toDate: date];
    
    // update the date
    _date = date;
    
    switch (daysSinceLastPicture) {
        case 0:
            // Second picture of day
            self.needsCelebration = NO;
            break;
        case 1:
            // streak continues
            _previousCount = _count;
            _count++;
            self.needsCelebration = YES;
            break;
            
        default:
            // streak broken
            _previousCount = _count;
            _count = 1;
            self.needsCelebration = YES;
            
            // add dummy record to mark end of streak
            if (_records.count > 0) {
                [_records addObject: [ONRecord dummyRecord]];
            }
    }
    
    // Check for updateding highest
    if (_count > _highestCount) {
        _highestCount = _count;
    }
    
    // Notifications
    if (self.useNotifications) {
        ONAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate scheduleNotificationStartingTomorrow];
    }
    
    // Record the picture
    [_records addObject: [ONRecord recordWithDate: date count: _count]];
}

+ (BOOL) date: (NSDate*) d1 isADayBeforeDate: (NSDate*) d2 {
    return [ONModel daysFromDate: d1 toDate: d2] == 1;
}

+ (NSInteger) daysFromDate: (NSDate*) d1 toDate: (NSDate*) d2 {

    NSCalendar *calendar = [NSCalendar currentCalendar];    
    NSInteger startDay=[calendar ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate: d1];
    NSInteger endDay=[calendar ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate: d2];
    
    return endDay-startDay;
}

- (void) addRecord:(ONRecord*) record {
    [_records addObject: record];
    [self archive];
}

- (BOOL) addRecipient: (NSString*) recipient withName: (NSString*) name {

    // No Duplicates
    if ([_recipients containsObject: recipient] &&  [_recipientNames containsObject: name]) {
        return NO;
    }
    
    [_recipients addObject: recipient];
    [_recipientNames addObject: name];
    
    if (_recipientNickname == nil || _recipientNickname.length == 0) {
        _recipientNickname = name;
    }
    
    _state = ONStateConfiguredUpAndRunning;
    
    [self archive];
    
    return YES;
}

- (void) removeRecipient: (NSString*) recipient withName: (NSString*) name {
    
    for (int i = 0; i < _recipientNames.count; i++) {
        if ([recipient isEqualToString: [_recipients objectAtIndex: i]] &&
            [name isEqualToString: [_recipientNames objectAtIndex: i]]) {
            
            [_recipients removeObjectAtIndex: i];
            [_recipientNames removeObjectAtIndex: i];
            
            if (_recipients.count == 0) {
                _state = ONStateNotConfigured;
            }

            [self archive];
        }
    }
    
}



#pragma mark - Archiving

+ (instancetype) dangerousUnarchivedInstance {
    ONModel *m =  [NSKeyedUnarchiver unarchiveObjectWithFile: [ONModel documentPath]];
    
    if (m == nil) {
        m = [[ONModel alloc] init];
    }
    
    return m;
}

- (void) archive {
    [NSKeyedArchiver archiveRootObject: self toFile: [ONModel documentPath]];
}


#pragma mark - NSCoding

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        _count = [aDecoder decodeIntegerForKey: kCountKey];
        _previousCount = [aDecoder decodeIntegerForKey: kPreviousCountKey];
        _state = [aDecoder decodeIntegerForKey: kStateKey];
        _recipients = [aDecoder decodeObjectForKey: kRecipientsKey];
        _recipientNames = [aDecoder decodeObjectForKey: kRecipientsNamesKey];
        _date = [aDecoder decodeObjectForKey: kDateKey];
        _useNotifications = [aDecoder decodeBoolForKey: kNotificationsKey];
        _phrase = [aDecoder decodeObjectForKey: kPhraseKey];
        _recipientNickname = [aDecoder decodeObjectForKey: kRecipientNickname];
        _cameraDevice = [aDecoder decodeIntegerForKey: kCameraDevice];
        
        _records = [aDecoder decodeObjectForKey: kRecordsKey];
        
        if (_records == nil) _records = [NSMutableArray array];
        if (_phrase == nil) _phrase = @"One Picture.";
        if (_recipientNickname == nil && _recipientNames.count > 0) _recipientNickname = [_recipientNames firstObject];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger: _count forKey: kCountKey];
    [aCoder encodeInteger: _previousCount forKey: kPreviousCountKey];
    [aCoder encodeInteger: self.state forKey: kStateKey];
    [aCoder encodeObject: self.recipients forKey:kRecipientsKey];
    [aCoder encodeObject: self.recipientNames forKey: kRecipientsNamesKey];
    [aCoder encodeObject: self.date forKey: kDateKey];
    [aCoder encodeBool: self.useNotifications forKey:kNotificationsKey];
    [aCoder encodeObject: self.phrase forKey: kPhraseKey];
    [aCoder encodeObject: self.records forKey: kRecordsKey];
    [aCoder encodeObject: self.recipientNickname forKey: kRecipientNickname];
    [aCoder encodeInteger: self.cameraDevice forKey: kCameraDevice];
}

- (void) addTestRecords {
    [_records removeAllObjects];
    
    NSInteger secondsPerDay = 60*60*24;
    
    NSDate *dPlus1 = [NSDate dateWithTimeIntervalSinceNow: 1 * secondsPerDay];
    NSDate *dPlus2 = [NSDate dateWithTimeIntervalSinceNow: 2 * secondsPerDay];
    NSDate *dPlus4 = [NSDate dateWithTimeIntervalSinceNow: 4 * secondsPerDay];
    NSDate *dPlus5 = [NSDate dateWithTimeIntervalSinceNow: 5 * secondsPerDay];
    NSDate *dPlus7 = [NSDate dateWithTimeIntervalSinceNow: 7 * secondsPerDay];
    NSDate *dPlus8 = [NSDate dateWithTimeIntervalSinceNow: 8 * secondsPerDay];

    [_records addObject: [ONRecord recordWithDate: dPlus1 count: 1]];
    [_records addObject: [ONRecord recordWithDate: dPlus2 count: 2]];
    [_records addObject: [ONRecord dummyRecord]];
    [_records addObject: [ONRecord recordWithDate: dPlus4 count: 1]];
    [_records addObject: [ONRecord recordWithDate: dPlus5 count: 2]];
    [_records addObject: [ONRecord dummyRecord]];
    [_records addObject: [ONRecord recordWithDate: dPlus7 count: 57]];
    [_records addObject: [ONRecord recordWithDate: dPlus8 count: 189]];
}


#pragma mark - ABReferenceRef Helpers

+ (NSString*) mobileNumberFromPerson: (ABRecordRef) person {
    
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

+ (NSString*) displayNameFromPerson: (ABRecordRef) person {
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

+ (NSString*) emailFromPerson:(ABRecordRef)person {
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
