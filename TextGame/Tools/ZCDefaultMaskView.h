//
//  ZCDefaultMaskView.h
//  recruit
//
//  Created by william on 2016/10/26.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCDefaultMaskView : UIView

//点击事件
@property (nonatomic,copy) void(^viewClick)(void);

- (void)show;

@end
