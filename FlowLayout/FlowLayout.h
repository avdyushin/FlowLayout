//
//  FlowLayout.h
//  FlowLayout
//
//  Created by Grigory Avdyushin on 20.07.16.
//  Copyright © 2016 Grigory Avdyushin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FlowAlignment) {
    FlowAlignmentJustyfied,
    FlowAlignmentLeft,
    FlowAlignmentCenter,
    FlowAlignmentRight
};

@interface FlowLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) FlowAlignment alignment;

@end
