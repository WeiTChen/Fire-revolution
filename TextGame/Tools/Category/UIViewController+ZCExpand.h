//
//  UIViewController+ZCExpand.h
//  recruit
//
//  Created by william on 2016/12/6.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZCExpand)

- (UIView *)addViewUseMasonry:(void(^)(MASConstraintMaker *make))block;

@end
