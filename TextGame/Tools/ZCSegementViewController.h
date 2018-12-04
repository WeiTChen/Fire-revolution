//
//  ZCSegementViewController.h
//  recruit
//
//  Created by 智齿 on 16/10/12.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "RootViewController.h"

typedef NS_ENUM(NSInteger, ZCSegmentHeaderType) {
    ZCSegmentHeaderTypeScroll,//标签栏可滚动
    ZCSegmentHeaderTypeFixed//标签栏固定
};

@interface ZCSegementViewController : RootViewController

//required
//必填，标签栏标题字符串数组
@property (nonatomic, strong) NSArray *zc_titleArray;

//必填，每个标签对应ViewController字符串数组，数量应与cbs_titleArray一样
@property (nonatomic, strong) NSArray *zc_viewArray;

//初始化方法，设置完cbs_titleArray和cbs_viewArray后调用
- (void)initSegment;

//optional
//标签栏颜色，默认白色
@property (nonatomic, strong) UIColor *zc_headerColor;

//非选中状态下标签字体颜色，默认黑色
@property (nonatomic, strong) UIColor *zc_titleColor;

//选中标签字体颜色，默认白色
@property (nonatomic, strong) UIColor *zc_titleSelectedColor;

//选中标签底部划线颜色，默认蓝色
@property (nonatomic, strong) UIColor *zc_bottomLineColor;

//segmentView背景色，默认透明
@property (nonatomic, strong) UIColor *zc_backgroundColor;

//标签栏高度
@property (nonatomic, assign) CGFloat zc_buttonHeight;

//标签栏每个按钮宽度
@property (nonatomic, assign) CGFloat zc_buttonWidth;

//选中视图下划线高度，置零可取消下划线
@property (nonatomic, assign) CGFloat zc_lineHeight;

//标签栏类型，默认为滚动标签栏
@property (nonatomic, assign) ZCSegmentHeaderType zc_Type;

//点击标签栏按钮调用方法，可选
- (void)didSelectSegmentIndex:(NSInteger)index;

@end
