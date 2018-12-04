//
//  UIViewController+ZCExpand.m
//  recruit
//
//  Created by william on 2016/12/6.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "UIViewController+ZCExpand.h"

@implementation UIViewController (ZCExpand)

- (UIView *)addViewUseMasonry:(void(^)(MASConstraintMaker *))block{
    UIView *backGroundView = [[UIView alloc] init];
    [self.view addSubview:backGroundView];
    [backGroundView mas_makeConstraints:block];
    return backGroundView;
}

@end
