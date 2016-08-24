//
//  WJTransiation_Mobile.h
//  Translation
//
//  Created by 谭启宏 on 15/12/23.
//  Copyright © 2015年 谭启宏. All rights reserved.
//


#import <UIKit/UIKit.h>

@class WJTransiationBaseControl;

/**
 *  动画过渡代理管理的是push还是pop
 */
typedef NS_ENUM(NSUInteger, WJTransiation_MobileType) {
    WJTransiation_MobileTypePush = 0,
    WJTransiation_MobileTypePop
};

//动态添加transiationView属性

@interface UIViewController (transiationView)

@property (nonatomic,strong)UIView *transiationView;

@end

/**
 push转场
 如果要实现这个过渡动画要实现以下步骤
 1.self.navigationController.delegate = vc; //push的时候必须写这句话
 2.第二个控制器.h文件添加<UINavigationControllerDelegate>协议
 3.在<UINavigationControllerDelegate>协议方法里面初始化WJTransiation_Mobile
 
 - (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
 
 }
 **/

@interface WJTransiation_Mobile : NSObject<UIViewControllerAnimatedTransitioning>

/**
 *  初始化动画过渡代理
 */

+ (instancetype)transitionWithType:(WJTransiation_MobileType)type fromView:(UIView *)fromView toView:(UIView *)toView;
- (instancetype)initWithTransitionType:(WJTransiation_MobileType)type fromView:(UIView *)fromView toView:(UIView *)toView;


@end




