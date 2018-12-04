//
//  TCActionSheetBackgroundView.m
//  recruit
//
//  Created by william on 2016/12/5.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "TCActionSheetBackgroundView.h"

@implementation TCActionSheetBackgroundView

+ (nullable instancetype)getExistView{
    for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews ) {
        if ([v isKindOfClass:[self class]]) {
            return (TCActionSheetBackgroundView *)v;
        }
    }
    return nil;
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }
    return self;
}

- (void)setResponseView:(UIView *)responseView{
    _responseView = responseView;
    self.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.3);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window.subviews[window.subviews.count-1] isKindOfClass:[self class]] && ![window.subviews[window.subviews.count-2] isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        [window exchangeSubviewAtIndex:window.subviews.count-2 withSubviewAtIndex:window.subviews.count-1];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    return self.responseView?[self responseView:point]:[self responseActionSheet:point];
}

- (UIView *)responseView:(CGPoint)point{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect windowRect = [window convertRect:self.responseView.frame toView:window];
    bool contains = NO;
    contains = CGRectContainsPoint(windowRect, point);
    if (contains) {
        [self removeFromSuperview];
        return nil;
    }
    self.responseView.hidden = YES;
    self.responseView = nil;
    [self removeFromSuperview];
    return nil;
}

- (UIView *)responseActionSheet:(CGPoint)point{
    bool contains = NO;
    for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([v isKindOfClass:NSClassFromString(@"UITransitionView")]) {
            for (UIView *view in v.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"_UIAlertControllerView")]) {
                    contains = CGRectContainsPoint(view.frame, point);
                    if (contains) {
                        [self removeFromSuperview];
                        return nil;
                    }
                }
            }
        }
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    [self removeFromSuperview];
    return nil;
}



@end
