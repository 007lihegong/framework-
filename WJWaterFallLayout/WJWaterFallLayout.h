//
//  WJWaterFallLayout.h
//  瀑布流练习
//
//  Created by 谭启宏 on 15/12/17.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJWaterFallLayout;

@protocol WJWaterFallLayoutDelegate <NSObject>

- (CGFloat)WJWaterFallLayout:(WJWaterFallLayout *)waterFallLayout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath ;

@end

@interface WJWaterFallLayout : UICollectionViewLayout

@property (nonatomic,assign)id<WJWaterFallLayoutDelegate>delegate;

@end
