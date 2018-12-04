//
//  ZCSegementViewController.m
//  recruit
//
//  Created by 智齿 on 16/10/12.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "ZCSegementViewController.h"

@interface ZCSegementViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *segmentBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, strong) UIScrollView *headerView;
@property (nonatomic, strong) UIScrollView *headerSelectedView;
@property (nonatomic, strong) UIView *headerSelectedSuperView;
@property (nonatomic, strong) NSMutableArray *isFinishedArray;

@end

@implementation ZCSegementViewController

- (UIScrollView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UIScrollView alloc] init];
        self.zc_buttonHeight = TRUE_SIZE(80);
        _headerView.frame = CGRectMake(0, 0, self.width, self.zc_buttonHeight);
        _headerView.backgroundColor = [UIColor HexColor:0x395eff];
    }
    return _headerView;
}

- (UIScrollView *)headerSelectedView {
    
    if (!_headerSelectedView) {
        _headerSelectedView = [[UIScrollView alloc] init];
        _headerSelectedView.frame =CGRectMake(0, 0, self.zc_buttonWidth, self.zc_buttonHeight);
        _headerSelectedView.backgroundColor = [UIColor HexColor:0x395eff];
    }
    return _headerSelectedView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSegment
{
    switch (self.zc_Type) {
        case 1: {
            self.zc_buttonWidth = self.width/self.zc_titleArray.count;
            [self addBackViewWithCount:self.zc_titleArray.count];
            [self addFixedHeader:self.zc_titleArray];
            for (NSInteger i = 0; i < self.zc_viewArray.count; i++) {
                [self.isFinishedArray addObject:@0];
            }
            [self initViewController:0];
            break;
        }
        case 0: {
            [self addBackViewWithCount:self.zc_titleArray.count];
            [self addScrollHeader:self.zc_titleArray];
            for (NSInteger i = 0; i < self.zc_viewArray.count; i++) {
                [self.isFinishedArray addObject:@0];
            }
            [self initViewController:0];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - private
- (void)initViewController:(NSInteger)index
{
    if ([self.isFinishedArray[index] integerValue] == 0) {
        Class className = NSClassFromString(self.zc_viewArray[index]);
        UIViewController *viewController = [[className alloc] init];
        [viewController.view setFrame:CGRectMake(self.width*index, 0, self.width, self.height - self.zc_buttonHeight)];
        [self addChildViewController:viewController];
        [self.backView addSubview:viewController.view];
        self.isFinishedArray[index] = @1;
    }else{
        for (UIViewController *vc in self.childViewControllers) {
            if ([vc isKindOfClass:NSClassFromString(self.zc_viewArray[index])]) {
                [vc performSelector:@selector(reloadData)];
            }
        }
    }
}

- (void)addBackViewWithCount:(NSInteger)count
{
    self.backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.zc_buttonHeight, self.width, self.height - self.zc_buttonHeight)];
    self.backView.contentSize = CGSizeMake(self.width*count, self.height - self.zc_buttonHeight);
    [self.backView setPagingEnabled:YES];
    [self.backView setShowsVerticalScrollIndicator:NO];
    [self.backView setShowsHorizontalScrollIndicator:NO];
    self.backView.backgroundColor = self.zc_backgroundColor;
    self.backView.bounces = NO;
    
    self.backView.delegate = self;
    [self.view addSubview:self.backView];
}

- (void)addScrollHeader:(NSArray *)titleArray
{
    self.headerView.contentSize = CGSizeMake(self.zc_buttonWidth * titleArray.count, self.zc_buttonHeight);
    [self.view addSubview:self.headerView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.zc_buttonWidth * index, 0, self.zc_buttonWidth, self.zc_buttonHeight)];
        _titleLabel.textColor = self.zc_titleColor;
        _titleLabel.text = titleArray[index];
        _titleLabel.font = PLACEHOLDER_FONT;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.headerView addSubview:_titleLabel];
        
        _segmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.zc_buttonWidth * index, 0, self.zc_buttonWidth, self.zc_buttonHeight)];
        _segmentBtn.tag = index;
        [_segmentBtn setBackgroundColor:[UIColor clearColor]];
        [_segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_segmentBtn];
    }
    
    
    self.headerSelectedSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.zc_buttonWidth, self.zc_buttonHeight)];
    [self.headerView addSubview:self.headerSelectedSuperView];
    
    self.headerSelectedView.contentSize = CGSizeMake(self.zc_buttonWidth * titleArray.count, self.zc_buttonHeight);
    [self.headerSelectedSuperView addSubview:self.headerSelectedView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.zc_buttonWidth * index, 0, self.zc_buttonWidth, self.zc_buttonHeight)];
        _titleLabel.textColor = self.zc_titleSelectedColor;
        _titleLabel.text = titleArray[index];
        _titleLabel.font = PLACEHOLDER_FONT;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.headerSelectedView addSubview:_titleLabel];
        
    }
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerSelectedView.contentSize.height - self.zc_lineHeight, self.headerSelectedView.contentSize.width, self.zc_lineHeight)];
    bottomLine.backgroundColor = self.zc_bottomLineColor;
    [self.headerSelectedView addSubview:bottomLine];
}


