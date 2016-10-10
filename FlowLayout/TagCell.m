//
//  TagCell.m
//  FlowLayout
//
//  Created by Grigory Avdyushin on 20.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor redColor].CGColor;
    self.layer.borderWidth = 2.0f;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetMidY(self.bounds);
}

@end
