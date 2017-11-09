//
//  ImageOpeningPresenter.m
//  PapaQuanLife
//
//  Created by tongfy on 2017/10/18.
//  Copyright © 2017年 PPQ. All rights reserved.
//

#import "ImageOpeningPresenter.h"
#import "ViewController.h"
#import "VideoDetailsViewController.h"
#import "ImageCollectionViewCell.h"
#import "PlayerCollectionViewCell.h"

@implementation ImageOpeningPresenter

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ViewController *sourceViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    VideoDetailsViewController *targetViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    
    NSIndexPath *selectIndexPath = [[sourceViewController.collectionView indexPathsForSelectedItems] firstObject];
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[sourceViewController.collectionView cellForItemAtIndexPath:selectIndexPath];
    UIImage *selectImage = cell.imageView.image;
    
    CGRect selectCellFrame = [containerView convertRect:cell.imageView.frame fromView:cell.imageView.superview];
    UIView *selectedImageWrapperView = [[UIView alloc] initWithFrame:selectCellFrame];
    selectedImageWrapperView.backgroundColor = cell.backgroundColor;
    selectedImageWrapperView.clipsToBounds = YES;
    
    ///
    targetViewController.selectedIndexPath = selectIndexPath;
    [targetViewController.collectionView scrollToItemAtIndexPath:selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    PlayerCollectionViewCell *targetCell = (PlayerCollectionViewCell *)[targetViewController.collectionView cellForItemAtIndexPath:selectIndexPath];
    targetCell.backgroundColor = cell.backgroundColor;
    targetViewController.transitionImageView.image = selectImage;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:selectImage];
    imageView.frame = CGRectMake(0, 0, CGRectGetWidth(selectCellFrame), CGRectGetHeight(selectCellFrame));
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [selectedImageWrapperView addSubview:imageView];
    
    [containerView addSubview:selectedImageWrapperView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:targetViewController.view.frame];
    whiteView.backgroundColor = [UIColor clearColor];
    [containerView insertSubview:whiteView belowSubview:selectedImageWrapperView];
    
    targetViewController.view.alpha = 0.0;
    [containerView addSubview:targetViewController.view];
    
    // 获取图片最终 frame
    CGRect imageViewFinalFrame = [containerView convertRect:CGRectMake(0.0, 0.0, CGRectGetWidth(targetViewController.view.frame), CGRectGetHeight(targetViewController.view.frame)) fromView:targetViewController.view];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         selectedImageWrapperView.frame = imageViewFinalFrame;
                         whiteView.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished) {

                         targetViewController.view.alpha = 1.0;
                         [targetViewController finishTransition];
                         
                         [selectedImageWrapperView removeFromSuperview];
                         [whiteView removeFromSuperview];
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}

@end
