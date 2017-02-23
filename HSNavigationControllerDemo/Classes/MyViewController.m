//
//  MyViewController.m
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import "MyViewController.h"
#import "MyOneViewController.h"
#import "MyNavigationController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_01"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSStringFromClass([self class]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupUI];
    });
}

- (void)setupUI {
    // 改变根控制器的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    // 判断控制器的根控制器
    UIViewController *preVc = self.view.window.rootViewController;
    if (self.tabBarController == preVc) {
        [button setTitle:@"let rootViewController change to navigationController" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeRootToNavi) forControlEvents:UIControlEventTouchUpInside];
    } else if (self.navigationController == preVc) {
        [button setTitle:@"let rootViewController change to tabBarController" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeRootToTabBar) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [button setTitle:@"i can not do anything" forState:UIControlStateNormal];
    }
    
    [button sizeToFit];
    CGFloat buttonX = (self.view.frame.size.width - button.frame.size.width) * 0.5;
    CGFloat buttonY = (self.view.frame.size.height - button.frame.size.height) * 0.5;
    button.frame = CGRectMake(buttonX, buttonY, button.frame.size.width, button.frame.size.height);
    [self.view addSubview:button];
    
    // 跳转按钮
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [pushButton setBackgroundColor:[UIColor lightGrayColor]];
    [pushButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pushButton setTitle:@"touch me to push" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(clickToPush) forControlEvents:UIControlEventTouchUpInside];
    [pushButton sizeToFit];
    CGFloat pushButtonX = (self.view.frame.size.width - pushButton.frame.size.width) * 0.5;
    pushButton.frame = CGRectMake(pushButtonX, [UIScreen mainScreen].bounds.size.height - 150, pushButton.frame.size.width, pushButton.frame.size.height);
    [self.view addSubview:pushButton];
}

- (void)changeRootToNavi {
    MyViewController *MyVc = [[MyViewController alloc] init];
    MyNavigationController *navi = [[MyNavigationController alloc] initWithRootViewController:MyVc];
    self.view.window.rootViewController = navi;
}

- (void)changeRootToTabBar {
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    MyViewController *MyVc1 = [[MyViewController alloc] init];
    MyNavigationController *navi1 = [[MyNavigationController alloc] initWithRootViewController:MyVc1];
    navi1.tabBarItem.image = [UIImage imageNamed:@"home"];
    navi1.tabBarItem.title = @"home";
    
    MyViewController *MyVc2 = [[MyViewController alloc] init];
    MyNavigationController *navi2 = [[MyNavigationController alloc] initWithRootViewController:MyVc2];
    navi2.tabBarItem.image = [UIImage imageNamed:@"find"];
    navi2.tabBarItem.title = @"find";
    
    [tabBarController addChildViewController:navi1];
    [tabBarController addChildViewController:navi2];
    self.view.window.rootViewController = tabBarController;
}

- (void)clickToPush {
    MyOneViewController *oneVc = [[MyOneViewController alloc] init];
    [self.navigationController pushViewController:oneVc animated:YES];
}



@end
