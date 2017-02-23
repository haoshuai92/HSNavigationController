//
//  MyShowView.h
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyShowViewType) {
    MyShowViewTypeCircle = 0,                         // 圆形
    MyShowViewTypeSquare,  // 方形
};

@interface MyShowView : UIView

+ (instancetype)viewWithFrame:(CGRect) frame showViewType:(MyShowViewType) showViewType lineNum:(NSInteger) lineNum;

@property (nonatomic, assign) MyShowViewType showViewType;
@property (nonatomic, assign) NSInteger lineNum;

@end
