//
//  ONRecordsTests.m
//  One
//
//  Created by Jason Schatz on 6/24/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ONRecord.h"

@interface ONRecordsTests : XCTestCase

@end

@implementation ONRecordsTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testDummy
{
    ONRecord *record = [ONRecord dummyRecord];
    XCTAssertTrue(record.isDummy, @"should be dummy");
}

- (void) testDateStartsWithDayOfWeek {
    ONRecord *record = [ONRecord recordWithDate: [NSDate date] count: 99];
    NSString *s = [record formattedDateString];
    NSArray *daysOfWeek = [[ONRecord sharedFormatter] weekdaySymbols];
    
    NSInteger indexOfFirstSpace = [s rangeOfString: @" "].location;
    
    XCTAssertTrue(indexOfFirstSpace > 0, @"contains space");
    
    NSString *weekDay = [s substringToIndex: indexOfFirstSpace];
    
    XCTAssertTrue([daysOfWeek containsObject: weekDay],  @"%@ starts with %@", s, [daysOfWeek description]);
}

@end
