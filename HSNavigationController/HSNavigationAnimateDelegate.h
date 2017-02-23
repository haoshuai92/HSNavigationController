//
//  HSNavigationAnimateDelegate.h
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HSScreenWidth [UIScreen mainScreen].bounds.size.width
#define HSScreenHeight [UIScreen mainScreen].bounds.size.height

@interface HSNavigationAnimateDelegate : NSObject<UIViewControllerAnimatedTransitioning>

/** 导航栏操作类型 */
@property(nonatomic,assign)UINavigationControllerOperation  navigationOperation;
/** 导航栏操作类型 */
@property(nonatomic,weak)UINavigationController * navigationController;
/** 导航栏Pop时删除了多少张截图（调用PopToViewController时，计算要删除的截图的数量 */
@property(nonatomic,assign)NSInteger  removeCount;
/** 调用此方法删除数组最后一张截图 (调用pop手势或一次pop多个控制器时使用) */
- (void)removeLastScreenshot;
/** 移除全部屏幕截图 */
- (void)removeAllScreenshots;
/** 从截屏数组尾部移除指定数量的截图 */
- (void)removeLastScreenshotWithNumber:(NSInteger)number;
/** 获取截屏数组最后一张截图 */
- (UIImage *)lastScreenshot;

@end
