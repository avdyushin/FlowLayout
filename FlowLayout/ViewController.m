//
//  ViewController.m
//  FlowLayout
//
//  Created by Grigory Avdyushin on 20.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import "ViewController.h"
#import "TagCell.h"
#import "FlowLayout.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) FlowLayout *layout;
@end

@implementation ViewController

- (void)generateItems
{
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.numberStyle = NSNumberFormatterSpellOutStyle;
    NSMutableArray *array = [NSMutableArray array];
    const NSInteger count = 28;
    for (NSInteger i = 0; i < count; ++i) {
        [array addObject:[NSString stringWithFormat:@"%@", [nf stringFromNumber:@(i)]]];
    }
    for (NSInteger i = 0; i < count - 1; ++i) {
        id peek = [array objectAtIndex:i + arc4random_uniform((int)(count - i))];
        [array replaceObjectAtIndex:i withObject:peek];
    }
    self.items = array.copy;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self generateItems];
    self.layout = [[FlowLayout alloc] init];
    self.layout.alignment = FlowAlignmentCenter;
    self.layout.estimatedItemSize = CGSizeMake(80, 30);
    self.layout.sectionInset = UIEdgeInsetsMake(20, 30, 20, 30);
    self.layout.headerReferenceSize = CGSizeMake(300, 30);
    self.layout.footerReferenceSize = CGSizeMake(300, 30);
    self.collectionView.collectionViewLayout = self.layout;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TagHeader" forIndexPath:indexPath];
    } else if (kind == UICollectionElementKindSectionFooter) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TagFooter" forIndexPath:indexPath];
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    cell.maxWidthConstraint.constant = CGRectGetWidth(collectionView.bounds) - self.layout.sectionInset.left - self.layout.sectionInset.right - cell.layoutMargins.left - cell.layoutMargins.right - 10;
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (IBAction)onLeft:(id)sender
{
    self.layout.alignment = FlowAlignmentLeft;
}

- (IBAction)onCenter:(id)sender
{
    self.layout.alignment = FlowAlignmentCenter;
}

- (IBAction)onJustified:(id)sender
{
    self.layout.alignment = FlowAlignmentJustyfied;
}

- (IBAction)onRight:(id)sender
{
    self.layout.alignment = FlowAlignmentRight;
}

- (IBAction)onRefresh:(id)sender
{
    [self generateItems];
    [self.collectionView reloadData];
}

@end
