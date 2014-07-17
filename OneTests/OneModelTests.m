//
//  OneTests.m
//  OneTests
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ONModel.h"
#import "ONRecord.h"

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

- (void) testBothSidesOfMidnight {
    NSDate *lateDay1, *earlyDay2;
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    
    [myCalendar setTimeZone: [NSTimeZone systemTimeZone]];
    
    NSDateComponents* components = [myCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    [components setHour: 16];
    [components setMinute: 55];
    
    lateDay1 = [myCalendar dateFromComponents:components];
    NSLog(@"***********************************************************   lateDay1: %@", lateDay1);
    
    [components setDay: components.day + 1];
    [components setHour: -7];
    [components setMinute: 5];
    
    earlyDay2 = [myCalendar dateFromComponents: components];
    NSLog(@"***********************************************************   earlyDay2: %@", earlyDay2);

    XCTAssertEqual(1, [ONModel daysFromDate: lateDay1 toDate: earlyDay2], @"ten minutes apart");

    ONModel *m1 = [ONModel sharedInstance];
    
    [m1 pictureTakenOnDate: lateDay1];
    NSInteger initialCount = m1.count;
    [m1 pictureTakenOnDate: earlyDay2];
    
    XCTAssertEqual(initialCount + 1, m1.count, @"should count");
}

- (void) testAlmost48HoursApart {
    NSDate *earlyDay1, *lateDay2;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];

    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[NSDate date]];
    
    [components setHour: -7];
    [components setMinute: 5];
    
    earlyDay1 = [calendar dateFromComponents:components];
    
    [components setDay: components.day + 1];
    [components setHour: components.hour + 23];
    [components setMinute: 55];
    
    lateDay2 = [calendar dateFromComponents: components];
    
    XCTAssertEqual(1, [ONModel daysFromDate: earlyDay1 toDate: lateDay2], @"almost 48 hours apart");
    
    ONModel *m1 = [ONModel sharedInstance];
    
    [m1 pictureTakenOnDate: earlyDay1];
    NSInteger initialCount = m1.count;
    [m1 pictureTakenOnDate: lateDay2];
    
    XCTAssertEqual(initialCount + 1, m1.count, @"should count");
}

- (void)testSingleton
{
    ONModel *m1 = [ONModel sharedInstance];
    ONModel *m2 = [ONModel sharedInstance];
    XCTAssert(m1 != nil, @"return value");
    XCTAssert(m1 == m2, @"consistent value");
}

- (void) testModelsNotifications {
    ONModel *m = [ONModel sharedInstance];
    UIApplication *a = [UIApplication sharedApplication];
    
    m.useNotifications = NO;
    XCTAssertEqual([a scheduledLocalNotifications].count, 0, @"still just one");
    
    m.useNotifications = YES;
    XCTAssertEqual([a scheduledLocalNotifications].count, 1, @"still just one");
    
    m.useNotifications = NO;
    XCTAssertEqual([a scheduledLocalNotifications].count, 0, @"still just one");
    
    m.useNotifications = YES;
    XCTAssertEqual([a scheduledLocalNotifications].count, 1, @"still just one");
}

- (void) testAddAndRemoveRecipients {
    NSString *recipientA = @"recipientA";
    NSString *recipientB = @"recipientB";
    NSString *recipientNameA = @"nameA";
    NSString *recipientNameB = @"nameB";
    
    ONModel *m = [[ONModel alloc] init];
    
    XCTAssertEqual( m.recipientNames.count, 0, @"starts empty");
    
    [m addRecipient:recipientA withName: recipientNameA];
    XCTAssertEqual( m.recipientNames.count, 1, @"add A once");

    [m addRecipient:recipientA withName: recipientNameA];
    XCTAssertEqual( m.recipientNames.count, 1, @"add A again");
    
    [m addRecipient:recipientB withName: recipientNameB];
    XCTAssertEqual( m.recipientNames.count, 2, @"add B once");
    
    [m removeRecipient: recipientA withName: recipientNameA];
    XCTAssertEqual( m.recipientNames.count, 1, @"remove A");
    
    [m removeRecipient: recipientB withName: recipientNameA];
    XCTAssertEqual( m.recipientNames.count, 1, @"remove B wrong");
    
    [m removeRecipient: recipientB withName: recipientNameB];
    XCTAssertEqual( m.recipientNames.count, 0, @"remove B");
}



