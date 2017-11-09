//
//  VideoDetailsViewController.m
//  CustomTransitionDemo
//
//  Created by tongfy on 2017/11/9.
//  Copyright © 2017年 tongfy. All rights reserved.
//

#import "VideoDetailsViewController.h"
#import "PlayerCollectionViewCell.h"

@interface VideoDetailsViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic,strong) UIButton *closedButton;
@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;

@end

@implementation VideoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.masksToBounds = YES;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.closedButton];
    [self.view insertSubview:self.transitionImageView belowSubview:self.collectionView];

    self.closedButton.frame = CGRectMake(15, 15, 44, 44);
    self.collectionView.frame = self.view.bounds;
    self.transitionImageView.frame = self.view.bounds;
    
    // 添加滑动 dismiss 手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dimissGesture:)];
    [self.view addGestureRecognizer:pan];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)leftBtnClicked
{
    if (self.showBlock) {
        self.showBlock(YES);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)finishTransition
{
    [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)setSwipeBegainBlock:(void (^)(NSIndexPath *))block
{
    self.begainSwipeBlock = block;
}

- (void)setShowAllCellBlock:(void (^)(BOOL))block
{
    self.showBlock = block;
}


- (void)dimissGesture:(UIPanGestureRecognizer *)pan
{
    //    NSLog(@"%@",pan);
    CGFloat percentThreshold = 0.2;
    CGPoint translation = [pan translationInView:self.view];
    CGFloat verticalMovement = fabs(translation.y) / [UIScreen mainScreen].bounds.size.height;
    CGFloat downwardMovement = fmaxf(verticalMovement, 0.0);
    CGFloat downwardMovementPercent = fminf(downwardMovement, 1);
    CGFloat progress = downwardMovementPercent;
    
    //    NSLog(@"%@",NSStringFromCGPoint(translation));
    //    NSLog(@"progress:%f---percentThreshold:%f",progress,percentThreshold);
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.begainSwipeBlock) {
                NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:self.view.center fromView:self.view.superview]];
                self.begainSwipeBlock(selectedIndexPath);
            }
            self.interactor.hasStarted = YES;
            
            self.transitionImageView.hidden = NO;
            [self.transitionImageView.superview bringSubviewToFront:self.transitionImageView];
            
        } break;
        case UIGestureRecognizerStateChanged:
        {
            
            CGFloat width = [UIScreen mainScreen].bounds.size.width * (1.0-progress);
            CGFloat height = [UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width * width;
            
            self.view.frame = CGRectMake(translation.x, translation.y, width, height);
            self.transitionImageView.frame = self.view.bounds;
            
            self.interactor.shouldFinish = progress > percentThreshold;
            [self.interactor updateInteractiveTransition:progress];
            
        } break;
        case UIGestureRecognizerStateCancelled:
        {
            self.interactor.hasStarted = NO;
            [self.interactor cancelInteractiveTransition];
            [self toOriginalState];
        } break;
        case UIGestureRecognizerStateEnded:
        {
            self.interactor.hasStarted = NO;
            self.interactor.shouldFinish ? [self dismissViewControllerAnimated:YES completion:nil] : nil;
            self.interactor.shouldFinish ? [self.interactor finishInteractiveTransition] : [self.interactor cancelInteractiveTransition];
            self.interactor.shouldFinish ? nil : [self toOriginalState];
        }
        default:
            break;
    }
}

- (void)toOriginalState
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.frame = self.view.superview.bounds;
    } completion:^(BOOL finished) {
        [self.transitionImageView.superview sendSubviewToBack:self.transitionImageView];
        self.transitionImageView.hidden = YES;
    }];

}



#pragma mark - UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCollectionViewCell" forIndexPath:indexPath];
    NSString *imageName = _videos[indexPath.item];
    cell.videoPicture.image = [UIImage imageNamed:imageName];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.collectionView == scrollView) {
        
        /// ViewController 页面滚动到对应位置
        NSIndexPath *selectedIndexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:self.view.center fromView:self.view.superview]];
        if (self.begainSwipeBlock) {
            self.begainSwipeBlock(selectedIndexPath);
        }
        
        PlayerCollectionViewCell *cell = (PlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
        self.transitionImageView.image = cell.videoPicture.image;

    }
}


#pragma mark - property

- (UIImageView *)transitionImageView
{
    if (!_transitionImageView) {
        _transitionImageView = [UIImageView new];
        _transitionImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _transitionImageView;
}

- (UIButton *)closedButton
{
    if (!_closedButton) {
        _closedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closedButton setImage:[UIImage imageNamed:@"ic_play_close"] forState:UIControlStateNormal];
        _closedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _closedButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [_closedButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closedButton;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[PlayerCollectionViewCell class] forCellWithReuseIdentifier:@"PlayerCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


@end
