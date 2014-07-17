//
//  ONRecord.h
//  One
//
//  Created by Jason Schatz on 6/23/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ONRecord : NSObject<NSCoding>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, readonly) BOOL isDummy;

+ (instancetype) dummyRecord;
+ (instancetype) recordWithDate: (NSDate*) date count: (NSInteger) count;
+ (NSDateFormatter*) sharedFormatter;

- (NSString*) formattedDateString;

@end
