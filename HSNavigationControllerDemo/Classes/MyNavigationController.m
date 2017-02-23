//
//  MyNavigationController.m
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_01"] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) { // 非根控制器
        // 跳转时隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 跳转
    [super pushViewController:viewController animated:animated];
}






@end
