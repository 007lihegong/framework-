//
//  WJTransiation_Mobile.m
//  Translation
//
//  Created by 谭启宏 on 15/12/23.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import "WJTransiation_Mobile.h"
#import <objc/runtime.h>

@implementation UIViewController (transiationView)

static char transiationViewKey;

- (void)setTransiationView:(UIView *)transiationView {
    return objc_setAssociatedObject(self, &transiationViewKey, transiationView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)transiationView {
     return objc_getAssociatedObject(self, &transiationViewKey);
}

@end

@interface WJTransiation_Mobile ()

/**
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) WJTransiation_MobileType type;
@property (nonatomic,strong)UIView *fromTransView;
@property (nonatomic,strong)UIView *toTransView;
@end

@implementation WJTransiation_Mobile

#pragma mark - 初始化
//
//+ (instancetype)transitionWithType:(WJTransiation_MobileType)type{
//    return [[self alloc] initWithTransitionType:type];
//}
//
//- (instancetype)initWithTransitionType:(WJTransiation_MobileType)type{
//    self = [super init];
//    if (self) {
//        _type = type;
//    }
//    return self;
//}

+ (instancetype)transitionWithType:(WJTransiation_MobileType)type fromView:(UIView *)fromView toView:(UIView *)toView {
    return [[self alloc] initWithTransitionType:type fromView:fromView toView:toView];
}

- (instancetype)initWithTransitionType:(WJTransiation_MobileType)type fromView:(UIView *)fromView toView:(UIView *)toView {
    self = [super init];
    if (self) {
        _type = type;
        self.fromTransView = fromView;
        self.toTransView = toView;
    }
    return self;
}

#pragma mark - <UIViewControllerAnimatedTransitioning>


/**
 *  动画时长
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.75;
}
/**
 *  如何执行过渡动画
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_type) {
        case WJTransiation_MobileTypePush:
            [self doPushAnimation:transitionContext];
            break;
            
        case WJTransiation_MobileTypePop:
            [self doPopAnimation:transitionContext];
            break;
    }
    
}

//原理：获取到cell中的imageview对象，将它截屏添加到转场视图中，位置大小信息，然后执行动画

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    fromVC.transiationView = self.fromTransView;
    toVC.transiationView = self.toTransView;
    
    //拿到当前点击的cell的imageView
    //记录着那个时候点击的indexPath
    UIView *containerView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    //得到这个image对象
    UIView *tempView = [fromVC.transiationView snapshotViewAfterScreenUpdates:NO];
    // 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    //就是将tableView里面的cell里面的imageView的坐标添加到containerView上
    tempView.frame = [fromVC.transiationView convertRect:fromVC.transiationView.bounds toView: containerView];
    //设置动画前的各个控件的状态
    fromVC.transiationView.hidden = YES; //因为截取了里面的imageview对象,所以将原来的cell中的imageview隐藏了
    toVC.view.alpha = 0;         //有个渐变的动画效果的话透明度0-1
    toVC.transiationView.hidden = YES;
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:toVC.view]; //新视图
    [containerView addSubview:tempView];  //原视图
    
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        tempView.frame = [toVC.transiationView convertRect:toVC.transiationView.bounds toView:containerView];
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        tempView.hidden = YES;          //完成后隐藏复制的imageView对象
        toVC.transiationView.hidden = NO;
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    fromVC.transiationView = self.fromTransView;
    toVC.transiationView = self.toTransView;

    UIView *containerView = [transitionContext containerView];
    //这里的lastView就是push时候初始化的那个tempView
    UIView *tempView = containerView.subviews.lastObject;
    //设置初始状态
    toVC.transiationView.hidden = YES;
    fromVC.transiationView.hidden = YES;
    tempView.hidden = NO;
    [containerView insertSubview:toVC.view atIndex:0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        tempView.frame = [toVC.transiationView convertRect:toVC.transiationView.bounds toView:containerView];
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {//手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            tempView.hidden = YES;
            fromVC.transiationView.hidden = NO;
        }else{//手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            toVC.transiationView.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}


@end


