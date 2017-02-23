//
//  MyTwoViewController.m
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import "MyTwoViewController.h"
#import "MyViewController.h"
#import "MyShowView.h"

@interface MyTwoViewController ()

@end

@implementation MyTwoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_03"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSStringFromClass([self class]);
    [self setupUI];
}

- (void)setupUI {
    
    MyShowView *showView = [MyShowView viewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) showViewType:MyShowViewTypeSquare lineNum:4];
    [self.view addSubview:showView];
    
    // 跳转按钮
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [popButton setBackgroundColor:[UIColor lightGrayColor]];
    [popButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popButton setTitle:@"touch me to pop to MyViewController" forState:UIControlStateNormal];
    [popButton addTarget:self action:@selector(clickToPop) forControlEvents:UIControlEventTouchUpInside];
    [popButton sizeToFit];
    CGFloat pushButtonX = (self.view.frame.size.width - popButton.frame.size.width) * 0.5;
    popButton.frame = CGRectMake(pushButtonX, [UIScreen mainScreen].bounds.size.height - 150, popButton.frame.size.width, popButton.frame.size.height);
    [self.view addSubview:popButton];
}

- (void)clickToPop {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MyViewController class]]) {
            MyViewController *MyVc =(MyViewController *)controller;
            [self.navigationController popToViewController:MyVc animated:YES];
        }
    }
}

@end
