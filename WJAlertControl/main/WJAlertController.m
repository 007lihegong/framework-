//
//  WJAlertController.m
//  alertControl
//
//  Created by 谭启宏 on 15/12/25.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import "WJAlertController.h"
#import "Masonry.h"
#import "WJAlertController+TransitionAnimate.h"

@interface WJAlertController ()

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, assign) WJAlertControllerStyle preferredStyle;

@property (nonatomic, assign) NSInteger transitionAnimation;

@property (nonatomic, weak) UITapGestureRecognizer *singleTap;

@property (nonatomic,assign)CGFloat alertViewCenterYOffset;
@property (nonatomic,assign)CGFloat alertViewCenterXOffset;
@end

@implementation WJAlertController

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(WJAlertControllerStyle)preferredStyle {
    
    //判断类型使用不同的过渡动画
    if (preferredStyle == WJAlertControllerStyleActionSheet) {
         return [[self alloc]initWithAlertView:alertView preferredStyle:preferredStyle transitionAnimation:0];
    }else {
         return [[self alloc]initWithAlertView:alertView preferredStyle:preferredStyle transitionAnimation:1];
    }
}

+ (instancetype)alertControllerWithAlertView:(UIView *)alertView preferredStyle:(WJAlertControllerStyle)preferredStyle transitionAnimation:(NSInteger)transitionAnimation {
    return [[self alloc]initWithAlertView:alertView preferredStyle:preferredStyle transitionAnimation:transitionAnimation];
}

- (instancetype)initWithAlertView:(UIView *)alertView preferredStyle:(WJAlertControllerStyle)preferredStyle transitionAnimation:(NSInteger)transitionAnimation {
    if (self = [self init]) {
        
        _alertView = alertView;
        _backgoundTapDismissEnable = YES;
        _preferredStyle = preferredStyle;
        _transitionAnimation = transitionAnimation;
        [self configureController];
    
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addBackgroundView];
    [self addSingleTapGesture];
    [self configureAlertView];
    [self.view layoutIfNeeded];
    
    if (_preferredStyle == WJAlertControllerStyleAlert) {
        // UIKeyboard Notification
        //键盘监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

#pragma mark - 背景视图

- (void)addBackgroundView {
    if (_backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _backgroundView = backgroundView;
    }
    _backgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    [self.view insertSubview:_backgroundView atIndex:0];
    [self.view addSubview:_backgroundView];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = backgroundView;
    }else if(_backgroundView != backgroundView) {
        [self.view insertSubview:backgroundView aboveSubview:_backgroundView];
        backgroundView.alpha = 0;
        
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 1;
        } completion:^(BOOL finished) {
            [_backgroundView removeFromSuperview]; //移除原来的添加新的
            _backgroundView = backgroundView;
            [self addSingleTapGesture];
        }];
    }
}

- (void)addSingleTapGesture
{
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.enabled = _backgoundTapDismissEnable; //单击手势是否有用
    [_backgroundView addGestureRecognizer:singleTap];
    _singleTap = singleTap; //得到单击手势
}

- (void)setBackgoundTapDismissEnable:(BOOL)backgoundTapDismissEnable
{
    _backgoundTapDismissEnable = backgoundTapDismissEnable;
    _singleTap.enabled = backgoundTapDismissEnable;
}

#pragma mark - configure

//核心配置
- (void)configureController {
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    //在WJAlertController+TransitionAnimate 写的转场过渡动画
    self.transitioningDelegate = self;
    _backgoundTapDismissEnable = NO;
    _actionSheetStyleBottomEdging = 0;
    _actionSheetStyleLeftEdging = 0;
}

//自定义视图添加的位置
- (void)configureAlertView {
    if (_alertView == nil) {
        NSLog(@"%@: 提示:alertView is nil",NSStringFromClass([self class]));
        return;
    }
    _alertView.userInteractionEnabled = YES;
    [self.view addSubview:_alertView];

    switch (_preferredStyle) {
        case WJAlertControllerStyleActionSheet:
            [self layoutActionSheetStyleView];
            break;
        case WJAlertControllerStyleAlert:
            [self layoutAlertStyleView];
            break;
        default:
            break;
    }
    
}

#pragma mark - layout

//actionsheet
- (void)layoutActionSheetStyleView {
   
    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.actionSheetStyleLeftEdging);
        make.right.mas_equalTo(-self.actionSheetStyleLeftEdging);
        make.bottom.mas_equalTo(-self.actionSheetStyleBottomEdging);
        make.height.mas_equalTo(_alertView.bounds.size.height);
    }];
    
  
}

//alertView
- (void)layoutAlertStyleView {

    [_alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_alertView.bounds.size);
        make.center.mas_equalTo(self.view);
    }];
    [_alertView layoutIfNeeded];
    _alertViewCenterYOffset = _alertView.center.y;
    _alertViewCenterXOffset = _alertView.center.x;
}

#pragma mark - 事件监听

- (void)singleTap:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated:(BOOL)animated
{
    [self dismissViewControllerAnimated:YES completion:self.dismissComplete];
}

#pragma mark - 通知
#pragma mark - notifycation

- (void)keyboardWillShow:(NSNotification*)notification{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat alertViewBottomEdge = CGRectGetHeight(self.view.frame) -  CGRectGetMaxY(_alertView.frame);
    CGFloat differ = CGRectGetHeight(keyboardRect) - alertViewBottomEdge;

    if (differ > 0) {
        //CGPointMake(self.view.center.x, _alertView.center.y - differ)
        [_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointMake(0, - differ));
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification{
    
    [_alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
