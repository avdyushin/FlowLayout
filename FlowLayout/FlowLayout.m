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

@end

@implementation FlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;
    return [self layoutAttributesForElements:attributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
        case FlowAlignmentCenter:  return [self centerAttributes:attributes atIndexPath:indexPath];
        case FlowAlignmentDefault: return attributes;
    }
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

- (UICollectionViewLayoutAttributes *)centerAttributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
{
    return attributes;
}

@end
