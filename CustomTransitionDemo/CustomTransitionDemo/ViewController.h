//
//  ViewController.h
//  CustomTransitionDemo
//
//  Created by tongfy on 2017/11/9.
//  Copyright © 2017年 tongfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageOpeningTransitioningDelegate.h"

@interface ViewController : UIViewController

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *videos;
@property (nonatomic, strong) ImageOpeningTransitioningDelegate *customTransitioningDelegate;

@end

