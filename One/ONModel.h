//
//  ONModel.h
//  One
//
//  Created by Jason Schatz on 6/7/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ONStateNotConfigured,
    ONStateConfiguredButZero,
    ONStateConfiguredUpAndRunning
} ONState;

@interface ONModel : NSObject <NSCoding>

@property (readonly, nonatomic) NSInteger count;
@property (readonly, nonatomic) NSInteger highestCount;

@property (nonatomic, strong) NSArray* recipients;
@property (nonatomic, strong) NSArray* recipientNames;
@property (nonatomic, assign) ONState state;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, assign) BOOL useNotifications;
@property (nonatomic, assign) BOOL needsCelebration;

@property (nonatomic, strong) UIImage *image;

+ (instancetype) sharedInstance;
+ (instancetype) dangerousUnarchivedInstance;

+ (NSInteger) daysFromDate: (NSDate*) d1 toDate: (NSDate*) d2;

- (BOOL) isDoneForToday;
- (void) pictureWasJustTaken;
- (void) pictureTakenONDate: (NSDate*) date;

@end
