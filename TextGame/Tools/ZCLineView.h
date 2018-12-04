//
//  ZCLineView.h
//  recruit
//
//  Created by 智齿 on 16/8/26.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCLineView : UIView

/**
 *  画线条
 *
 *  @param superView 父视图
 *  @param color     线条延伸
 *  @param location  位置 0=顶部 1=底部
 *
 *  @return 线条
 */
+(UIView*)drawLineWithSuperView:(UIView*)superView Color:(UIColor*)color Location:(NSInteger)location;


/**
 *  自定义线条
 *
 *  @param superView 父视图
 *  @param color     延伸
 *  @param frame     位置
 *
 *  @return 线条
 */
+(UIView*)drawLineWithSuperView:(UIView*)superView Color:(UIColor*)color Frame:(CGRect)frame;

@end