- (void)addFixedHeader:(NSArray *)titleArray
{
    self.headerView.contentSize = CGSizeMake(self.width, self.zc_buttonHeight);
    [self.view addSubview:self.headerView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.zc_buttonWidth * index, 0, self.zc_buttonWidth, self.zc_buttonHeight)];
        _titleLabel.textColor = self.zc_titleColor;
        _titleLabel.text = titleArray[index];
        _titleLabel.font = PLACEHOLDER_FONT;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.headerView addSubview:_titleLabel];
        
        _segmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.zc_buttonWidth * index, 0, self.zc_buttonWidth, self.zc_buttonHeight)];
        _segmentBtn.tag = index;
        [_segmentBtn setBackgroundColor:[UIColor clearColor]];
        [_segmentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_segmentBtn];
    }
    
    self.headerSelectedSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.zc_buttonWidth, self.zc_buttonHeight)];
    [self.headerView addSubview:self.headerSelectedSuperView];
    
    self.headerSelectedView.contentSize = CGSizeMake(self.width, self.zc_buttonHeight);
    [self.headerSelectedSuperView addSubview:self.headerSelectedView];
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.zc_buttonWidth * index, 0, self.zc_buttonWidth, self.zc_buttonHeight)];
        _titleLabel.textColor = self.zc_titleSelectedColor;
        _titleLabel.text = titleArray[index];
        _titleLabel.font = PLACEHOLDER_FONT;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.headerSelectedView addSubview:_titleLabel];
        
    }
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerSelectedView.contentSize.height - self.zc_lineHeight, self.headerSelectedView.contentSize.width, self.zc_lineHeight)];
    bottomLine.backgroundColor = self.zc_bottomLineColor;
    [self.headerSelectedView addSubview:bottomLine];

}

- (void)btnClick:(UIButton *)button{
    [self.backView scrollRectToVisible:CGRectMake(button.tag*self.width, 0, self.backView.frame.size.width, self.backView.frame.size.height) animated:YES];
    [self didSelectSegmentIndex:button.tag];
}

- (void)didSelectSegmentIndex:(NSInteger)index{
    
}


- (void)correctHeader:(UIScrollView *)scrollView{
    if (scrollView == _backView) {
        CGFloat location = _headerSelectedView.contentOffset.x + self.zc_buttonWidth/2 - self.width/2;
        
        if (location <= 0) {
            [UIView animateWithDuration:.3 animations:^{
                _headerView.contentOffset = CGPointMake(0, _headerSelectedView.contentOffset.y);
            }];
        }else if (location >= _headerView.contentSize.width - self.width) {
            [UIView animateWithDuration:.3 animations:^{
                _headerView.contentOffset = CGPointMake(_headerView.contentSize.width - self.width, _headerSelectedView.contentOffset.y);
            }];
        }else {
            if (_headerView.contentOffset.x != location) {
                [UIView animateWithDuration:.3 animations:^{
                    _headerView.contentOffset = CGPointMake(location, _headerSelectedView.contentOffset.y);
                }];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _backView) {
        self.headerSelectedSuperView.frame = CGRectMake(scrollView.contentOffset.x * (self.zc_buttonWidth/self.width), self.headerSelectedSuperView.frame.origin.y, self.headerSelectedSuperView.frame.size.width, self.headerSelectedSuperView.frame.size.height);
        self.headerSelectedView.contentOffset = CGPointMake(scrollView.contentOffset.x * (self.zc_buttonWidth/self.width), 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _backView) {
        [self correctHeader:scrollView];
        [self initViewController:(scrollView.contentOffset.x/self.width)];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _backView) {
        [self correctHeader:scrollView];
        [self initViewController:(scrollView.contentOffset.x/self.width)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getter
- (CGFloat)height {
    return self.view.frame.size.height;
}

- (CGFloat)width {
    return self.view.frame.size.width;
}

- (CGFloat)originX {
    return self.view.frame.origin.x;
}

- (CGFloat)originY {
    return self.view.frame.origin.y;
}

- (NSMutableArray *)isFinishedArray {
    if (_isFinishedArray == nil) {
        _isFinishedArray = [[NSMutableArray alloc] init];
    }
    return _isFinishedArray;
}

- (CGFloat)zc_lineHeight
{
    if (_zc_lineHeight == 0) {
        _zc_lineHeight = 3;
    }
    return _zc_lineHeight;
}

- (UIColor *)zc_backgroundColor
{
    if (_zc_backgroundColor == nil) {
        _zc_backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    }
    return _zc_backgroundColor;
}

- (UIColor *)zc_headerColor
{
    if (_zc_headerColor == nil) {
        _zc_headerColor = [UIColor HexColor:0x395eff];
    }
    return _zc_headerColor;
}

- (UIColor *)zc_titleColor
{
    if (_zc_titleColor == nil) {
        _zc_titleColor = [UIColor HexColor:0x395eff];
    }
    return _zc_titleColor;
}

- (UIColor *)zc_titleSelectedColor
{
    if (_zc_titleSelectedColor == nil) {
        _zc_titleSelectedColor = [UIColor whiteColor];
    }
    return _zc_titleSelectedColor;
}

- (UIColor *)zc_bottomLineColor
{
    if (_zc_bottomLineColor == nil) {
        _zc_bottomLineColor = self.zc_titleSelectedColor;
    }
    return _zc_bottomLineColor;
}
@end
