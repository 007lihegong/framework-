//
//  WJAlertController.h
//  alertControl
//
//  Created by 谭启宏 on 15/12/25.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WJAlertControllerStyle) {
    WJAlertControllerStyleAlert = 0,    //警告框类型，中间
    WJAlertControllerStyleActionSheet   //ActionSheet类型，底部
};

//弹出alertView的控制器,注意里面加了键盘监听，不需要的话请移除,需要第三方自动布局 Masonry
@interface WJAlertController : UIViewController

@property (nonatomic, strong, readonly) UIView *alertView;//自定义的视图

@property (nonatomic, strong) UIView *backgroundView; // 设置背景或者添加自定义背景

@property (nonatomic, assign, readonly) WJAlertControllerStyle preferredStyle;//弹出的风格

@property (nonatomic, assign, readonly) NSInteger transitionAnimation;//动画效果在类目里面设置（因为种类可能有很多所以写成这样不用枚举）

@property (nonatomic, assign) BOOL backgoundTapDismissEnable;  // default NO

@property (nonatomic, assign) CGFloat actionSheetStyleBottomEdging; // default 0
@property (nonatomic, assign) CGFloat actionSheetStyleLeftEdging; // default 0

@property (nonatomic, copy) void (^dismissComplete)(void); // dismiss 后可回调的事件

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(WJAlertControllerStyle)preferredStyle;

@end
