//
//  UICollectionViewLayoutAttributes+Aligned.m
//  FlowLayout
//
//  Created by Grigory Avdyushin on 22.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "UICollectionViewLayoutAttributes+Aligned.h"

@implementation UICollectionViewLayoutAttributes (Aligned)


- (void)leftAlignFrame:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)rightAlignFrame:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.origin.x = width - frame.size.width;
    self.frame = frame;
}

@end
