//
//  FlowLayout.m
//  FlowLayout
//
//  Created by Grigory Avdyushin on 20.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "FlowLayout.h"

@interface UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrame:(CGFloat)left;

@end

@implementation UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrame:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

@end

@implementation FlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;
    switch (self.alignment) {
        case FlowAlignmentLeft:
            return [self layoutLeftAttributesForElements:attributes];
        case FlowAlignmentDefault:
        default:
            return attributes;
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    switch (self.alignment) {
        case FlowAlignmentLeft:
            return [self layoutLeftAttributesForItem:attributes atIndexPath:indexPath];
        case FlowAlignmentDefault:
        default:
            return attributes;
    }
}

#pragma mark - Private

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutLeftAttributesForElements:(NSArray<UICollectionViewLayoutAttributes *> *)attributes
{
    NSMutableArray<UICollectionViewLayoutAttributes *> *alignedAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *a in attributes) {
        [alignedAttributes addObject:[self layoutLeftAttributesForItem:a atIndexPath:a.indexPath]];
    }
    
    return [alignedAttributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutLeftAttributesForItem:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
{
    // Checks if first item in section (and row)
    if (indexPath.item == 0) {
        [attributes leftAlignFrame:self.sectionInset.left];
        return attributes;
    }
    
    UICollectionViewLayoutAttributes *prev = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item - 1
                                                                                                          inSection:indexPath.section]].copy;
    const CGRect frame = prev.frame;
    const CGFloat left = CGRectGetMaxX(frame) + self.minimumInteritemSpacing;
    
    // Checks if first item in row
    if (left > CGRectGetMinX(attributes.frame)) {
        [attributes leftAlignFrame:self.sectionInset.left];
        return attributes;
    }
    
    [attributes leftAlignFrame:left];
    return attributes;
}

@end
