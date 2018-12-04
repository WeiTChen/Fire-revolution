//
//  ProgressHUDManager.m
//  recruit
//
//  Created by 智齿 on 16/8/9.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "ProgressHUDManager.h"

@implementation ProgressHUDManager

+ (void)showHUDOnlyText:(NSString *)text animated:(BOOL)animated displayTime:(NSTimeInterval)time
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:animated];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        hud.offset = CGPointMake(0, 32);
        [hud hideAnimated:YES afterDelay:time];
    });
    
}

+ (void)showHUDText:(NSString *)text animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:animated];
        hud.label.text = text;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeHudView];
        });
    });
}

+ (void)showHUDImageAnimated:(BOOL)animated {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:animated];
        hud.mode = MBProgressHUDModeCustomView;
        UIImageView *imageView = [[UIImageView alloc] init];
        
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i = 1; i < 56; i++) {
            
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_animat00%d",i]];
            [imageArr addObject:image];
        }
        
        imageView.animationImages = imageArr;
        imageView.animationDuration = 2.3;
        [imageView startAnimating];
        
        hud.customView = imageView;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeHudView];
        });
    });
}


+ (void)removeHudView
{
    for (UIView *hud in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([hud isKindOfClass:[MBProgressHUD class]])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud removeFromSuperview];
            });
        }
    }
}

@end
