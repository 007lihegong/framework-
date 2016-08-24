//
//  WJAttributedStringBuilder.m
//  WJAttributedStringDemo
//
//  Created by 谭启宏 on 15/12/10.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import "WJAttributedStringBuilder.h"

@interface WJAttributedStringRange ()
{
    NSMutableArray *_ranges;
    NSMutableAttributedString *_attrString;
    
    WJAttributedStringBuilder *_builder;
    
}
//私有属性
@property (nonatomic,assign,readwrite)CGFloat baselineOffset;//设置基线的偏移量，正值为往上，负值为往下，可以用于控制UILabel的居顶或者居低显示
@property (nonatomic,assign,readwrite)CGFloat obliqueness; //设置倾斜度
@property (nonatomic,assign,readwrite)CGFloat expansion;//压缩文字，正值为伸，负值为缩
@property (nonatomic,strong,readwrite)UIColor *strokeColor;//中空文字的颜色
@property (nonatomic,assign,readwrite)CGFloat strokeWidth;//中空的线宽度

@end

@implementation WJAttributedStringRange

#pragma mark - 初始化

- (instancetype)initWithAttributeString:(NSMutableAttributedString*)attrString builder:(WJAttributedStringBuilder*)builder {
    self = [self init];
    if (self != nil)
    {
        _attrString = attrString;
        _builder = builder;
        _ranges = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - 公用方法

-(void)addRange:(NSRange)range
{
    [_ranges addObject:[NSValue valueWithRange:range]];
}

-(void)enumRange:(void(^)(NSRange range))block
{
    if (self == nil || _attrString == nil)
        return;
    
    for (int i = 0; i < _ranges.count; i++)
    {
        NSRange range = ((NSValue*)[_ranges objectAtIndex:i]).rangeValue;
        if (range.location == NSNotFound || range.length == 0)
            continue;
        
        block(range);
    }
}

#pragma mark - setter 

- (void)setFont:(UIFont *)font {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSFontAttributeName value:font range:range];
        
    }];
}

- (void)setTextColor:(UIColor *)textColor {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
        
    }];
}


- (void)setBackgroudColor:(UIColor *)backgroudColor {
    [self enumRange:^(NSRange range){
    
        [_attrString addAttribute:NSBackgroundColorAttributeName value:backgroudColor range:range];
        
    }];
}


- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }];
}

- (void)setKern:(CGFloat)kern {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:kern] range:range];
    }];
}

- (void)setStrikethroughStyle:(NSInteger)strikethroughStyle {
    [self enumRange:^(NSRange range){
        
        
        [_attrString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:strikethroughStyle] range:range];
    }];
}

- (void)setStrikethroughColor:(UIColor *)strikethroughColor {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSStrikethroughColorAttributeName value:strikethroughColor range:range];
    }];
}

- (void)setUnderlineStyle:(NSUnderlineStyle)underlineStyle {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:underlineStyle] range:range];
    }];
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
    }];
}


- (void)setShadow:(NSShadow *)shadow {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSShadowAttributeName value:shadow range:range];
    }];
}

- (void)setAttachment:(NSTextAttachment *)attachment {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSAttachmentAttributeName value:attachment range:range];
    }];
}

- (void)setUrl:(NSURL *)url {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSLinkAttributeName value:url range:range];
    }];
}

- (void)setBaselineOffset:(CGFloat)baselineOffset {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:baselineOffset] range:range];
    }];
}

- (void)setObliqueness:(CGFloat)obliqueness {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSObliquenessAttributeName value:[NSNumber numberWithFloat:obliqueness] range:range];
    }];
}

- (void)setExpansion:(CGFloat)expansion {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSExpansionAttributeName value:[NSNumber numberWithFloat:expansion] range:range];
    }];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
    }];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:strokeWidth] range:range];
    }];
}

- (instancetype)setAttributes:(NSDictionary *)dict {
    [self enumRange:^(NSRange range){
        
        [_attrString addAttributes:dict range:range];
    }];
    return self;
}

- (WJAttributedStringBuilder *)builder {
    return _builder;
}

@end

@interface WJAttributedStringBuilder () {
    NSMutableAttributedString *attrString;
    NSInteger paragraphIndex;
}

//私有方法
-(WJAttributedStringRange*)characterSet:(NSCharacterSet*)characterSet;             //用于选择特殊的字符
-(WJAttributedStringRange*)includeString:(NSString*)includeString all:(BOOL)all;   //用于选择特殊的字符串
-(WJAttributedStringRange*)regularExpression:(NSString*)regularExpression all:(BOOL)all;   //正则表达式
//插入，如果为0则是头部，如果为-1则是尾部
-(void)insert:(NSInteger)pos attrstring:(NSAttributedString*)attrstring;
-(void)insert:(NSInteger)pos attrBuilder:(WJAttributedStringBuilder*)attrBuilder;
@end

@implementation WJAttributedStringBuilder

+(WJAttributedStringBuilder*)builderWith:(NSString*)string
{
    return [[WJAttributedStringBuilder alloc] initWithString:string];
}


-(instancetype)initWithString:(NSString*)string
{
    self = [self init];
    if (self != nil)
    {
        if (string != nil)
            attrString = [[NSMutableAttributedString alloc] initWithString:string];
        else
            attrString = nil;
        paragraphIndex = 0;
    }
    
    return self;
}

-(WJAttributedStringRange*)range:(NSRange)range
{
    if (attrString == nil)
        return nil;
    
    if (attrString.length < range.location + range.length)
        return nil;
    
    
    WJAttributedStringRange *attrstrrang = [[WJAttributedStringRange alloc] initWithAttributeString:attrString builder:self];
    [attrstrrang addRange:range];
    return attrstrrang;
}

