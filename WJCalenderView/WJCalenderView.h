//
//  WJCalenderView.h
//  HYCalendar
//
//  Created by 谭启宏 on 15/12/24.
//  Copyright © 2015年 nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJCalenderHeadView;
@class WJCalenderItem;
@class WJCalenderItemModel;

//状态的枚举
typedef NS_OPTIONS(NSUInteger, WJCalenderItemStatusStyle) {
    WJCalenderItemStatusStyle_NORMEL,//普通状态
    WJCalenderItemStatusStyle_ADD, //补签
    WJCalenderItemStatusStyle_NO_ENABEL,//不能点击灰色
    WJCalenderItemStatusStyle_TODAY,//今天
    WJCalenderItemStatusStyle_HAVE,//已经签到
    
};

@protocol WJCalenderViewDelegate <NSObject>

- (void)WJCalenderViewDidDone;
- (void)WJCalenderViewDidItem:(WJCalenderItem *)item;

@end

//日历,主题自定义系数高
//🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩
@interface WJCalenderView : UIView

@property (nonatomic,strong)WJCalenderItem *selctItem;//选中的item
@property (nonatomic,assign)BOOL thisMonth;//是否是当前月，默认为yes


/** 使用例子
NSMutableArray *array = [[NSMutableArray alloc]init];
for (int i = 0; i < 42; i ++) {
    WJCalenderItemModel *model = [WJCalenderItemModel new];
    if (i > 20 && i < 25) {
        model.status = WJCalenderItemStatusStyle_ADD;
    }
    
    else if (i==3) {
        model.status = WJCalenderItemStatusStyle_HAVE;
    }else {
        model.status = WJCalenderItemStatusStyle_NORMEL;
    }
    [array addObject:model];
}
[calender setItemDataArray:array];
 **/

//添加数据
- (void)setItemDataWithdate:(NSDate *)date;
- (void)setItemDataWithdate:(NSDate *)date array:(NSArray <WJCalenderItemModel *>*)array;
- (void)setItemDataArray:(NSArray <WJCalenderItemModel *>*)array;

//代理
@property (nonatomic,assign)id<WJCalenderViewDelegate>delegate;

@end


@protocol WJCalenderHeadViewDelagete <NSObject>

- (void)WJCalenderHeadViewDidPressedIsLeft:(BOOL)isLeft;
@end


//item
@interface WJCalenderItem : UIButton

@property (nonatomic,assign)WJCalenderItemStatusStyle status; //状态枚举 (逻辑在status的set方法里面)
@property (nonatomic,strong)UIImageView *contentImage;
@property (nonatomic,strong)UILabel *contentlabel;
@property (nonatomic,assign)NSInteger uid;

@end


//头部视图
@interface WJCalenderHeadView : UIView

@property (nonatomic,assign)id<WJCalenderHeadViewDelagete>delegate;
@property (nonatomic,strong)UILabel *titleLabel;

@end

//item的模型
@interface WJCalenderItemModel : NSObject

@property (nonatomic,assign)WJCalenderItemStatusStyle status;

@end

@interface NSDate (NSCalendar)

+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
+ (NSDate *)lastMonth:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date;


@end

