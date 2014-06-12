//
//  OneTests.m
//  OneTests
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ONModel.h"

@interface OneModelTests : XCTestCase

@end

@implementation OneModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSingleton
{
    ONModel *m1 = [ONModel sharedInstance];
    ONModel *m2 = [ONModel sharedInstance];
    XCTAssert(m1 != nil, @"return value");
    XCTAssert(m1 == m2, @"consistent value");
}

- (void)testIncrementCount;
{
    ONModel *m1 = [ONModel sharedInstance];
    
    NSInteger initialCount = m1.count;
    [m1 incrementCount];
    
    XCTAssertEqual(initialCount + 1, m1.count);
}

- (void)testRecipientsArchived {
    NSArray *r = @[@"111", @"222"];
    
    ONModel *m1 = [ONModel dangerousUnarchivedInstance];
    
    m1.recipients = r;
    
    ONModel *m2 = [ONModel dangerousUnarchivedInstance];
    
    XCTAssertTrue([r isEqual: m2.recipients], @"recipients array was archived correctly");
}

- (void)testStateArchived {
    ONModel *m1, *m2;
    
    m1 = [ONModel dangerousUnarchivedInstance];
    m1.state = ONStateConfiguredButZero;
    m2 = [ONModel dangerousUnarchivedInstance];
    XCTAssertEqual(m1.state, m2.state);
    
    m1 = [ONModel dangerousUnarchivedInstance];
    m1.state = ONStateConfiguredUpAndRunning;
    m2 = [ONModel dangerousUnarchivedInstance];
    XCTAssertEqual(m1.state, m2.state);
}

- (void)testDateArchived {
    ONModel *m1, *m2;
    
    m1 = [ONModel dangerousUnarchivedInstance];
    m1.date = [NSDate date];
    m2 = [ONModel dangerousUnarchivedInstance];
    XCTAssertTrue([m1.date isEqualToDate: m2.date]);
}

- (void)testRecipientNamesArchived {
    ONModel *m1, *m2;
    
    m1 = [ONModel dangerousUnarchivedInstance];
    m1.recipientNames = @[@"a", @"b"];
    m2 = [ONModel dangerousUnarchivedInstance];
    XCTAssertTrue([m1.recipientNames isEqual: m2.recipientNames]);
}

- (void) testIsDoneForToday {
    ONModel *m1 = [[ONModel alloc] init];
    
    XCTAssertFalse([m1 isDoneForToday], @"date is nil");
    
    m1.date = [NSDate date];
    
    XCTAssertTrue([m1 isDoneForToday], @"date is has just been set");
    
    m1.date = [NSDate dateWithTimeIntervalSinceNow: -60*60*24];
    
    XCTAssertFalse([m1 isDoneForToday], @"date set to yesterda");
}

@end












































