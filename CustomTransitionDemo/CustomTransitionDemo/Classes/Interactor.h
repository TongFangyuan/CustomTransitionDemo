//
//  Interactor.h
//  PapaQuanLife
//
//  Created by tongfy on 2017/10/31.
//  Copyright © 2017年 PPQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Interactor : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL hasStarted;
@property (nonatomic, assign) BOOL shouldFinish;

@end
