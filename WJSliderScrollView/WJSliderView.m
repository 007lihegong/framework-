//
//  WJSliderView.m
//  WJSliderView
//
//  Created by 谭启宏 on 15/12/18.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import "WJSliderView.h"

@interface WJSliderView ()

@property (nonatomic,strong)UIView *sliderView;
@property (nonatomic,assign)NSInteger index; //下标


@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;

@property (nonatomic,assign)CGFloat slider_center_x;
@property (nonatomic,assign)CGFloat slider_center_y;
@end

@implementation WJSliderView

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0,self.height-3, self.width, 3)];
        _sliderView.backgroundColor = [UIColor redColor];
        self.slider_center_x = _sliderView.center.x;
        self.slider_center_y = _sliderView.center.y;
    }
    return _sliderView;
}

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray<UIView *> *)array {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithArray:array];
    }
    return self;
}

//核心类
- (void)commonInitWithArray:(NSArray<UIView *> *)array {
    self.width = self.frame.size.width/array.count;
    self.height = self.frame.size.height;
    
    [self addSubview:self.sliderView];
    
    [array enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.frame = CGRectMake(idx * self.width, 0, self.width, self.height-3);
        view.userInteractionEnabled = YES;
        view.tag = idx + 10;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed:)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
    }];
    
}

#pragma mark - 事件监听 

- (void)tapPressed:(UITapGestureRecognizer *)sender {
    self.index = sender.view.tag - 10;
    if (!self.isUseIndexProgress) {
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderView.center = CGPointMake(self.slider_center_x+self.index*self.width,self.slider_center_y);
        }];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(WJSliderViewDidIndex:)]) {
        [_delegate WJSliderViewDidIndex:self.index];
    }
}

- (void)setIndexProgress:(CGFloat)indexProgress {
    _indexProgress = indexProgress;
    self.isUseIndexProgress = YES;
    self.sliderView.center = CGPointMake(self.slider_center_x + _indexProgress * self.width,self.slider_center_y);
}

@end
