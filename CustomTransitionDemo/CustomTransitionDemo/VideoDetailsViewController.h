//
//  VideoDetailsViewController.h
//  CustomTransitionDemo
//
//  Created by tongfy on 2017/11/9.
//  Copyright © 2017年 tongfy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interactor.h"

@interface VideoDetailsViewController : UIViewController

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,weak) Interactor *interactor;
@property (nonatomic,strong) NSMutableArray *videos;
@property (nonatomic,strong) UIImageView *transitionImageView;

@property (nonatomic,copy) void(^begainSwipeBlock)(NSIndexPath *indexPath);
- (void)setSwipeBegainBlock:(void(^)(NSIndexPath *selectedIndexPath))block;

@property (nonatomic,copy) void(^showBlock)(BOOL show);
- (void)setShowAllCellBlock:(void(^)(BOOL show))block;

- (void)finishTransition;

@end
