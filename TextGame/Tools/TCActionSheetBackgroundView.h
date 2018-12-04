//
//  TCActionSheetBackgroundView.h
//  recruit
//
//  Created by william on 2016/12/5.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCActionSheetBackgroundView : UIView

//自定义响应视图
@property (nonatomic,strong,nullable) UIView *responseView;

+ (nullable instancetype)getExistView;

@end
