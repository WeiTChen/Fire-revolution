//
//  ZCLineView.m
//  recruit
//
//  Created by 智齿 on 16/8/26.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "ZCLineView.h"

@implementation ZCLineView


//  线条
+(UIView*)drawLineWithSuperView:(UIView*)superView Color:(UIColor*)color Location:(NSInteger)location{
    CGRect frame = superView.frame;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
    if (location>0) {
        line.frame = CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5);
    }
    line.backgroundColor = color;
    [superView addSubview:line];
    return line;
}


//  自定义线条
+(UIView*)drawLineWithSuperView:(UIView*)superView Color:(UIColor*)color Frame:(CGRect)frame{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [superView addSubview:line];
    return line;
}

@end
