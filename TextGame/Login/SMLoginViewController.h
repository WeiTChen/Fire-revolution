//
//  SMLoginViewController.h
//  SouMao
//
//  Created by william on 2017/8/30.
//  Copyright © 2017年 搜猫. All rights reserved.
//

#import "RootViewController.h"

@interface SMLoginViewController : RootViewController

//头像框
@property (nonatomic,strong) UIImageView *imageV;

//手机输入框
@property (nonatomic,strong) UITextField *phoneField;

//密码输入框
@property (nonatomic,strong) UITextField *passwordFiled;

//手机右侧按钮
@property (nonatomic,strong) UIButton *phoneButton;

//密码右侧按钮
@property (nonatomic,strong) UIButton *passwordButton;

//手机左侧view
@property (nonatomic,strong) UIView *phoneView;

//密码左侧view
@property (nonatomic,strong) UIView *passwordView;

//登陆密码
@property (nonatomic,strong) UIButton *loginButton;

//忘记密码
@property (nonatomic,strong) UIButton *forgetButton;

@end
