//
//  ONModel.m
//  One
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONModel.h"

#define kModelFilename @"ONModel"
#define kRecipientsKey @"ONModelRecipients"
#define kRecipientsNamesKey @"ONModelRecipientsNames"
#define kCountKey @"ONModelCount"
#define kStateKey @"ONModelState"
#define kDateKey @"ONModelDate"

@interface ONModel (Private)
+ (NSString*) documentPath;
+ (instancetype) unarchive;
- (void) archive;
@end

@implementation ONModel

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
        self.recipients = @[];
        self.recipientNames = @[];
        self.date = nil;
        _count = 0;
        self.state = ONStateNotConfigured;
    }
    
    return self;
}


#pragma mark - properties

- (void) setRecipients:(NSArray *)value {
    _recipients = value;
    [self archive];
}

- (void) setState:(ONState)value {
    _state = value;
    [self archive];
}

- (void) setDate:(NSDate*)value {
    _date = value;
    [self archive];
}

- (void) setRecipientNames:(NSArray *)value {
    _recipientNames = value;
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
        self.state = [aDecoder decodeIntegerForKey: kStateKey];
        self.recipients = [aDecoder decodeObjectForKey: kRecipientsKey];
        self.recipientNames = [aDecoder decodeObjectForKey: kRecipientsNamesKey];
        self.date = [aDecoder decodeObjectForKey: kDateKey];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger: _count forKey: kCountKey];
    [aCoder encodeInteger: self.state forKey: kStateKey];
    [aCoder encodeObject: self.recipients forKey:kRecipientsKey];
    [aCoder encodeObject: self.recipientNames forKey: kRecipientsNamesKey];
    [aCoder encodeObject: self.date forKey: kDateKey];
}

@end
