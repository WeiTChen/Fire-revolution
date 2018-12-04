//
//  SMTextView.m
//  SouMao
//
//  Created by william on 2017/12/7.
//  Copyright © 2017年 搜猫. All rights reserved.
//

#import "SMTextView.h"

@interface SMTextView ()

@end
@implementation SMTextView

- (instancetype)initWithPlaceHolder:(NSString *)placeHolder delegate:(id)delegate{
    if (self = [super init]) {
        UITextView *textView = [[UITextView alloc] init];
        [self addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        textView.font = [UIFont systemFontOfSize:14];
        textView.delegate = delegate;
        
        UILabel *lb = [[UILabel alloc] init];
        [self addSubview:lb];
        lb.text = placeHolder;
        lb.textColor = GRAY_COLOR;
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Get375Width(10));
            make.top.mas_equalTo(Get375Width(10));
        }];
        lb.font = [UIFont systemFontOfSize:14];
        self.phlabel = lb;
        self.textView = textView;
    }
    return self;
}




@end
