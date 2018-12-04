//
//  TCViewManger.m
//  recruit
//
//  Created by 智齿 on 16/8/10.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "TCViewManger.h"
#import "MenuView.h"

@implementation TCViewManger

+ (UIView *)addMenuViewWithFrame:(CGRect)frame cellClass:(Class)cellClass cellCount:(NSUInteger)cellCount showBlock:(void (^)(NSDictionary *))showBlock selectBlock:(void (^)(NSDictionary *))cellSelectBlock animation:(bool)animation
{
    MenuView *menuView = [[MenuView alloc] initWithFrame:frame];
    [[UIApplication sharedApplication].keyWindow addSubview:menuView];
    [menuView addMenuViewWithFrame:frame cellClass:cellClass cellCount:cellCount showBlock:showBlock animation:animation];
    menuView.cellSelectBlock = cellSelectBlock;
    if (animation)
    {
        menuView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        [UIView animateWithDuration:0.3 animations:^{
            menuView.frame = frame;
        }];
    }
    return menuView;
}

+ (void)removeMenuViewIfExist
{
    for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([v isKindOfClass:[MenuView class]])
        {
            [v removeFromSuperview];
        }
    }
}

+ (void)addShadowForView:(UIView *)view
{
    view.layer.shadowColor = RGB_COLOR(57, 94, 255).CGColor;
    view.layer.shadowOpacity = 0.16;
    view.layer.shadowOffset = CGSizeMake(0, 1.5);
//    view.layer.shadowRadius = 1.5;
}


@end