- (void) testRecordsArray {
    ONModel *m1 = [ONModel sharedInstance];
    
    NSArray* r = m1.records;
    
    XCTAssertNotNil(r, @"records should always have a value");
}

- (void) testFirstPictureTaken {
    ONModel *m1 = [[ONModel alloc] init];
    
    [m1 pictureWasJustTaken];
    
    XCTAssertEqual( m1.count,  1, @"first picture taken");
    
    [m1 pictureWasJustTaken];
    
    XCTAssertEqual( m1.count,  1, @"second picture, same day");
}

- (void) testCountsWithStreakBroken {
    ONModel *m1 = [ONModel sharedInstance];
    
    [m1 pictureWasJustTaken];
    
    
    NSInteger originalCount = m1.count;
    NSInteger secondsPerDay = 60*60*24;
    
    NSDate *dPlus1 = [NSDate dateWithTimeIntervalSinceNow: 1 * secondsPerDay];
    NSDate *dPlus2 = [NSDate dateWithTimeIntervalSinceNow: 2 * secondsPerDay];
    NSDate *dPlus4 = [NSDate dateWithTimeIntervalSinceNow: 4 * secondsPerDay];
    NSDate *dPlus5 = [NSDate dateWithTimeIntervalSinceNow: 5 * secondsPerDay];
    
    [m1 pictureTakenOnDate: dPlus1];
    XCTAssertEqual( m1.count,  originalCount + 1,  @"One day later");
    XCTAssertEqual(m1.previousCount, originalCount, @"One day later pc.");
    XCTAssertTrue(m1.needsCelebration);
    
    [m1 pictureTakenOnDate: dPlus1];
    XCTAssertEqual( m1.count,  originalCount + 1,  @"One day later again");
    XCTAssertEqual(m1.previousCount, originalCount, @"One day later again pc.");
    XCTAssertFalse(m1.needsCelebration);
    
    [m1 pictureTakenOnDate: dPlus2];
    XCTAssertEqual( m1.count,  originalCount + 2,  @"Two days later");
    XCTAssertEqual(m1.previousCount, originalCount + 1, @"Two days later pc.");
    XCTAssertTrue(m1.needsCelebration);
    
    [m1 pictureTakenOnDate: dPlus4];
    XCTAssertEqual( m1.count,  1,  @"Four day later, streak broken");
    XCTAssertEqual(m1.previousCount, originalCount + 2, @"streak broken pc.");
    XCTAssertTrue(m1.needsCelebration);
    
    [m1 pictureTakenOnDate: dPlus4];
    XCTAssertEqual( m1.count,  1,  @"Four days later again");
    XCTAssertEqual( m1.previousCount,  originalCount + 2,  @"Four days later again pc");
    XCTAssertFalse(m1.needsCelebration);
    
    [m1 pictureTakenOnDate: dPlus5];
    XCTAssertEqual( m1.count,  2,  @"Five days later");
    XCTAssertEqual( m1.previousCount,  1,  @"Five days later pc");
    XCTAssertTrue(m1.needsCelebration);
    
}

- (void) testVeryFirstPictureCreatesOneRecord {
    ONModel *m1 = [[ONModel alloc] init];
    
    XCTAssertEqual(m1.records.count, 0);
    
    [m1 pictureTakenOnDate: [NSDate date]];
    
    XCTAssertEqual(m1.records.count, 1);
}

- (void) testRecordsDuringStreak {
    ONModel *m1 = [ONModel sharedInstance];
    
    [m1 pictureWasJustTaken];
    
    
    NSInteger originalCount = m1.records.count;
    NSInteger secondsPerDay = 60*60*24;
    
    NSDate *dPlus1 = [NSDate dateWithTimeIntervalSinceNow: 1 * secondsPerDay];
    NSDate *dPlus2 = [NSDate dateWithTimeIntervalSinceNow: 2 * secondsPerDay];
    NSDate *dPlus4 = [NSDate dateWithTimeIntervalSinceNow: 4 * secondsPerDay];
    
    [m1 pictureTakenOnDate: dPlus1];
    XCTAssertEqual( m1.records.count,  originalCount + 1,  @"One more record");
    
    [m1 pictureTakenOnDate: dPlus1];
    XCTAssertEqual( m1.records.count,  originalCount + 2,  @"same day record");
    
    [m1 pictureTakenOnDate: dPlus2];
    XCTAssertEqual( m1.records.count,  originalCount + 3,  @"next day record");
    
    [m1 pictureTakenOnDate: dPlus4];
    XCTAssertEqual( m1.records.count,  originalCount + 5,  @"Broken streak. With Dummy Record.");
    
    // The fourt record added should be a dummy
    NSInteger dummyIndex = (originalCount - 1) + 4;
    ONRecord *shouldBeDummy = [m1.records objectAtIndex: dummyIndex];
    XCTAssertTrue(shouldBeDummy.isDummy, @"should be a dummy");
    
    [m1 pictureTakenOnDate: dPlus4];
    XCTAssertEqual( m1.records.count,  originalCount + 6,  @"Four days later again");
}

