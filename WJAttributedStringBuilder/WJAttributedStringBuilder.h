//
//  WJAttributedStringBuilder.h
//  WJAttributedStringDemo
//
//  Created by 谭启宏 on 15/12/10.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WJAttributedStringBuilder;

/**属性字符串区域***/
@interface WJAttributedStringRange : NSObject

@property (nonatomic,strong,readwrite)UIFont *font;      //字体
@property (nonatomic,strong,readwrite)UIColor *textColor;//文字颜色
@property (nonatomic,strong,readwrite)UIColor *backgroudColor;//背景色
@property (nonatomic,strong,readwrite)NSParagraphStyle *paragraphStyle;//段落样式
@property (nonatomic,assign,readwrite)CGFloat kern;//字间距
@property (nonatomic,assign,readwrite)CGFloat lineSpacing;//行间距
@property (nonatomic,assign,readwrite)NSInteger strikethroughStyle;//删除线
@property (nonatomic,strong,readwrite)UIColor *strikethroughColor;//删除线颜色
@property (nonatomic,assign,readwrite)NSUnderlineStyle underlineStyle;//下划线
@property (nonatomic,strong,readwrite)UIColor *underlineColor;//下划线颜色
@property (nonatomic,strong,readwrite)NSShadow *shadow;//阴影
@property (nonatomic,strong,readwrite)NSTextAttachment *attachment;//将区域中的特殊字符: NSAttachmentCharacter,替换为attachement中指定的图片,这个来实现图片混排。
@property (nonatomic,strong,readwrite)NSURL *url;//设置区域内的文字点击后打开的链接

//可以设置多个属性
- (instancetype)setAttributes:(NSDictionary*)dict;

//得到构建器
- (WJAttributedStringBuilder *)builder;

@end


/**属性构造器，这里主要选择范围，WJAttributedStringRange类做属性处理**/
/*
 1.步骤初始化构造器
 2.获取需要改变的范围
 3.设置WJAttributedStringRange属性
 4.有些方法暂时没怎么用放在.m文件中，如果需要可以给它提出来
 */
@interface WJAttributedStringBuilder : NSObject

+(WJAttributedStringBuilder*)builderWith:(NSString*)string;

-(WJAttributedStringRange*)range:(NSRange)range;  //指定区域,如果没有属性串或者字符串为nil则返回nil,下面方法一样。
-(WJAttributedStringRange*)allRange;      //全部字符
-(WJAttributedStringRange*)lastRange;     //最后一个字符
-(WJAttributedStringRange*)lastNRange:(NSInteger)length;  //最后N个字符
-(WJAttributedStringRange*)firstRange;    //第一个字符
-(WJAttributedStringRange*)firstNRange:(NSInteger)length;  //前面N个字符

//段落处理,以\n结尾为一段，如果没有段落则返回nil
-(WJAttributedStringRange*)firstParagraph;
-(WJAttributedStringRange*)nextParagraph;

//获得属性字符串
-(NSAttributedString*)commit;


//more
- (CGRect)boundingRectWithSize:(NSInteger)width;

+ (CGRect)boundingRectWithSize:(NSInteger)width attributedString:(NSAttributedString *)neirong;

@end
