//
//  WJTransiation_Present.h
//  Translation
//
//  Created by 谭启宏 on 15/12/23.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WJTransiation_PresentType) {
    WJTransiation_PresentTypePresent = 0,
    WJTransiation_PresentTypeDismiss
};

//实现present转场

@interface WJTransiation_Present : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(WJTransiation_PresentType)type;
- (instancetype)initWithTransitionType:(WJTransiation_PresentType)type;


/**
 1.设置代理
 - (instancetype)init
 {
 self = [super init];
 if (self) {
 self.transitioningDelegate = self;
 self.modalPresentationStyle = UIModalPresentationCustom;
 }
 return self;
 }
 2.添加协议<UIViewControllerTransitioningDelegate>
 3.重写协议方法 － 在协议方法里面初始化
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
 
 }
 
 - (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
 
 }
 **/

@end
