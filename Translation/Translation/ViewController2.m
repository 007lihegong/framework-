//
//  ViewController2.m
//  Translation
//
//  Created by 谭启宏 on 15/12/23.
//  Copyright © 2015年 谭启宏. All rights reserved.
//

#import "ViewController2.h"
#import "ViewController1.h"
@interface ViewController2 ()

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation ViewController2


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
        _imageView.image = [UIImage imageNamed:@"doge"];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
   
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        ViewController1 *vc1 = (ViewController1 *)fromVC;
        UITableViewCell *cell = [vc1.tableView cellForRowAtIndexPath:vc1.selectIndexPath];
        return [WJTransiation_Mobile transitionWithType:WJTransiation_MobileTypePush fromView:cell.imageView toView:self.imageView];
    }else {
        ViewController1 *vc1 = (ViewController1 *)toVC;
        UITableViewCell *cell = [vc1.tableView cellForRowAtIndexPath:vc1.selectIndexPath];
        return [WJTransiation_Mobile transitionWithType:WJTransiation_MobileTypePop fromView:self.imageView toView:cell.imageView];
    }

}


- (void)tapPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
