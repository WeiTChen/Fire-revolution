//
//  UILabel+ZCLabelHeightAdaption.h
//  recruit
//
//  Created by 智齿 on 16/12/16.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ZCLabelHeightAdaption)

//label高度自适应
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;

//label宽度自适应
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
