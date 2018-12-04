//
//  ZCDefaultMaskView.m
//  recruit
//
//  Created by william on 2016/10/26.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "ZCDefaultMaskView.h"

@implementation ZCDefaultMaskView

- (void)show{
    self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    UITapGestureRecognizer *tapOne =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tapOne];
}

- (void)removeView{
    if (_viewClick) {
        _viewClick();
    }
}


@end
