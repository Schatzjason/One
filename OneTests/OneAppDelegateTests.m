//
//  OneAppDelegateTests.m
//  One
//
//  Created by Jason Schatz on 6/17/14.
//  Copyright 2014 Jason Schatz. All rights reserved.
//

#import "OneAppDelegateTests.h"
#import "ONAppDelegate.h"
#import "ONModel.h"


@implementation OneAppDelegateTests

static ONAppDelegate* _delegate;
static UIApplication* _application;

+ (void) setUp {
    _application = [UIApplication sharedApplication];
    _delegate = _application.delegate;
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testNotifications {
    [_delegate scheduleNotificationStartingTomorrow];
    
    XCTAssertEqual([_application scheduledLocalNotifications].count, 1, @"notification has been scheduled");
    
    [_delegate scheduleNotificationStartingTomorrow];
    
    XCTAssertEqual([_application scheduledLocalNotifications].count, 1, @"still just one");
}

@end
