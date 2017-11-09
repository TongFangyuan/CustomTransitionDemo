//
//  ImageCollectionViewCell.m
//  PapaQuanLife
//
//  Created by tongfy on 2017/10/18.
//  Copyright © 2017年 PPQ. All rights reserved.
//

#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell()



@end

@implementation ImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
