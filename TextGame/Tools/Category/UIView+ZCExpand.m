//
//  UIView+ZCExpand.m
//  recruit
//
//  Created by william on 2016/11/15.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "UIView+ZCExpand.h"

#define MASK_VIEW_TAG 0xFF00FF

@implementation UIView (ZCExpand)
static NSString *_exp;

- (void)setExpand:(id)exp{
    objc_setAssociatedObject(self, &_exp, exp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)expand{
    return objc_getAssociatedObject(self, &_exp);
}

- (void)setCornerByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addMaskViewToWindow:(void (^)(UIVisualEffectView *))maskViewBlock{
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
    view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    view.tag = MASK_VIEW_TAG;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    lb.text = @"我是系统遮罩效果";
    lb.textColor = [UIColor whiteColor];
    lb.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lb];
    lb.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [view addGestureRecognizer:tap];
    
    if (maskViewBlock) {
        maskViewBlock(view);
        maskViewBlock = nil;
    }
}

- (void)removeView{
    UIVisualEffectView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:MASK_VIEW_TAG];
    [view removeFromSuperview];
}

@end
