//
//  MenuView.h
//  recruit
//
//  Created by 智齿 on 16/8/10.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property (nonatomic,copy) void(^cellSelectBlock)(NSDictionary *cellDic);

- (void)addMenuViewWithFrame:(CGRect )frame cellClass:(Class )cellClass cellCount:(NSUInteger )cellCount showBlock:(void(^)(NSDictionary *cellDic))showBlock animation:(bool)animation;

@end
