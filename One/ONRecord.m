//
//  ONRecord.m
//  One
//
//  Created by Jason Schatz on 6/23/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONRecord.h"

#define kDateKey @"onrecord.date"
#define kURLKey @"onrecord.url"
#define kCountKey @"onrecord.count"

@implementation ONRecord

#pragma - NSCoding

- (id) init {
    self = [super init];
    
    if (self) {
        _date = nil;
        _url = nil;
    }
    
    return self;
}


#pragma mark - NSCoding

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    
    if (self) {
        self.date = [aDecoder decodeObjectForKey: kDateKey];
        self.url = [aDecoder decodeObjectForKey: kURLKey];
        self.count = [aDecoder decodeIntegerForKey: kCountKey];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject: self.date forKey: kDateKey];
    [aCoder encodeObject: self.url forKey: kURLKey];
    [aCoder encodeInteger: self.count forKey: kCountKey];
}


#pragma mark - properties

-(BOOL) isDummy {
    return self.date == nil;
}


#pragma mark - helpers

+ (instancetype) dummyRecord {
    return [[ONRecord alloc] init];
}

+ (instancetype) recordWithDate: (NSDate*) date count: (NSInteger) count {
    ONRecord *r = [[ONRecord alloc] init];
    
    r.date = date;
    r.count = count;
    
    return r;
}

+ (NSDateFormatter*) sharedFormatter {
    
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t formatterOnce;
    
    dispatch_once(&formatterOnce, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setLocale: [NSLocale currentLocale]];
        [dateFormatter setDateFormat: @"EEEE MMMM d', 'yyyy"];
    });
    
    return dateFormatter;
}

- (NSString*) formattedDateString {
    
    if (self.isDummy) {
        return @"-- dummy --";
    }
    
    return [[ONRecord sharedFormatter] stringFromDate: self.date];
}


@end











