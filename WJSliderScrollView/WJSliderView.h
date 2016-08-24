//
//  WJSliderView.h
//  WJSliderView
//
//  Created by 谭启宏 on 15/12/18.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import <UIKit/UIKit.h>

//滑动视图,1,2,3,4或者1,2,3或者1,2类型的

@protocol WJSliderViewDelegate <NSObject>

- (void)WJSliderViewDidIndex:(NSInteger)index;

@end

@interface WJSliderView : UIView

@property (nonatomic,assign)CGFloat indexProgress;
@property (nonatomic,assign)BOOL isUseIndexProgress;//如果使用了indePressgress则,index失效，避免冲突

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray<UIView *> *)array;

@property (nonatomic,assign)id<WJSliderViewDelegate>delegate;


@end
