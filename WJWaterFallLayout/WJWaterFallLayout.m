//
//  WJWaterFallLayout.m
//  瀑布流练习
//
//  Created by 谭启宏 on 15/12/17.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import "WJWaterFallLayout.h"

@interface WJWaterFallLayout ()

//用来存放坐标的字典
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
//存放布局属性
@property (nonatomic, strong) NSMutableArray *attrsArr;


//每一行的间距
@property (nonatomic, assign) CGFloat rowMargin;
//列间距
@property (nonatomic, assign) CGFloat columnMargin;
//允许的最大列数
@property (nonatomic, assign) CGFloat columnCount;
//四边间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@end

@implementation WJWaterFallLayout


-(instancetype)init{
    
    if ([super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columnCount = 3;
    }
    return self;
}

#pragma mark - getter -

-(NSMutableDictionary *)maxYDict{
    if (!_maxYDict) {
        _maxYDict = [NSMutableDictionary dictionary];
        //存入下标key和每个单元格的 maxy 坐标
        for (int i = 0; i < self.columnCount; i++) {
            NSString *column = [NSString stringWithFormat:@"%d",i];
            self.maxYDict[column] = @"0";
        }
    }
    return _maxYDict;
}

-(NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

#pragma mark 以下方法每次滑动都会重新调用

-(void)prepareLayout{
    
    //下标对应边距的字典
    for (int i = 0; i < self.columnCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        self.maxYDict[column] = @(self.sectionInset.top);
    }
    
    [self.attrsArr removeAllObjects];
    
    //1.查看共有多少个元素
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //2.遍历每个item属性
    for (int i = 0; i < count; i++) {
        
        //3.取出布局属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        //4.添加到书数组中
        [self.attrsArr addObject:attr];
    }
    
}

//设置允许每个collectView的content的 宽 、高
//这个方法会被调用两次 prepareLayout方法后调用一次 layoutAttributesForElementsInRect:方法后会再调用一次

-(CGSize)collectionViewContentSize{
    __block NSString *maxColumn = @"0";
    //得到横坐标的下标 0，1，2
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * stop) {
        //刷新
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    //用下标key取到对应的值，返回contentSize的大小，就和scrollview一样，小了的话就划不动了
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom);
    
}

//允许重新查找集合视图的布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

//这里修改布局
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block NSString *miniColumn = @"0";
    //得到横坐标的下标 0，1，2
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * stop) {
        if ([maxY floatValue] < [self.maxYDict[miniColumn] floatValue]) {
            miniColumn = column;
        }
        
    }];
    
    //(总宽度-左间距-右间距-中间间距)数量=均分的三个宽度
    
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right - self.columnMargin * (self.columnCount - 1))/self.columnCount;
    
    //高度代理获取，所以代理是必须的
    
    CGFloat height = [self.delegate WJWaterFallLayout:self heightForWidth:width indexPath:indexPath];
    
    //左边初始间距+（均分的宽度加上数量+间距）*第几位 = 下一个单元格的初始X位置
    
    CGFloat x = self.sectionInset.left + (width + self.columnMargin)*[miniColumn intValue];
    
    //每一位的高度+行间距
    
    CGFloat y = [self.maxYDict[miniColumn] floatValue] + self.rowMargin;
    
    //初始的话是10，已经装在字典里面的+高度+前一个的MAXY底部坐标
    self.maxYDict[miniColumn] = @(height + y);
    
    //将位置信息添加到 UICollectionViewLayoutAttributes里面
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(x, y, width, height);
    
    return attr;
}

//设置每个 cell的大小及位置
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrsArr;
}


@end
