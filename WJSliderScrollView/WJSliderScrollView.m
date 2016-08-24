//
//  WJSliderScrollView.m
//  WJSliderView
//
//  Created by 谭启宏 on 15/12/18.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import "WJSliderScrollView.h"
#import "WJSliderView.h"

@interface WJSliderScrollView ()<UIScrollViewDelegate,WJSliderViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)WJSliderView *sliderView;

@property (nonatomic,assign)NSInteger arrayCount;
@property (nonatomic,assign)BOOL shoulScroll;
@end

@implementation WJSliderScrollView

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.sliderView.frame.size.height, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-self.sliderView.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame itemArray:(NSArray<UIView *> *)itemArray contentArray:(NSArray<UIView *>*)contentArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self commonInitWithItemArray:itemArray contentArray:contentArray];
    }
    return self;
}

- (void)commonInitWithItemArray:(NSArray<UIView *> *)itemArray contentArray:(NSArray<UIView *>*)contentArray {
    self.arrayCount = itemArray.count;
    
    self.sliderView = [[WJSliderView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 50) Array:itemArray];
    self.sliderView.delegate = self;
    self.sliderView.isUseIndexProgress = YES;
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*itemArray.count, CGRectGetHeight(self.bounds)-self.sliderView.frame.size.height);
    [contentArray enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.frame = CGRectMake(idx*CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [self.scrollView addSubview:view];
    }];
    [self addSubview:self.sliderView];
    [self addSubview:self.scrollView];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat f = scrollView.contentOffset.x/self.bounds.size.width;
    self.sliderView.indexProgress = f;
}

#pragma mark - <WJSliderViewDelegate>

- (void)WJSliderViewDidIndex:(NSInteger)index {
    
    [self.scrollView setContentOffset:CGPointMake(index*CGRectGetWidth(self.bounds), self.scrollView.contentOffset.y) animated:YES];
}

@end
