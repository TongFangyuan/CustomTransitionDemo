//
//  ImageOpeningTransitioningDelegate.h
//  PapaQuanLife
//
//  Created by tongfy on 2017/10/18.
//  Copyright © 2017年 PPQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Interactor.h"

@interface ImageOpeningTransitioningDelegate : NSObject
<
UIViewControllerTransitioningDelegate
>

@property (nonatomic, strong) Interactor *dismissInteractor;

@end
