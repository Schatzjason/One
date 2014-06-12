//
//  UIColor+AppColors.m
//  One
//
//  Created by Jason Schatz on 6/9/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

+ (UIColor*) appDarkColor {
    return [UIColor colorWithRed:9.0/255.0 green:96.0/255.0 blue:255.0/255.0 alpha:1.0f];
}

+ (UIColor*) appMediumColor {
    return [UIColor colorWithRed:25/255.0 green:109/255.0 blue:254.0/255.0 alpha:1.0f];
}

+ (UIColor*) appLightColor {
    return [UIColor colorWithRed:55/255.0 green:130/255.0 blue:253/255.0 alpha:1.0f];
}

@end
