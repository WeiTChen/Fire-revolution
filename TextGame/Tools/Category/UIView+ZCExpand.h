//
//  UIView+ZCExpand.h
//  recruit
//
//  Created by william on 2016/11/15.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZCExpand)

- (void)setExpand:(id)exp;

- (id)expand;

//设置圆角
- (void)setCornerByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

- (void)addMaskViewToWindow:(void(^)(UIVisualEffectView *view))maskViewBlock;

@end
