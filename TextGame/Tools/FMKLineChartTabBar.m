//
//  FMKLineChartTabBar.m
//  FMMarket
//
//  Created by dangfm on 15/8/18.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "FMKLineChartTabBar.h"
#import "ZCLineView.h"

@implementation FMKLineChartTabBar

/**
 *  默认初始化
 *
 *  @param frame frame值
 *
 *  @return FMKLineChartTabBar
 */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        _isMove = YES;
        [self initViews];
    }
    return self;
}

/**
 *  初始化自定义标题
 *
 *  @param frame frame值
 *
 *  @return FMKLineChartTabBar
 */
-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray*)titles{
    if (self==[super initWithFrame:frame]) {
        _isMove = YES;
        _titles = titles;
        [self initViews];
    }
    return self;
}



/**
 *  初始化自定义标题，用于面试界面
 *
 *  @param frame frame值
 *
 *  @return FMKLineChartTabBar
 */
- (instancetype)initWithInterFrame:(CGRect)frame Titles:(NSArray *)titles {
    
    if (self==[super initWithFrame:frame]) {
        _isMove = YES;
        _titles = titles;
        [self initInterViews];
    }
    return self;
}


/**
 *  初始化标题，标题是否可以点击
 *
 *  @param frame frame值
 *
 *  @return FMKLineChartTabBar
 */
-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray*)titles IsMove:(BOOL)isMove{
    if (self==[super initWithFrame:frame]) {
        _isMove = isMove;
        _titles = titles;
        [self initViews];
    }
    return self;
}






/**
 *  用于面试模块初始化UI
 */
- (void)initInterViews {
    
    if (!_titles) {
        _titles = kFMKLineChartTabBarTitles;
    }
    self.backgroundColor = [UIColor HexColor:0x395eff];
    _box = [[UIView alloc] initWithFrame:self.bounds];
    CGFloat w = self.frame.size.width/_titles.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat h = self.frame.size.height;
    NSInteger i=0;
    for (NSString *name in _titles) {
        UIButton *l = [[UIButton alloc] initWithFrame:CGRectMake(x, y , w, h)];

        l.titleLabel.font = [UIFont systemFontOfSize:TRUE_FONT(12)];
        [l setTitle:name forState:UIControlStateNormal];
        [l setTitleColor:[UIColor HexColor:0xffffff] forState:UIControlStateNormal];
        [_box addSubview:l];
        l.titleLabel.font = [UIFont systemFontOfSize:14];
        l.tag = i;
        [l addTarget:self
              action:@selector(clickTabBarHandle:)
    forControlEvents:UIControlEventTouchUpInside];
        l = nil;
        x += w;
        i++;
    }
    [self addSubview:_box];
    _line = [ZCLineView drawLineWithSuperView:self
                                Color:[UIColor whiteColor]
                                Frame:CGRectMake(0, h-kFMKLineChartTabBarLineHeight, 0, kFMKLineChartTabBarLineHeight)];
    [self clickInterTabBarHandle:[_box.subviews firstObject]];
}

/**
 *  默认初始化UI
 */
-(void)initViews{
    if (!_titles) {
        _titles = kFMKLineChartTabBarTitles;
    }
    self.backgroundColor = [UIColor HexColor:0x395eff];
    // 装按钮的盒子
    _box = [[UIView alloc] initWithFrame:self.bounds];
    _isMove = YES;
    CGFloat w = self.frame.size.width/_titles.count;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat h = self.frame.size.height;
    NSInteger i=0;
    // 循环建按钮
    for (NSString *name in _titles) {
        UIButton *l = [[UIButton alloc] initWithFrame:CGRectMake(x, y , w, h)];
        //l.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        l.titleLabel.font = [UIFont systemFontOfSize:14];
        [l setTitle:name forState:UIControlStateNormal];
        [l setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_box addSubview:l];
        l.tag = i;
        [l addTarget:self
              action:@selector(clickTabBarHandle:)
    forControlEvents:UIControlEventTouchUpInside];
        l = nil;
        x += w;
        i++;
    }
    [self addSubview:_box];
    // 线条
    [ZCLineView drawLineWithSuperView:self Color:[UIColor whiteColor] Location:0];
    [ZCLineView drawLineWithSuperView:self Color:[UIColor whiteColor] Location:1];
    // 移动线条
    _line = [ZCLineView drawLineWithSuperView:self
                                Color:[UIColor whiteColor]
                                Frame:CGRectMake(0, h-kFMKLineChartTabBarLineHeight, 0, kFMKLineChartTabBarLineHeight)];
}

/**
 *  点击事件
 *
 *  @param bt 所点击的按钮
 */
-(void)clickTabBarHandle:(UIButton*)bt{
    if ([[bt titleForState:UIControlStateNormal] isEqualToString:@""]) {
        return;
    }
    int tag = (int)bt.tag;
    // 首先高亮所点击的按钮
    [self updateInterHightlightsTitleWithIndex:tag];
    
    // block回调 如果没定义block则代理回传
    if (self.clickChartTabBarButtonHandle) {
        self.clickChartTabBarButtonHandle(tag);
    }else{
        if ([self.delegate respondsToSelector:@selector(FMKLineChartTabBarClickButton:)]) {
            [self.delegate FMKLineChartTabBarClickButton:tag];
        }
    }
}

/**
 *  跟clickTabBarHandle 一样，专用于雷达模块
 *
 *  @param bt 所点击按钮
 */
-(void)clickInterTabBarHandle:(UIButton*)bt{
    if ([[bt titleForState:UIControlStateNormal] isEqualToString:@""]) {
        return;
    }
    int tag = (int)bt.tag;
    
    [self updateInterHightlightsTitleWithIndex:tag];
    
    if (self.clickChartTabBarButtonHandle) {
        self.clickChartTabBarButtonHandle(tag);
    }else{
        if ([self.delegate respondsToSelector:@selector(FMKLineChartTabBarClickButton:)]) {
            [self.delegate FMKLineChartTabBarClickButton:tag];
        }
    }
}

/**
 *  高亮某个下标的按钮 用于面试模块
 *
 *  @param index 按钮下标
 */
- (void)updateInterHightlightsTitleWithIndex:(NSInteger)index {
    
    NSArray *views = _box.subviews;
    UIButton *bt = [views objectAtIndex:index];
    // 所有按钮恢复默认
    for (UIButton *l in views) {
        if ([[l class] isSubclassOfClass:[UIButton class]]) {
            [l setTitleColor:[UIColor HexColor:0x7facff] forState:UIControlStateNormal];
        }
    }
    // 如果可以点击，设置底线移动到当前按钮，当前按钮高亮
    if (_isMove) {
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CGFloat w = [bt.titleLabel.text
                     sizeWithAttributes:@{NSFontAttributeName:bt.titleLabel.font}].width+5;
        [UIView animateWithDuration:0.2 animations:^{
            _line.frame = CGRectMake((bt.frame.size.width-w)/2+bt.frame.origin.x-8,
                                     _line.frame.origin.y,
                                     w + 16,
                                     _line.frame.size.height);
            
        }];
    }
}

@end
