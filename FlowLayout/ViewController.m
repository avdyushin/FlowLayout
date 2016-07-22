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

- (void)generateItems {
    NSNumberFormatter *nf = [NSNumberFormatter new];
    nf.numberStyle = NSNumberFormatterSpellOutStyle;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 48; ++i) {
        [array addObject:[NSString stringWithFormat:@"%@", [nf stringFromNumber:@(i)]]];
    }
    self.items = array.copy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self generateItems];
    self.layout = [[FlowLayout alloc] init];
    self.layout.alignment = FlowAlignmentRight;
    self.layout.estimatedItemSize = CGSizeMake(80, 30);
    self.layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    self.collectionView.collectionViewLayout = self.layout;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    cell.maxWidthConstraint.constant = CGRectGetWidth(collectionView.bounds) - self.layout.sectionInset.left - self.layout.sectionInset.right - cell.layoutMargins.left - cell.layoutMargins.right;
    cell.textLabel.numberOfLines = 1;
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (IBAction)onLeft:(id)sender
{
    self.layout.alignment = FlowAlignmentLeft;
    [self.layout invalidateLayout];
}

- (IBAction)onCenter:(id)sender
{
    self.layout.alignment = FlowAlignmentCenter;
    [self.layout invalidateLayout];
}

- (IBAction)onRight:(id)sender
{
    self.layout.alignment = FlowAlignmentRight;
    [self.layout invalidateLayout];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
