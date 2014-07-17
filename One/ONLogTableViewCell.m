//
//  ONLogTableViewCell.m
//  One
//
//  Created by Jason Schatz on 6/25/14.
//  Copyright (c) 2014 Jason Schatz. All rights reserved.
//

#import "ONLogTableViewCell.h"
#import "UIColor+AppColors.h"

@implementation ONLogTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView.image = [UIImage imageNamed: @"tableDot.png"];

        self.textLabel.textColor = [UIColor whiteColor];

        self.detailTextLabel.text = [NSString stringWithFormat: @"%ld", (long) 99];
        self.detailTextLabel.textColor = [UIColor appLightColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.font = [UIFont systemFontOfSize: 22];
        [self.contentView bringSubviewToFront: self.detailTextLabel];
        
    }
    
    return self;
}


- (void) layoutSubviews {    
    [super layoutSubviews];
    self.detailTextLabel.frame = self.imageView.frame;
    
    CGRect tlf = self.textLabel.frame;
    CGRect ivf = self.imageView.frame;
    self.textLabel.frame = CGRectMake(tlf.origin.x, ivf.origin.y, tlf.size.width, ivf.size.height);
}



@end
