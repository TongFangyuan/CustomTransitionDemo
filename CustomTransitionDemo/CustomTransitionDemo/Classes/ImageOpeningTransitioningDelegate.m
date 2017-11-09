//
//  ImageOpeningTransitioningDelegate.m
//  PapaQuanLife
//
//  Created by tongfy on 2017/10/18.
//  Copyright © 2017年 PPQ. All rights reserved.
//

#import "ImageOpeningTransitioningDelegate.h"
#import "ImageOpeningPresenter.h"
#import "ImageOpeningDismisser.h"
#import "ImageOpeningSwipeDismisser.h"

@implementation ImageOpeningTransitioningDelegate

#pragma mark - present
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [ImageOpeningPresenter new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissInteractor.shouldFinish ? [ImageOpeningSwipeDismisser new] : [ImageOpeningDismisser new];
}


- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.dismissInteractor.hasStarted ? self.dismissInteractor : nil;
}

@end
