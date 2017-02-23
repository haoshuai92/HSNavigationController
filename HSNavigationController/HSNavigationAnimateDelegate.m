//
//  HSNavigationAnimateDelegate.m
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import "HSNavigationAnimateDelegate.h"

@interface HSNavigationAnimateDelegate ()

/** 屏幕截图数组 */
@property(nonatomic,strong)NSMutableArray * screenshotArray;
/** 所属的导航栏有没有TabBarController */
@property (nonatomic,assign)BOOL isTabbarExist;

@end

@implementation HSNavigationAnimateDelegate

/** push或pop的动画时长 */
static CGFloat const HSTransitionDuration = 0.5f;
/** 底部阴影图层的最大透明度 */
static CGFloat const HSCoverViewMaxAlpha = 0.5f;
/** push完成时上一个控制器的view向左偏移量与屏幕宽度的比值 */
static CGFloat const HSPrefixViewMoveRatio = 0.25f;

#pragma mark - 懒加载
- (NSMutableArray *)screenShotArray {
    if (_screenshotArray == nil) {
        _screenshotArray = [[NSMutableArray alloc]init];
    }
    return _screenshotArray;
}

/** setNavigationController时判断是否有tabBarController */
- (void)setNavigationController:(UINavigationController *)navigationController {
    _navigationController = navigationController;
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    // 判断该导航栏是否有TabBarController
    if (self.navigationController.tabBarController == beyondVC) {
        _isTabbarExist = YES;
    } else {
        _isTabbarExist = NO;
    }
}
#pragma mark - 操作截屏的方法
- (void)removeLastScreenshot {
    [self.screenShotArray removeLastObject];
}

- (void)removeAllScreenshots {
    [self.screenShotArray removeAllObjects];
}
- (void)removeLastScreenshotWithNumber:(NSInteger)number {
    for (NSInteger  i = 0; i < number ; i++) {
        [self.screenShotArray removeLastObject];
    }
}

- (UIImage *)lastScreenshot {
    return [self.screenShotArray lastObject];
}

#pragma mark - 截屏方法
- (UIImage *)screenShot {
    // 将要被截图的view(不含状态栏)
    UIViewController *beyondVC = self.navigationController.view.window.rootViewController;
    // 背景图片 总的大小
    CGSize size = beyondVC.view.frame.size;
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    // 要裁剪的矩形范围
    CGRect rect = CGRectMake(0, 0, HSScreenWidth, HSScreenHeight);
    // 判断是导航栏是否有上层的Tabbar,决定截图的对象
    if (_isTabbarExist) { // 如果存在tabBarController,截屏放在UITabbarController的View上
        [beyondVC.view drawViewHierarchyInRect:rect  afterScreenUpdates:NO];
    } else { // 不存在tabBarController,截屏就是导航控制器的view
        [self.navigationController.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }
    // 从上下文中,取出UIImage
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return snapshot;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return HSTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    CGFloat screenW = HSScreenWidth;
    CGFloat screenH = HSScreenHeight;
    
    UIImageView *screenImgView =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW , screenH)];
    UIImage * screenImg = [self screenShot];
    screenImgView.image =screenImg;
    
    // 获取fromViewController toViewController toView
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    // 如果是push
    if (self.navigationOperation == UINavigationControllerOperationPush) {
        // 将截屏加入数组中保存
        [self.screenShotArray addObject:screenImg];
        
        // ******
        [containerView addSubview:toView];
        
        // 将截图添加到导航栏的View所属的window上
        [self.navigationController.view.window insertSubview:screenImgView atIndex:0];
        
        UIView * coverView = [[UIView alloc]initWithFrame:screenImgView.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        [screenImgView addSubview:coverView];
        coverView.alpha = 0;
        
        self.navigationController.view.frame = CGRectMake(screenW, 0, screenW, screenH);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            self.navigationController.view.frame = CGRectMake(0, 0, screenW, screenH);
            screenImgView.frame = CGRectMake(-(screenW) * HSPrefixViewMoveRatio, 0, screenW, screenH);
            coverView.alpha = HSCoverViewMaxAlpha;
            
        } completion:^(BOOL finished) {
            [screenImgView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
    // 如果是pop
    if (self.navigationOperation == UINavigationControllerOperationPop) {
        [containerView addSubview:toView];
        
        UIImageView * lastVcImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-(screenW)* HSPrefixViewMoveRatio , 0, screenW, screenH)];
        
        // 若removeCount大于0  则说明Pop了不止一个控制器
        if (_removeCount > 0) {
            for (NSInteger i = 0; i < _removeCount; i ++) {
                if (i == _removeCount - 1) {
                    // 当删除到要跳转页面的截图时，不再删除，并将该截图作为ToVC的截图展示
                    lastVcImgView.image = [self.screenShotArray lastObject];
                    _removeCount = 0;
                    break;
                } else {
                    [self.screenShotArray removeLastObject];
                }
            }
        } else {
            lastVcImgView.image = [self.screenShotArray lastObject];
        }
        
        [self.navigationController.view.window addSubview:lastVcImgView];
        [self.navigationController.view.window addSubview:screenImgView];
        
        UIView * coverView = [[UIView alloc]initWithFrame:screenImgView.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        [lastVcImgView addSubview:coverView];
        coverView.alpha = HSCoverViewMaxAlpha;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            screenImgView.frame = CGRectMake(screenW, 0, screenW, screenH);
            lastVcImgView.frame = CGRectMake(0, 0, screenW, screenH);
            coverView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [lastVcImgView removeFromSuperview];
            [screenImgView removeFromSuperview];
            [self.screenShotArray removeLastObject];
            [transitionContext completeTransition:YES];
            
        }];
    }
}

@end
