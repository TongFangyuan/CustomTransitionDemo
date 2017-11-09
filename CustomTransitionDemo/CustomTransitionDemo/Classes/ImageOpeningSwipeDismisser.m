//
//  ImageOpeningSwipeDismisser.m
//  PapaQuanLife
//
//  Created by tongfy on 2017/10/31.
//  Copyright © 2017年 PPQ. All rights reserved.
//

#import "ImageOpeningSwipeDismisser.h"
#import "ViewController.h"
#import "VideoDetailsViewController.h"
#import "ImageCollectionViewCell.h"
#import "PlayerCollectionViewCell.h"

@implementation ImageOpeningSwipeDismisser

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    VideoDetailsViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *targetViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    
    NSIndexPath *selectedIndexPath = [sourceViewController.collectionView indexPathForItemAtPoint:[sourceViewController.collectionView convertPoint:sourceViewController.view.center fromView:sourceViewController.view.superview]];
    
    // 列表滚动到合适的位置
    [targetViewController.collectionView scrollToItemAtIndexPath:selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    PlayerCollectionViewCell *selectedPlayerCell = (PlayerCollectionViewCell *)[sourceViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
    
    UIView *snapshot = [sourceViewController.view snapshotViewAfterScreenUpdates:YES];
    snapshot.frame = [containerView convertRect:sourceViewController.view.frame fromView:sourceViewController.view.superview];
    snapshot.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [containerView addSubview:snapshot];

    
    ImageCollectionViewCell *targetImageCell = (ImageCollectionViewCell *)[targetViewController.collectionView cellForItemAtIndexPath:selectedIndexPath];
    targetImageCell.backgroundColor = selectedPlayerCell.backgroundColor;
    targetImageCell.hidden = YES;
    sourceViewController.view.alpha = 0.0f;

    [UIView animateWithDuration:animationDuration animations:^{
        snapshot.frame = [containerView convertRect:targetImageCell.imageView.frame fromView:targetImageCell.imageView.superview];

    } completion:^(BOOL finished) {
        
        [snapshot removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        targetImageCell.hidden = NO;
    }];

}

@end
