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

- (void) testFirstPictureTaken {
    ONModel *m1 = [[ONModel alloc] init];
    
    [m1 pictureWasJustTaken];
    
    XCTAssertEqual( m1.count,  1, @"first picture taken");
    
    [m1 pictureWasJustTaken];
    
    XCTAssertEqual( m1.count,  1, @"second picture, same day");
}

- (void) testStreakBroken {
    ONModel *m1 = [ONModel sharedInstance];
    
    [m1 pictureWasJustTaken];
    
    
    NSInteger originalCount = m1.count;
    NSInteger secondsPerDay = 60*60*24;
    
    NSDate *dPlus1 = [NSDate dateWithTimeIntervalSinceNow: 1 * secondsPerDay];
    NSDate *dPlus2 = [NSDate dateWithTimeIntervalSinceNow: 2 * secondsPerDay];
    NSDate *dPlus4 = [NSDate dateWithTimeIntervalSinceNow: 4 * secondsPerDay];
    
    [m1 pictureTakenONDate: dPlus1];
    XCTAssertEqual( m1.count,  originalCount + 1,  @"One day later");
    XCTAssertTrue(m1.needsCelebration);
    
    [m1 pictureTakenONDate: dPlus1];
    XCTAssertEqual( m1.count,  originalCount + 1,  @"One day later again");
    XCTAssertFalse(m1.needsCelebration);
    
    [m1 pictureTakenONDate: dPlus2];
    XCTAssertEqual( m1.count,  originalCount + 2,  @"Two days later");
    XCTAssertTrue(m1.needsCelebration);
    
    [m1 pictureTakenONDate: dPlus4];
    XCTAssertEqual( m1.count,  1,  @"Four day later, streak broken");
    XCTAssertTrue(m1.needsCelebration);    

    [m1 pictureTakenONDate: dPlus4];
    XCTAssertEqual( m1.count,  1,  @"Four days later again");
    XCTAssertFalse(m1.needsCelebration);
    
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

- (void)testNotificationsArchived {
    ONModel *m1, *m2;
    
    m1 = [ONModel dangerousUnarchivedInstance];
    m1.useNotifications = YES;
    m2 = [ONModel dangerousUnarchivedInstance];
    XCTAssertTrue(m2.useNotifications);
    
    m1 = [ONModel dangerousUnarchivedInstance];
    m1.useNotifications = NO;
    m2 = [ONModel dangerousUnarchivedInstance];
    XCTAssertFalse(m2.useNotifications);
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












































