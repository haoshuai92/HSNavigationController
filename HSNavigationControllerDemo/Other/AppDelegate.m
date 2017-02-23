//
//  AppDelegate.m
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import "AppDelegate.h"
#import "MyViewController.h"
#import "MyNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    MyViewController *MyVc = [[MyViewController alloc] init];
//    MyNavigationController *navi = [[MyNavigationController alloc] initWithRootViewController:MyVc];
//    self.window.rootViewController = navi;
    
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
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}



@end
