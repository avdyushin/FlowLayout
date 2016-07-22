//
//  FlowLayout.m
//  FlowLayout
//
//  Created by Grigory Avdyushin on 20.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "FlowLayout.h"
#import "UICollectionViewLayoutAttributes+Aligned.h"

@interface FlowLayout() { }
@property (strong, nonatomic) NSMutableDictionary *cache;
@end

@implementation FlowLayout

- (void)prepareLayout
{
    self.cache = [NSMutableDictionary dictionary];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;
    return [self layoutAttributesForElements:attributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.alignment == FlowAlignmentCenter) {
        return [self centerAttributesAtIndexPath:indexPath];
    }
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    return [self layoutAttributesForItem:attributes atIndexPath:indexPath];
}

#pragma mark - Private

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElements:(NSArray<UICollectionViewLayoutAttributes *> *)attributes
{
    NSMutableArray<UICollectionViewLayoutAttributes *> *alignedAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *a in attributes) {
        [alignedAttributes addObject:[self layoutAttributesForItem:a atIndexPath:a.indexPath]];
    }
    
    return [alignedAttributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItem:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
{
    switch (self.alignment) {
        case FlowAlignmentLeft:    return [self leftAttributes:attributes   atIndexPath:indexPath];
        case FlowAlignmentRight:   return [self rightAttributes:attributes  atIndexPath:indexPath];
        case FlowAlignmentJustyfied:
        default:
            return attributes;
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)leftAttributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
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


- (UICollectionViewLayoutAttributes *)rightAttributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
{
    // Checks if first item in section (and row)
    if (indexPath.item == [self.collectionView numberOfItemsInSection:indexPath.section] - 1) {
        [attributes rightAlignFrame:CGRectGetWidth(self.collectionView.bounds) - self.minimumLineSpacing];
        return attributes;
    }
    
    UICollectionViewLayoutAttributes *next = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item + 1
                                                                                                          inSection:indexPath.section]].copy;
    const CGRect frame = next.frame;
    const CGFloat left = CGRectGetMinX(frame) - self.minimumInteritemSpacing;
    
    // Checks if first item in row
    if (left < CGRectGetMaxX(attributes.frame)) {
        [attributes rightAlignFrame:CGRectGetWidth(self.collectionView.bounds) - self.minimumLineSpacing];
        return attributes;
    }
    
    [attributes rightAlignFrame:left];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)centerAttributesAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cache[indexPath]) {
        return self.cache[indexPath];
    }
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    NSMutableArray *itemsInRow = [NSMutableArray array];
    
    const NSInteger totalInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
    const CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    const CGRect rowFrame = CGRectMake(0, CGRectGetMinY(attributes.frame), width, CGRectGetHeight(attributes.frame));

    // Go forward
    NSInteger index = indexPath.row;
    while(index++ < totalInSection - 1) {

        UICollectionViewLayoutAttributes *next = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index
                                                                                                               inSection:indexPath.section]];
        
        if (!CGRectIntersectsRect(next.frame, rowFrame)) {
            break;
        }
        
        [itemsInRow addObject:next];
    }
    
    // Current item
    [itemsInRow addObject:attributes];
    
    // Go backward
    index = indexPath.row;
    while (index-- > 0) {
        UICollectionViewLayoutAttributes *prev = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index
                                                                                                               inSection:indexPath.section]];
        
        if (!CGRectIntersectsRect(prev.frame, rowFrame)) {
            break;
        }
        
        [itemsInRow addObject:prev];
    }
    
    // Items width with spacings
    CGFloat totalWidth = self.minimumInteritemSpacing * (itemsInRow.count - 1);
    for (UICollectionViewLayoutAttributes *item in itemsInRow) {
        totalWidth += CGRectGetWidth(item.frame);
    }
    
    CGRect prevRect = CGRectZero;
    for (UICollectionViewLayoutAttributes *item in itemsInRow) {
        
        CGRect frame = item.frame;
        if (CGRectEqualToRect(prevRect, CGRectZero)) {
            frame.origin.x = (width - totalWidth) / 2.0f;
        } else {
            frame.origin.x = CGRectGetMaxX(prevRect) + self.minimumInteritemSpacing;
        }
        item.frame = frame;
        prevRect = frame;
        
        self.cache[item.indexPath] = item;
    }
    
    self.cache[indexPath] = attributes;
    return attributes;
}

@end
