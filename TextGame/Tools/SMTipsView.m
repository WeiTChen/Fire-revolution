//
//  SMTipsView.m
//  SouMao
//
//  Created by william on 2017/11/6.
//  Copyright © 2017年 搜猫. All rights reserved.
//

#import "SMTipsView.h"

@implementation SMTipsView

- (instancetype)init{
    if (self = [super init]) {
        self.tipsImgV = [[UIImageView alloc] init];
        [self addSubview:self.tipsImgV];
        [self.tipsImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(Get375Width(200));
            make.height.mas_equalTo(Get375Width(200));
            make.centerY.equalTo(self.mas_centerY).offset(-Get375Width(20));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.tipsImgV.mas_bottom).offset(Get375Width(20));
        }];
        label.textColor = [UIColor HexColor:0xb9c9d9];
        self.tipsLb = label;
    }
    
    return self;
}
@end
