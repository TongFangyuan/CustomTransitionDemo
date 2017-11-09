# CustomTransitionDemo
今日头条小视频动画过渡效果实现

### 效果图
![image](./demo.gif)<br /><br /><br />

### 原理
自动定义 `present` 和 `dismiss` 动画,设置 `viewController` 的 `transitioningDelegate` 为自定义类对象(`ImageOpeningTransitioningDelegate`),自己实现过渡动画即可,本文主要讲解`present`过渡实现

###
demo 中 Present Controller 主要代码
-------
    if (!self.customTransitioningDelegate) {
    self.customTransitioningDelegate = [ImageOpeningTransitioningDelegate new];
    }
    VideoDetailsViewController *detailsViewController = [[VideoDetailsViewController alloc] init];
    detailsViewController.transitioningDelegate = self.customTransitioningDelegate;
    detailsViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:detailsViewController animated:YES completion:nil];


1.设置 `transitioningDelegate` 为`self.customTransitioningDelegate`,该对象遵循`UIViewControllerTransitioningDelegate`协议,
------
    /// UIViewControllerTransitioningDelegate 协议方法
    @protocol UIViewControllerTransitioningDelegate <NSObject>

    @optional
    
    // present 控制器调用
    - (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
    
    // dismiss 控制器调用
    - (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;

    ...

    @end
    
2.在 present 控制器时,会调用其`animationControllerForPresentedController:presentingController:`方法,该方法需要返回一个遵守`UIViewControllerAnimatedTransitioning`协议的对象,这里我们单独抽象出一个类(`ImageOpeningPresenter`),
------
    -(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
    {
    return [ImageOpeningPresenter new];
    }

#### UIViewControllerAnimatedTransitioning 协议需要实现的方法
------
    @protocol UIViewControllerAnimatedTransitioning <NSObject>

    // 过渡动画需要的事件
    - (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;
    // 过渡上下文, transitionContext 包含参与过渡的对象,比如目标控制器和源控制器,拿到这两个控制器我们就可以写交互动画了
    - (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;

    @optional
