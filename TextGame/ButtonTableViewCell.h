//
//  ButtonTableViewCell.h
//  TextGame
//
//  Created by william on 2018/1/16.
//  Copyright © 2018年 william. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonTableViewCell : UITableViewCell

//左侧按钮
@property (nonatomic,strong) UIButton *leftButton;

//右侧按钮
@property (nonatomic,strong) UIButton *rightButton;

//选择Block
@property (nonatomic,copy) void(^selBlock)(NSInteger index);

@end
