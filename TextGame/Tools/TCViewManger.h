//
//  TCViewManger.h
//  recruit
//
//  Created by 智齿 on 16/8/10.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCViewManger : UIView

+ (UIView *)addMenuViewWithFrame:(CGRect )frame cellClass:(Class )cellClass cellCount:(NSUInteger )cellCount showBlock:(void(^)(NSDictionary *cellDic))showBlock selectBlock:(void(^)(NSDictionary *cellDic))cellSelectBlock animation:(bool)animation;

+ (void)addShadowForView:(UIView *)view;

+ (void)removeMenuViewIfExist;

@end
