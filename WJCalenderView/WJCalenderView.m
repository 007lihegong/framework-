//
//  WJCalenderView.m
//  HYCalendar
//
//  Created by 谭启宏 on 15/12/24.
//  Copyright © 2015年 nathan. All rights reserved.
//

#import "WJCalenderView.h"
#import "NSDate+extend.h"
#import "UIColor+Hex.h"

@interface WJCalenderView ()<WJCalenderHeadViewDelagete>

@property (nonatomic,strong)NSMutableArray *daysArray;//42个控件的数据天数1-31
@property (nonatomic,strong)UIView *contentView; //内容
@property (nonatomic,strong)UIView *headView;    //标题
@property (nonatomic,strong)WJCalenderHeadView *headContentView;//年份月份添加在headView上
@property (nonatomic,strong)UIView *weekView;    //星期视图
@property (nonatomic,strong)UIView *footerView;  //底部视图

@property (nonatomic,assign)NSInteger itemWidth; //单元宽度
@property (nonatomic,assign)NSInteger itemHeight;//单元高度

@property (nonatomic,strong)NSDate *date;

@end

@implementation WJCalenderView

- (NSDate *)date {
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

- (UIView *)headView {
    
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.itemHeight)];
       
        [self addheadSubViewFormView:_headView];
    }
    return _headView;
}

- (UIView *)weekView {
    if (!_weekView) {
        _weekView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), CGRectGetWidth(self.bounds), self.itemHeight)];
        _weekView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        [self addWeekSubViewFromView:_weekView];
    }
    return _weekView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.weekView.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(self.weekView.frame))];
       
        _contentView.backgroundColor = [UIColor colorWithHexString:@"ededed"];
        [self addContentSubViewFromView:_contentView];
    }
    return _contentView;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 50, CGRectGetWidth(self.bounds), 50)];
        _footerView.backgroundColor = [UIColor whiteColor];
        [self addFooterSubViewFromView:_footerView];
    }
    return _footerView;
   
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.thisMonth = YES;
        self.backgroundColor = [UIColor redColor];
        self.itemWidth    = self.frame.size.width / 7;
        self.itemHeight   = (self.frame.size.height - 50) / 8;
        [self comomoninit];
    }
    return self;
}

- (void)comomoninit {
    
    [self addSubview:self.headView];
    [self addSubview:self.weekView];
    [self addSubview:self.contentView];
    [self addSubview:self.footerView];
   
}

#pragma mark - 基本视图

- (void)addheadSubViewFormView:(UIView *)view {
    
    self.headContentView = [[WJCalenderHeadView alloc]initWithFrame:view.bounds];
    self.headContentView.delegate = self;
    [view addSubview:self.headContentView];
    
}

- (void)addWeekSubViewFromView:(UIView *)view{
    NSArray *array = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(self.itemWidth * i, 0, self.itemWidth, self.itemHeight);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor blackColor];
        [view addSubview:week];
    }
}

- (void)addContentSubViewFromView:(UIView *)view {
    for (NSInteger i = 0; i < 42; i++) {
        
        NSInteger x = (i % 7) * self.itemWidth ;
        NSInteger y = (i / 7) * self.itemHeight;

        WJCalenderItem *dayButton = [WJCalenderItem new]; //创建42个按钮
        dayButton.uid = i;
        dayButton.frame = CGRectMake(x, y, self.itemWidth, self.itemHeight);
        [dayButton addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:dayButton];
    }
}

