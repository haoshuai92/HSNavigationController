//
//  MyShowView.m
//  HSNavigationControllerDemo
//
//  Created by 郝帅 on 2017/2/22.
//  Copyright © 2017年 hs. All rights reserved.
//

#import "MyShowView.h"

#define HSRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@implementation MyShowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width)]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


+ (instancetype)viewWithFrame:(CGRect) frame showViewType:(MyShowViewType) showViewType lineNum:(NSInteger) lineNum {
    MyShowView *showView = [[self alloc] initWithFrame:frame];
    showView.lineNum = lineNum;
    showView.showViewType = showViewType;
    return showView;
}

- (void)setShowViewType:(MyShowViewType)showViewType {
    _showViewType = showViewType;
    [self setNeedsDisplay];
}

- (void)setLineNum:(NSInteger)lineNum {
    _lineNum = lineNum;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_lineNum == 0 )return;
    CGFloat radius = self.frame.size.width / (_lineNum * 2);
    for (int i = 0; i < _lineNum; i++) {
        for (int j = 0; j < _lineNum; j++) {
            // 设置颜色
            const CGFloat *cmponents = CGColorGetComponents(HSRandomColor.CGColor);
            CGContextSetRGBFillColor(context, cmponents[0], cmponents[1], cmponents[2], cmponents[3]);
            if (_showViewType == MyShowViewTypeCircle) { // 如果是圆,画圆
                CGContextAddArc(context, radius + (2 * radius) * i, radius + (2 * radius) * j, radius, M_PI * 0, M_PI * 2, 0);
                CGContextDrawPath(context, kCGPathFill);
            } else if (_showViewType == MyShowViewTypeSquare) { // 如果是方,添加路径,画方
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, radius + (2 * radius) * j, 2 * i * radius);
                CGContextAddLineToPoint(context, (2 * radius) * j, 2 * i * radius + radius);
                CGContextAddLineToPoint(context, radius + (2 * radius) * j, 2 * i * radius + 2 * radius);
                CGContextAddLineToPoint(context,  2 * j * radius + 2 * radius, 2 * i * radius + radius);
                CGContextDrawPath(context, kCGPathFill);
            }
            
        }
    }
}


@end
