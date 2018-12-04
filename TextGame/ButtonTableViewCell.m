//
//  ButtonTableViewCell.m
//  TextGame
//
//  Created by william on 2018/1/16.
//  Copyright © 2018年 william. All rights reserved.
//

#import "Masonry.h"
#import "ButtonTableViewCell.h"

@implementation ButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        UIButton *leftBtn = [[UIButton alloc] init];
        [self addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.equalTo(self.mas_centerX).offset(-10);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIButton *rightBtn = [[UIButton alloc] init];
        [self addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.left.equalTo(self.mas_centerX).offset(10);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [leftBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.layer.borderWidth = rightBtn.layer.borderWidth = 1;
        leftBtn.layer.borderColor = rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _leftButton = leftBtn;
        _rightButton = rightBtn;
    }
    return self;
    
}

- (void)selectBtn:(UIButton *)button{
    if (self.selBlock) {
        self.selBlock(button==self.rightButton);
    }
}


@end