- (void)addFooterSubViewFromView:(UIView *)view {
    
    UIButton *done= [UIButton buttonWithType:UIButtonTypeCustom];
    [done setFrame:CGRectMake(CGRectGetWidth(view.bounds)*0.2,10, CGRectGetWidth(view.bounds)*0.6, 30)];
    
    [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [done.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [done setBackgroundImage:[[UIImage imageNamed:@"b_com_bt_blue_normal"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
    [done setBackgroundImage:[[UIImage imageNamed:@"b_com_bt_blue_normal"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateSelected];
    [done setBackgroundImage:[[UIImage imageNamed:@"com_bt_gray_normal"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateDisabled];
    [done addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
    [done setTitle:@"确定" forState:UIControlStateNormal];
    [view addSubview:done];
    
}

#pragma mark -核心功能，设置签到

- (void)setItemDataArray:(NSArray<WJCalenderItemModel *> *)array {
    [self setItemDataWithdate:[NSDate date] array:array];
}

- (void)setItemDataWithdate:(NSDate *)date  {
    
    [self setItemDataWithdate:date array:nil];

}

- (void)setItemDataWithdate:(NSDate *)date array:(NSArray<WJCalenderItemModel *> *)array {
    
    [self.contentView .subviews enumerateObjectsUsingBlock:^(__kindof WJCalenderItem * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
        NSInteger daysInLastMonth = [NSDate totaldaysInMonth:[NSDate lastMonth:date]]; //下个月天数
        NSInteger daysInThisMonth = [NSDate totaldaysInMonth:date];                  //这个月天数
        NSInteger firstWeekday    = [NSDate firstWeekdayInThisMonth:date];           //这个月1号是星期几
        
        NSInteger day = 0;
        //判断初始位置
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            obj.status = WJCalenderItemStatusStyle_NO_ENABEL; //这里是颜色改变
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            obj.status = WJCalenderItemStatusStyle_NO_ENABEL;
            
        }else{
            day = i - firstWeekday + 1;
            obj.status = WJCalenderItemStatusStyle_NORMEL;
        }
        obj.contentlabel.text = [NSString stringWithFormat:@"%ld",day];
        if ([NSDate month:date] == [NSDate month:[NSDate date]]) {
            
            NSInteger todayIndex = [NSDate day:date] + firstWeekday - 1;
            
            //当月他前面的一些
            if (i < todayIndex && i >= firstWeekday) {
                //逻辑计算
                if (array.count>0 && array.count <= 42) {
                    WJCalenderItemModel *model =  array[i];
                    if (model.status == WJCalenderItemStatusStyle_ADD) {
                        obj.status = WJCalenderItemStatusStyle_ADD;
                    }else if (model.status == WJCalenderItemStatusStyle_HAVE){
                        obj.status = WJCalenderItemStatusStyle_HAVE;
                    }
                }
            }else if(i ==  todayIndex){
                if ([NSDate year:date] == [NSDate year:[NSDate date]]) {
                    obj.status = WJCalenderItemStatusStyle_TODAY;
                }
            }
        }
    }];

}



#pragma mark - WJCalenderHeadViewDelagete

//签到是一个月签到，不需要这个功能，这个功能是看每月的日期的
- (void)WJCalenderHeadViewDidPressedIsLeft:(BOOL)isLeft {
    if (!self.thisMonth) {
        if (isLeft) {
            self.date = [NSDate lastMonth:self.date];
            [self setItemDataWithdate:self.date]; //全新设置
            self.headContentView.titleLabel.text = [NSString stringWithFormat:@"%li年%li月",[NSDate year:self.date],[NSDate month:self.date]];
        }else {
            self.date = [NSDate nextMonth:self.date];
            [self setItemDataWithdate:self.date];
            self.headContentView.titleLabel.text = [NSString stringWithFormat:@"%li年%li月",[NSDate year:self.date],[NSDate month:self.date]];
        }
    }
}

- (void)donePressed {

    if (_delegate && [_delegate respondsToSelector:@selector(WJCalenderViewDidDone)]) {
        [_delegate WJCalenderViewDidDone];
    }
}

- (void)dayButtonPressed:(WJCalenderItem *)sender {

    if (sender.status == WJCalenderItemStatusStyle_TODAY) {
    
        if (_delegate && [_delegate respondsToSelector:@selector(WJCalenderViewDidItem:)]) {
            [_delegate WJCalenderViewDidItem:sender];
        }

    }else if (sender.status == WJCalenderItemStatusStyle_ADD) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(WJCalenderViewDidItem:)]) {
            [_delegate WJCalenderViewDidItem:sender];
        }
        
    }
}



@end


@implementation WJCalenderItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentImage = [[UIImageView alloc]init];
        self.contentImage.hidden = YES;
        self.enabled = NO;
        self.contentlabel = [[UILabel alloc]init];
        self.contentlabel.font = [UIFont systemFontOfSize:12];
        self.contentlabel.textColor = [UIColor blackColor];
        self.contentlabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.contentImage];
        [self addSubview:self.contentlabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentlabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.contentImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setStatus:(WJCalenderItemStatusStyle)status {
    _status = status;
    switch (status) {
        case WJCalenderItemStatusStyle_ADD:   //补签
            self.enabled = YES;
            self.contentImage.hidden = NO;
            self.contentImage.backgroundColor = [UIColor redColor];
            self.contentlabel.textColor = [UIColor blackColor];

            break;
        case WJCalenderItemStatusStyle_HAVE:    //已经签到
            self.enabled = NO;
            self.contentImage.hidden = NO;
            self.contentImage.backgroundColor = [UIColor yellowColor];
            self.contentlabel.textColor = [UIColor blackColor];

            break;
        case WJCalenderItemStatusStyle_NORMEL:    //普通
            self.enabled = YES;
            self.contentlabel.textColor = [UIColor blackColor];
            
            break;
        case WJCalenderItemStatusStyle_NO_ENABEL:   //不能点击
             self.enabled = NO;
            self.contentlabel.textColor = [UIColor colorWithHexString:@"bbbbbb"];
          
            break;
        case WJCalenderItemStatusStyle_TODAY:   //今天
            self.enabled = YES;
            self.contentImage.backgroundColor = [UIColor whiteColor];
            self.contentlabel.text = @"今天";
            break;
        
        default:
            break;
    }
}

@end


@interface WJCalenderHeadView ()

@property (nonatomic,strong)UIImageView *leftImageView;    //
@property (nonatomic,strong)UIImageView *rightImageView;   //
@property (nonatomic,strong)UIButton *leftButton;          //
@property (nonatomic,strong)UIButton *rightButton;         //

@end

@implementation WJCalenderHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        CGFloat labelWidth = 100;
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.bounds = CGRectMake(0, 0, labelWidth, CGRectGetHeight(self.bounds));
        self.titleLabel.center = self.center;
        
        self.titleLabel.text = [NSString stringWithFormat:@"%li年%li月",[NSDate year:[NSDate date]],[NSDate month:[NSDate date]]];
        self.titleLabel.userInteractionEnabled = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat buttonWoth = (CGRectGetWidth(self.bounds)-labelWidth)/2;
        self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, buttonWoth,  CGRectGetHeight(self.bounds))];
        self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, buttonWoth, CGRectGetHeight(self.bounds))];

        [self.leftButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        UIImage *image = [UIImage imageNamed:@"com_arrows_right"];
        self.leftImageView = [[UIImageView alloc]initWithImage:image];
        self.leftImageView.transform=CGAffineTransformMakeRotation(M_PI);//旋转180
        self.rightImageView = [[UIImageView alloc]initWithImage:image];
        
        self.leftImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        self.rightImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        
        self.leftImageView.center = CGPointMake(self.titleLabel.center.x-labelWidth/2-image.size.width, self.titleLabel.center.y);
        self.rightImageView.center = CGPointMake(self.titleLabel.center.x+labelWidth/2+image.size.width, self.titleLabel.center.y);
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightImageView];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        
    }
    return self;
}

#pragma mark - 事件监听

- (void)buttonPressed:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(WJCalenderHeadViewDidPressedIsLeft:)]) {
        if (sender == self.leftButton) {
            [_delegate WJCalenderHeadViewDidPressedIsLeft:YES];
        }else {
            [_delegate WJCalenderHeadViewDidPressedIsLeft:NO];
        }
    }
}

@end

@implementation WJCalenderItemModel

@end

@implementation NSDate (NSCalendar)

#pragma mark - date

+ (NSInteger)day:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


+ (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;//为什么要减一啊
}

+ (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

+ (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

@end
