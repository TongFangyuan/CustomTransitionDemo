//
//  ImageOpeningDismisser.m
//  PapaQuanLife
//
//  Created by tongfy on 2017/10/18.
//  Copyright © 2017年 PPQ. All rights reserved.
//

#import "ImageOpeningDismisser.h"
#import "ViewController.h"
#import "VideoDetailsViewController.h"
#import "ImageCollectionViewCell.h"
#import "PlayerCollectionViewCell.h"

@implementation ImageOpeningDismisser

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"%@",transitionContext);
    ViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    VideoDetailsViewController *targetViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    
    NSIndexPath *selectedIndexPath = [sourceViewController.collectionView indexPathForItemAtPoint:[sourceViewController.collectionView convertPoint:sourceViewController.view.center fromView:sourceViewController.view.superview]];
    
    // 列表滚动到合适的位置
    [targetViewController.collectionView scrollToItemAtIndexPath:selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    PlayerCollectionViewCell *selectedPlayerCell = (PlayerCollectionViewCell *)[sourceViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
    
    UIView *snapshot = [selectedPlayerCell snapshotViewAfterScreenUpdates:YES];
    snapshot.frame = [containerView convertRect:selectedPlayerCell.frame fromView:selectedPlayerCell.superview];
    snapshot.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    ImageCollectionViewCell *targetImageCell = (ImageCollectionViewCell *)[targetViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
    targetImageCell.backgroundColor = selectedPlayerCell.backgroundColor;
    
    UIView *imageWrapperView = [[UIView alloc] initWithFrame:[containerView convertRect:selectedPlayerCell.frame fromView:selectedPlayerCell.superview]];
    imageWrapperView.clipsToBounds = YES;
    [imageWrapperView addSubview:snapshot];
    [containerView addSubview:imageWrapperView];
    
    UIView *whiteBackgroundView = [[UIView alloc] initWithFrame:sourceViewController.view.frame];
    [containerView insertSubview:whiteBackgroundView belowSubview:imageWrapperView];
    
    [UIView animateKeyframesWithDuration:animationDuration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
                                      sourceViewController.view.alpha = 0.0;
                                      imageWrapperView.frame = [containerView convertRect:targetImageCell.imageView.frame fromView:targetImageCell.imageView.superview];
                                      whiteBackgroundView.alpha = 0.0;
                                      targetImageCell.imageView.alpha = 1.0;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.95 relativeDuration:0.05 animations:^{
                                      targetImageCell.imageView.transform = CGAffineTransformIdentity;
                                      snapshot.alpha = 0.0;
                                  }];
                              }
                              completion:^(BOOL finished) {
                                  [whiteBackgroundView removeFromSuperview];
                                  [snapshot removeFromSuperview];
                                  [imageWrapperView removeFromSuperview];
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                  
                              }];
    
}

@end
