//
//  KKViewController.m
//  KKGestureLockView
//
//  Created by Luke on 8/5/13.
//  Copyright (c) 2013 geeklu. All rights reserved.
//

#import "KKViewController.h"
@interface KKViewController ()

@property (nonatomic,strong)KKGestureLockView *lockView;

@end

@implementation KKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.lockView = [[KKGestureLockView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds)-100, CGRectGetHeight(self.view.bounds)-200)];
    self.view.backgroundColor = [UIColor redColor];
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"gesture_node_normal.png"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"gesture_node_selected.png"];
    self.lockView.lineColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 12;
    self.lockView.delegate = self;
    self.lockView.layer.borderWidth = 1;
//    self.lockView.contentInsets = UIEdgeInsetsMake(150, 20, 100, 20);
    [self.view addSubview:self.lockView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{
    NSLog(@"%@",passcode);
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode{
    NSLog(@"%@",passcode);
}

@end
