//
//  SMTextView.h
//  SouMao
//
//  Created by william on 2017/12/7.
//  Copyright © 2017年 搜猫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMTextView : UIView

//占位标签
@property (nonatomic,strong) UILabel *phlabel;

//文本输入
@property (nonatomic,strong) UITextView *textView;

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder delegate:(id)delegate;


@end
