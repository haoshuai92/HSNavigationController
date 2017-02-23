//
//  HSNavigationController.m
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import "HSNavigationController.h"
#import "HSNavigationAnimateDelegate.h"

@interface HSNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic,strong)HSNavigationAnimateDelegate * animateDelegate;

@property (nonatomic, weak) UIScreenEdgePanGestureRecognizer *panGestureRec;

/** 存放屏幕截图的view */
@property (nonatomic, strong) UIImageView *screenshotImgView;

/** 阴影view */
@property (nonatomic, weak) UIView *coverView;

/** 真正要移动的view */
@property (nonatomic, weak) UIView *moveView;

@end

/** 侧滑可以返回需要拖动的距离占屏幕的比例(侧滑拖动到屏幕的百分之多少可以完成返回动作) */
static CGFloat const HSGoBackRatio = 0.5f;
/** 底部阴影图层的最大透明度 */
static CGFloat const HSCoverViewMaxAlpha = 0.5f;
/** 侧滑结束后的动画时长 */
static CGFloat const HSGoBackDuration = 0.25f;
/** push完成时上一个控制器的view向左偏移量与屏幕宽度的比值 */
static CGFloat const HSPrefixViewMoveRatio = 0.25f;


@implementation HSNavigationController

#pragma mark - 懒加载

- (HSNavigationAnimateDelegate *)animateDelegate {
    if (_animateDelegate == nil) {
        _animateDelegate = [[HSNavigationAnimateDelegate alloc]init];
        
    }
    return _animateDelegate;
}

- (UIImageView *)screenshotImgView {
    if (_screenshotImgView == nil) {
        _screenshotImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HSScreenWidth, HSScreenHeight)];
        
        UIView *coverView = [[UIView alloc] initWithFrame:self.screenshotImgView.bounds];
        coverView.backgroundColor = [UIColor blackColor];
        [_screenshotImgView addSubview:coverView];
        _coverView = coverView;
        
    }
    return _screenshotImgView;
}

/** 真正要移动的view */
- (UIView *)moveView {
    if (_moveView == nil) {
        UIViewController *beyondVC = self.view.window.rootViewController;
        // 判断该导航栏是否有TabBarController
        if (self.tabBarController == beyondVC) {
            _moveView = self.view.window.rootViewController.view;
        } else {
            _moveView = self.view;
        }
        _moveView.layer.shadowColor = [UIColor blackColor].CGColor;
        _moveView.layer.shadowOffset = CGSizeMake(-4, 0);
        _moveView.layer.shadowOpacity = 0.2;
    }
    return _moveView;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPanGesture];
    
    self.delegate = self;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)addPanGesture{
    UIScreenEdgePanGestureRecognizer *panGestureRec = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRec:)];
    panGestureRec.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:panGestureRec];
    _panGestureRec = panGestureRec;
}


#pragma mark - UINavigationControllerDelegate 代理
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0)
{
    self.animateDelegate.navigationOperation = operation;
    self.animateDelegate.navigationController = self;
    return self.animateDelegate;
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSInteger removeCount = 0;
    for (NSInteger i = self.viewControllers.count - 1; i > 0; i--) {
        if (viewController == self.viewControllers[i]) {
            break;
        }
        removeCount ++;
        
    }
    self.animateDelegate.removeCount = removeCount;
    return [super popToViewController:viewController animated:animated];
}


#pragma mark - 手势
- (void)panGestureRec:(UIScreenEdgePanGestureRecognizer *)panGestureRec {
    // 如果当前显示的控制器已经是根控制器了，不需要做任何切换动画,直接返回
    if(self.visibleViewController == self.viewControllers[0]) return;
    
    // 判断pan手势的各个阶段
    switch (panGestureRec.state) {
        case UIGestureRecognizerStateBegan:
            // 开始拖拽阶段
            [self dragBegin];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            // 结束拖拽阶段
            [self dragEnd];
            break;
            
        default:
            // 正在拖拽阶段
            [self dragging:panGestureRec];
            break;
    }
}

// 开始拖动
- (void)dragBegin {
    // 获取当前屏幕截图
    self.screenshotImgView.image = [self.animateDelegate lastScreenshot];
    // 把截屏插入到window中
    [self.view.window insertSubview:self.screenshotImgView atIndex:0];
}

- (void)dragEnd {
    
    // 取出挪动的距离
    CGFloat translateX = self.moveView.transform.tx;
    // 判断拖动的距离
    if (translateX <= HSScreenWidth * HSGoBackRatio) { // 如果距离小于屏幕*比例,往左边弹回
        [UIView animateWithDuration:HSGoBackDuration animations:^{
            // 让被右移的view弹回归位
            self.moveView.transform = CGAffineTransformIdentity;
            // 让imageView大小恢复默认的translation
            _screenshotImgView.transform = CGAffineTransformMakeTranslation(-HSScreenWidth * HSPrefixViewMoveRatio, 0);
            // 增大透明度
            self.coverView.alpha = HSCoverViewMaxAlpha;
        } completion:^(BOOL finished) {
            // 移除截屏view
            [_screenshotImgView removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:HSGoBackDuration animations:^{ // 如果距离大于屏幕*比例,往右边弹回
            // 让被右移的view完全挪到屏幕的最右边,结束之后,还要记得清空view的transform
            self.moveView.transform = CGAffineTransformMakeTranslation(HSScreenWidth, 0);
            // 让imageView位移还原
            _screenshotImgView.transform = CGAffineTransformMakeTranslation(0, 0);
            // 让遮盖alpha变为0,变得完全透明
            self.coverView.alpha = 0;
        } completion:^(BOOL finished) {
            // 清空moveView的transform
            self.moveView.transform = CGAffineTransformIdentity;
            // 移除两个view,下次开始拖动时,再加回来
            [_screenshotImgView removeFromSuperview];
            
            // 真正执行Pop
            [self popViewControllerAnimated:NO];
            
            // 移除截图数组里最后一张截图
            [self.animateDelegate removeLastScreenshot];
        }];
    }
}

- (void)dragging:(UIScreenEdgePanGestureRecognizer *)panGestureRec {
    // 得到手指拖动的位移
    CGFloat offsetX = [panGestureRec translationInView:self.moveView].x;
    
    // 让整个view都平移     // 挪动整个导航view
    if (offsetX > 0) {
        self.moveView.transform = CGAffineTransformMakeTranslation(offsetX, 0);
    }
    
    if (offsetX < HSScreenWidth) {
        // 按比例计算截屏view的移动
        _screenshotImgView.transform = CGAffineTransformMakeTranslation((offsetX - HSScreenWidth) *HSPrefixViewMoveRatio, 0);
    }
    double currentTranslateScaleX = offsetX/HSScreenWidth;
    // 让遮盖透明度改变,直到减为0,让遮罩完全透明,默认的比例-(当前平衡比例/目标平衡比例)*默认的比例
    double alpha = HSCoverViewMaxAlpha - (currentTranslateScaleX/(1-HSPrefixViewMoveRatio)) * HSCoverViewMaxAlpha;
    self.coverView.alpha = alpha;
}





@end
