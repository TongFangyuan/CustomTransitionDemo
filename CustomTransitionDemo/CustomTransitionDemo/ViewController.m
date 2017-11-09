//
//  ViewController.m
//  CustomTransitionDemo
//
//  Created by tongfy on 2017/11/9.
//  Copyright © 2017年 tongfy. All rights reserved.
//

#define SCREEN_WIDTH          [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT         [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "ImageCollectionViewCell.h"
#import "VideoDetailsViewController.h"

@interface ViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic,strong) UIView *topBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _videos = [NSMutableArray array];
    for (int i=1; i<=14; i++) {
//        photo_sample_01
        NSString *imageName = [NSString stringWithFormat:@"photo_sample_%d",i];
        [_videos addObject:imageName];
    }
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topBar];
    
    self.topBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.topBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT-20);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    NSString *imageName = _videos[indexPath.item];
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.customTransitioningDelegate) {
        self.customTransitioningDelegate = [ImageOpeningTransitioningDelegate new];
    }
    self.customTransitioningDelegate.dismissInteractor = [Interactor new];
    
    VideoDetailsViewController *detailsViewController = [[VideoDetailsViewController alloc] init];
    detailsViewController.transitioningDelegate = self.customTransitioningDelegate;
    detailsViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    detailsViewController.interactor = self.customTransitioningDelegate.dismissInteractor;
    detailsViewController.videos = self.videos;
    
    __weak typeof(self) weakSelf = self;
    [detailsViewController setSwipeBegainBlock:^(NSIndexPath *selectedIndexPath) {
        [weakSelf.collectionView scrollToItemAtIndexPath:selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        [weakSelf.collectionView.subviews.copy enumerateObjectsUsingBlock:^(ImageCollectionViewCell   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
        ImageCollectionViewCell *targetCell = (ImageCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:selectedIndexPath];
        targetCell.hidden = YES;
        // NSLog(@"%@",targetCell.superview);
    }];

    [detailsViewController setShowAllCellBlock:^(BOOL show) {
        [weakSelf.collectionView.subviews.copy enumerateObjectsUsingBlock:^(ImageCollectionViewCell   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
    }];
    
    [self presentViewController:detailsViewController animated:YES completion:nil];
}


#pragma mark - properties
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-1.0) * 0.5,(SCREEN_HEIGHT-20-1.0) * 0.5);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = [UIColor whiteColor];
    }
    return _topBar;
}

@end
