//
//  PlayerCollectionViewCell.m
//  PapaQuanLife
//
//  Created by tongfy on 2017/10/18.
//  Copyright © 2017年 PPQ. All rights reserved.
//

#import "PlayerCollectionViewCell.h"
#import <AVKit/AVKit.h>

@interface PlayerCollectionViewCell()

@end

@implementation PlayerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
        self.contentView.clipsToBounds = YES;
        _videoPicture = [UIImageView new];
        _videoPicture.contentMode = UIViewContentModeScaleAspectFill;
        _videoPicture.clipsToBounds = YES;
        [self.contentView addSubview:self.videoPicture];
        self.videoPicture.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    }
    return self;
}

@end
