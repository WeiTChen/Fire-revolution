//
//  FMKLineChartTabBar.h
//  FMMarket
//
//  Created by dangfm on 15/8/18.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

/**
 *  主要用行情详情页k线图切换控件
 *  控件默认的标题为  分时线，日K，周K，月K
    也可以定制，设置titles的值
 */


#import <UIKit/UIKit.h>
//#import <FMStockChart/FMStockChart.h>

#define kFMKLineChartTabBarTitles @[@"分时线",@"日 K",@"周 K",@"月 K"]
#define kFMKLineChartTabBarHeight TRUE_SIZE(80)
#define kFMKLineChartTabBarLineHeight 3

@protocol FMKLineChartTabBarDelegate <NSObject>
@optional
/**
 *  按钮点击代理
 *
 *  @param stockChartType 图表类型
 */
-(void)FMKLineChartTabBarClickButton:(int )stockChartType;

@end

typedef void (^clickChartTabBarButtonHandle)(NSInteger tag);

@interface FMKLineChartTabBar : UIView

@property (nonatomic,retain) UIView *line;          // 线条
@property (nonatomic,retain) NSArray *titles;       // 标题集合
@property (nonatomic,retain) UIView *box;     // 盒子
@property (nonatomic,weak) id <FMKLineChartTabBarDelegate> delegate;  // 代理
@property (nonatomic,copy) clickChartTabBarButtonHandle clickChartTabBarButtonHandle;  // 点击回调
@property (nonatomic,assign) BOOL isMove;  // 是否可移动


/**
 *  初始化
 *
 *  @param frame  位置大小
 *  @param titles 标题集合
 *
 *  @return 自定义tabBar工具栏
 */
-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray*)titles;
-(instancetype)initWithFrame:(CGRect)frame Titles:(NSArray*)titles IsMove:(BOOL)isMove;
//-(instancetype)initWithRadarFrame:(CGRect)frame Titles:(NSArray*)titles;
-(instancetype)initWithInterFrame:(CGRect)frame Titles:(NSArray *)titles;
/**
 *  高亮某个按钮
 *
 *  @param index 索引
 */
//-(void)updateHighlightsTitleWithIndex:(NSInteger)index;

//- (void)updateRadarHighlightsTitleWithIndex:(NSInteger)index;

- (void)updateInterHightlightsTitleWithIndex:(NSInteger)index;
@end