-(WJAttributedStringRange*)allRange
{
    if (attrString == nil)
        return nil;
    
    NSRange range = NSMakeRange(0, attrString.length);
    return [self range:range];
}

-(WJAttributedStringRange*)lastRange
{
    if (attrString == nil)
        return nil;
    
    NSRange range = NSMakeRange(attrString.length - 1, 1);
    return [self range:range];
}

-(WJAttributedStringRange*)lastNRange:(NSInteger)length
{
    if (attrString == nil)
        return nil;
    
    return [self range:NSMakeRange(attrString.length - length, length)];
}


-(WJAttributedStringRange*)firstRange
{
    if (attrString == nil)
        return nil;
    
    NSRange range = NSMakeRange(0, attrString.length > 0 ? 1 : 0);
    return [self range:range];
}

-(WJAttributedStringRange*)firstNRange:(NSInteger)length
{
    if (attrString == nil)
        return nil;
    
    return [self range:NSMakeRange(0, length)];
}

-(WJAttributedStringRange*)characterSet:(NSCharacterSet*)characterSet
{
    if (attrString == nil)
        return nil;
    
    
    //遍历所有字符，然后计算数值
    WJAttributedStringRange *attrstrrang = [[WJAttributedStringRange alloc] initWithAttributeString:attrString builder:self];
    
    
    NSString *str = attrString.string;
    NSRange range;
    BOOL isStart = YES;
    for (int i = 0; i < str.length; i++)
    {
        unichar uc  = [str characterAtIndex:i];
        if ([characterSet characterIsMember:uc])
        {
            if (isStart)
            {
                range.location = i;
                range.length = 0;
                isStart = NO;
            }
            
            range.length++;
        }
        else
        {
            if (!isStart)
            {
                isStart = YES;
                
                [attrstrrang addRange:range];
            }
        }
    }
    
    if (!isStart)
        [attrstrrang addRange:range];
    
    return attrstrrang;
}


-(WJAttributedStringRange*)searchString:(NSString*)searchString options:(NSStringCompareOptions)options all:(BOOL)all
{
    if (attrString == nil)
        return nil;
    
    
    WJAttributedStringRange *attRange = [[WJAttributedStringRange alloc] initWithAttributeString:attrString builder:self];
    NSString *str = attrString.string;
    if (!all)
    {
        return [self range:[str rangeOfString:searchString options:options]];
    }
    else
    {
        NSRange searchRange = NSMakeRange(0, str.length);
        NSRange range = NSMakeRange(0, 0);
        
        while(range.location != NSNotFound && searchRange.location < str.length)
        {
            range = [str rangeOfString:searchString options:options range:searchRange];
            [attRange addRange:range];
            if (range.location != NSNotFound)
            {
                searchRange.location = range.location + range.length;
                searchRange.length = str.length - searchRange.location;
            }
        }
        
        
    }
    
    return attRange;
    
}

-(WJAttributedStringRange*)includeString:(NSString*)includeString all:(BOOL)all
{
    return [self searchString:includeString options:0 all:all];
}

-(WJAttributedStringRange*)regularExpression:(NSString*)regularExpression all:(BOOL)all
{
    return [self searchString:regularExpression options:NSRegularExpressionSearch all:all];
}




-(WJAttributedStringRange*)firstParagraph
{
    if (attrString == nil)
        return nil;
    
    
    paragraphIndex = 0;
    
    NSString *str = attrString.string;
    NSRange range;
    NSInteger i;
    for (i = paragraphIndex; i < str.length; i++)
    {
        unichar uc = [str characterAtIndex:i];
        if (uc == '\n')
        {
            range.location =  0;
            range.length = i + 1;
            paragraphIndex = i + 1;
            break;
        }
    }
    
    if (i >= str.length)
    {
        range.location = 0;
        range.length = i;
        paragraphIndex = i;
    }
    
    
    return [self range:range];
}

-(WJAttributedStringRange*)nextParagraph
{
    if (attrString == nil)
        return nil;
    
    NSString *str = attrString.string;
    
    if (paragraphIndex >= str.length)
        return nil;
    
    
    NSRange range;
    NSInteger i;
    for (i = paragraphIndex; i < str.length; i++)
    {
        unichar uc = [str characterAtIndex:i];
        if (uc == '\n')
        {
            range.location =  paragraphIndex;
            range.length = i - paragraphIndex + 1;
            paragraphIndex = i + 1;
            break;
        }
    }
    
    if (i >= str.length)
    {
        range.location = paragraphIndex;
        range.length = i - paragraphIndex;
        paragraphIndex = i + 1;
    }
    
    
    return [self range:range];
}


-(void)insert:(NSInteger)pos attrstring:(NSAttributedString*)attrstring
{
    if (attrString == nil || attrstring == nil)
        return;
    
    if (pos == -1)
        [attrString appendAttributedString:attrstring];
    else
        [attrString insertAttributedString:attrstring atIndex:pos];
}

-(void)insert:(NSInteger)pos attrBuilder:(WJAttributedStringBuilder*)attrBuilder
{
    [self insert:pos attrstring:attrBuilder.commit];
}

-(NSAttributedString*)commit
{
    return attrString;
}

- (CGRect)boundingRectWithSize:(NSInteger)width {
    CGRect rect = [self.commit boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect;
}

+ (CGRect)boundingRectWithSize:(NSInteger)width attributedString:(NSAttributedString *)neirong {
    CGRect rect = [neirong boundingRectWithSize:CGSizeMake(width, 2000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect;
}


@end

















