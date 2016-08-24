//
//  ViewController.m
//  testpop
//
//  Created by tqh on 15/12/5.
//  Copyright (c) 2015年 tqh. All rights reserved.
//

#import "ViewController.h"
#import "POP.h"
@interface ViewController ()


@property (weak, nonatomic) IBOutlet UIButton *testView;

@end

@implementation ViewController
- (IBAction)buttonPressed:(UIButton *)sender {
//    NSInteger height = CGRectGetHeight(self.view.bounds);
//    NSInteger width = CGRectGetWidth(self.view.bounds);
//    
//    CGFloat centerX = arc4random() % width;
//    CGFloat centerY = arc4random() % height;
//
//    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
//    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
//    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    anim.duration = 0.4;
//    [self.testView pop_addAnimation:anim forKey:@"centerAnimation"];
    
    //------------------------------------------------
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    
//    NSInteger height = CGRectGetHeight(self.view.bounds);
//    NSInteger width = CGRectGetWidth(self.view.bounds);
//    
//    CGFloat centerX = arc4random() % width;
//    CGFloat centerY = arc4random() % height;
//    
//    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
//    anim.dynamicsMass = 3;
//    
//    [self.testView pop_addAnimation:anim forKey:@"center"];
    //-------------------------------------------------自定义属性
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
        
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            UILabel *lable = (UILabel*)obj;
            self.testView.titleLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)values[0]/60,(int)values[0]%60,(int)(values[0]*100)%100];
        };
        
        //        prop.threshold = 0.01f;
    }];
    
    POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];   //秒表当然必须是线性的时间函数
    anBasic.property = prop;    //自定义属性
    anBasic.fromValue = @(0);   //从0开始
    anBasic.toValue = @(3*60);  //180秒
    anBasic.duration = 3*60;    //持续3分钟
    anBasic.beginTime = CACurrentMediaTime() + 1.0f;    //延迟1秒开始
    [self.testView pop_addAnimation:anBasic forKey:@"countdown"];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testView.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
