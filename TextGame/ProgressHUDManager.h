//
//  ProgressHUDManager.h
//  recruit
//
//  Created by 智齿 on 16/8/9.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "MBProgressHUD.h"

@interface ProgressHUDManager : MBProgressHUD

+ (void)showHUDOnlyText:(NSString *)text animated:(BOOL)animated displayTime:(NSTimeInterval)time;

+ (void)showHUDText:(NSString *)text animated:(BOOL)animated;

+ (void)showHUDImageAnimated:(BOOL)animated;

+ (void)removeHudView;

@end
