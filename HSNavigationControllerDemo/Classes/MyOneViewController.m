//
//  MyOneViewController.m
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import "MyOneViewController.h"
#import "MyTwoViewController.h"
#import "MyShowView.h"

@interface MyOneViewController ()

@end

@implementation MyOneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"line_02"] forBarMetrics:UIBarMetricsDefault];
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
    
    
    MyShowView *showView = [MyShowView viewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) showViewType:MyShowViewTypeCircle lineNum:4];
    [self.view addSubview:showView];
    
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

- (void)clickToPush {
    MyTwoViewController *twoVc = [[MyTwoViewController alloc] init];
    [self.navigationController pushViewController:twoVc animated:YES];
}



@end
