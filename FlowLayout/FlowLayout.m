//
//  FlowLayout.m
//  FlowLayout
//
//  Created by Grigory Avdyushin on 20.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "FlowLayout.h"

@interface FlowLayout() { }
@property (strong, nonatomic) NSCache *cache;
@end

@implementation FlowLayout

- (void)setAlignment:(FlowAlignment)alignment
{
    _alignment = alignment;
    [self invalidateLayout];
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.cache = [NSCache new];
}

- (void)invalidateLayout
{
    [super invalidateLayout];
    self.cache = [NSCache new];
}

- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
{
    return YES;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;
    if (self.alignment == FlowAlignmentJustyfied) {
        return attributes;
    }
    return [self layoutAttributesForElements:attributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.alignment == FlowAlignmentJustyfied) {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
    return [self attributesAtIndexPath:indexPath];
}

#pragma mark - Private

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElements:(NSArray<UICollectionViewLayoutAttributes *> *)attributes
{
    NSMutableArray<UICollectionViewLayoutAttributes *> *alignedAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *item in attributes) {
        if(item.representedElementKind != nil) {
            [alignedAttributes addObject:item];
        } else {
            [alignedAttributes addObject:[self layoutAttributesForItem:item atIndexPath:item.indexPath]];
        }
    }
    
    return alignedAttributes.copy;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItem:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
{
    return [self attributes:attributes atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    return [self attributes:attributes atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)attributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cache objectForKey:indexPath]) {
        return [self.cache objectForKey:indexPath];
    }
    
    NSMutableArray *itemsInRow = [NSMutableArray array];
    
    const NSInteger totalInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
    const CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    const CGRect rowFrame = CGRectMake(0, CGRectGetMinY(attributes.frame), width, CGRectGetHeight(attributes.frame));

    // Go forward to the end or the row or section items
    NSInteger index = indexPath.row;
    while(index++ < totalInSection - 1) {

        UICollectionViewLayoutAttributes *next = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index
                                                                                                               inSection:indexPath.section]].copy;
        
        if (!CGRectIntersectsRect(next.frame, rowFrame)) {
            break;
        }
        [itemsInRow addObject:next];
    }
    
    // Current item
    [itemsInRow addObject:attributes];
    
    // Go backward to the start of the row or first item
    index = indexPath.row;
    while (index-- > 0) {
        
        UICollectionViewLayoutAttributes *prev = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index
                                                                                                               inSection:indexPath.section]].copy;
        
        if (!CGRectIntersectsRect(prev.frame, rowFrame)) {
            break;
        }
        [itemsInRow addObject:prev];
    }
    
    // Total items width include spacings
    CGFloat totalWidth = self.minimumInteritemSpacing * (itemsInRow.count - 1);
    for (UICollectionViewLayoutAttributes *item in itemsInRow) {
        totalWidth += CGRectGetWidth(item.frame);
    }
    
    // Correct sorting in row
    [itemsInRow sortUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
        return obj1.indexPath.row > obj2.indexPath.row;
    }];
    
    CGRect rect = CGRectZero;
    for (UICollectionViewLayoutAttributes *item in itemsInRow) {
        
        CGRect frame = item.frame;
        CGFloat x = frame.origin.x;
        
        if (CGRectIsEmpty(rect)) {
            switch (self.alignment) {
                case FlowAlignmentLeft:
                    x = self.sectionInset.left;
                    break;
                case FlowAlignmentCenter:
                    x = (width - totalWidth) / 2.0f;
                    break;
                case FlowAlignmentRight:
                    x = width - totalWidth - self.sectionInset.right;
                default:
                    break;
            }
        } else {
            x = CGRectGetMaxX(rect) + self.minimumInteritemSpacing;
        }
        
        frame.origin.x = x;
        item.frame = frame;
        rect = frame;
        
        [self.cache setObject:item forKey:item.indexPath];
    }
    
    [self.cache setObject:attributes forKey:indexPath];
    return attributes;
}

@end