- (void)testRecipientsArchived {
    NSString* recipient = @"testRecipient";
    NSString* recipientName = @"testRecipient";
    
    ONModel *m1 = [[ONModel alloc] init];
    
    [m1 addRecipient: recipient withName: recipientName];
    
    ONModel *m2 = [ONModel dangerousUnarchivedInstance];
    
    XCTAssertTrue([[m2.recipients objectAtIndex: 0] isEqualToString: recipient], @"recipients array was archived correctly");
}

- (void) testPhraseArchived {
    NSString *s = @"yodler";
    
    ONModel *m1 = [ONModel dangerousUnarchivedInstance];
    
    m1.phrase = s;
    
    ONModel *m2 = [ONModel dangerousUnarchivedInstance];
    
    XCTAssertTrue([s isEqual: m2.phrase], @"Phrase was archived correctly");
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

- (void)testNicknameArchived {
    ONModel *m1, *m2;
    NSString *name = @"Suzy";
    
    m1 = [ONModel dangerousUnarchivedInstance];
    m1.recipientNickname = name;
    m2 = [ONModel dangerousUnarchivedInstance];
    XCTAssertTrue([m2.recipientNickname isEqualToString: name]);
}

- (void)testNicknamePrefilled {
    ONModel *m1, *m2;
    NSString *name = @"Suzy";
    NSString *recipient = @"suzy@ost.com";
    
    m1 = [[ONModel alloc] init];
    XCTAssertNil(m1.recipientNickname, @"brand new...");
    
    [m1 addRecipient: recipient withName: name];
    XCTAssertTrue([m1.recipientNickname isEqualToString: name]);

    m2 = [ONModel dangerousUnarchivedInstance];
    XCTAssertTrue([m2.recipientNickname isEqualToString: name]);
}

- (void) testRecordsArchived {
    ONModel *m1, *m2;
    m1 = [ONModel dangerousUnarchivedInstance];
    ONRecord *r = [ONRecord recordWithDate: [NSDate date] count: 55];
    
    
    [m1 addRecord: r];
    
    m2 = [ONModel dangerousUnarchivedInstance];
    ONRecord *lastRecord = [m2.records lastObject];
    
    NSInteger dateDifference = [ONModel daysFromDate: r.date toDate: lastRecord.date];
    
    XCTAssertNotNil(lastRecord.date, @"should be a real date");
    XCTAssertEqual(dateDifference, 0, @"should be the same date");
    XCTAssertEqual(lastRecord.count,  55, @"should have saved the count");
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


- (void) testIsDoneForToday {
    ONModel *m1 = [[ONModel alloc] init];
    
    XCTAssertFalse([m1 isDoneForToday], @"date is nil");
    
    m1.date = [NSDate date];
    
    XCTAssertTrue([m1 isDoneForToday], @"date is has just been set");
    
    m1.date = [NSDate dateWithTimeIntervalSinceNow: -60*60*24];
    
    XCTAssertFalse([m1 isDoneForToday], @"date set to yesterda");
}

- (void) testCameraDeviceIsOriginalyLessThanZero {
    ONModel *m1 = [[ONModel alloc] init];
    XCTAssertTrue(m1.cameraDevice < 0, @"Less than zero?");
}

- (void) testCameraDeviceIsArchived {
    ONModel *m1 = [ONModel dangerousUnarchivedInstance];
    
    m1.cameraDevice = 1;
    
    ONModel *m2 = [ONModel dangerousUnarchivedInstance];
    
    XCTAssertEqual(m1.cameraDevice, m2.cameraDevice, @"should have archived");

    m1.cameraDevice = 4;
    
    m2 = [ONModel dangerousUnarchivedInstance];
    
    XCTAssertEqual(m1.cameraDevice, m2.cameraDevice, @"should have archived");
    
}

@end












































