//
//  SMForgetPasswordViewController.m
//  SouMao
//
//  Created by william on 2017/10/30.
//  Copyright © 2017年 搜猫. All rights reserved.
//

#import "SMForgetPasswordViewController.h"

@interface SMForgetPasswordViewController ()

//手机左侧图片控件
@property (nonatomic,strong) UIImageView *phoneImgV;

//密码左侧控件
@property (nonatomic,strong) UIImageView *passwordImgV;

//time
@property (nonatomic,assign) int time;

//用来记录是否获取验证码
@property (nonatomic,assign) bool isSend;

//timeer
@property (nonatomic,strong) NSTimer *timer;

//phon
@property (nonatomic,strong) NSString *phone;

@end

@implementation SMForgetPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageV.hidden = YES;
    
    for (UIView *v in self.phoneView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            self.phoneImgV = (UIImageView *)v;
        }
    }
    
    for (UIView *v in self.passwordView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            self.passwordImgV = (UIImageView *)v;
        }
    }
    
    UILabel *titleLB = [[UILabel alloc] init];
    [self.view addSubview:titleLB];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.imageV.mas_centerY);
    }];
    titleLB.text = @"Retrieve the password";
    titleLB.textColor = [UIColor whiteColor];
    
    self.phoneImgV.image = [UIImage imageNamed:@"phone"];
    self.passwordImgV.image = [UIImage imageNamed:@"round_check"];
    [self.phoneButton setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [self.passwordButton setBackgroundImage:[UIImage imageNamed:@"sendCode"] forState:UIControlStateNormal];
    [self.passwordButton setBackgroundImage:[UIImage imageNamed:@"sendCodeHover"] forState:UIControlStateHighlighted];
    [self.passwordButton setTitle:@"send" forState:UIControlStateNormal];
    [self.passwordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.phoneField.placeholder = @"Please enter the cell phone number";
    self.passwordFiled.placeholder = @"Please enter the verification code";
    [self.loginButton setTitle:@"next" forState:UIControlStateNormal];
    [self.passwordButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Get375Width(60));
        make.height.mas_equalTo(Get375Width(30));
    }];
    self.passwordFiled.secureTextEntry = NO;;
    self.passwordFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.forgetButton.hidden = YES;
    self.time = 60;

    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(37);
        make.height.mas_equalTo(30);
    }];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"left-hover"] forState:UIControlStateNormal];
    self.passwordFiled.text = nil;
}

- (void)backVC{
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)replateNumber{
    if (self.time > 0) {
        [self.passwordButton setTitle:[NSString stringWithFormat:@"%d",self.time] forState:UIControlStateNormal];
        self.time--;
        self.passwordButton.enabled = NO;
    }else{
        [self.passwordButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        self.passwordButton.enabled = YES;
    }
}
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(replateNumber) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)showPassword:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"发送"]) {
        //发送验证码
        if (self.phoneField.text.length!=11) {
            [ProgressHUDManager showHUDOnlyText:@"请输入手机号" animated:YES displayTime:1.5];
            return;
        }
        [HttpManager getVcodeToPhone:self.phoneField.text success:^{
            self.isSend = YES;
            [self.timer class];
            self.time = 60;
        } failure:nil];
    }else{
        self.passwordFiled.text = @"";
    }
    
}

- (void)login{
    if ([self.loginButton.titleLabel.text isEqualToString:@"下一步"]) {
        if (self.phoneField.text.length==0) {
            [ProgressHUDManager showHUDOnlyText:@"请输入手机号" animated:YES displayTime:1.5];
            return;
        }
        if (self.passwordFiled.text.length==0) {
            [ProgressHUDManager showHUDOnlyText:@"请输入验证码" animated:YES displayTime:1.5];
            return;
        }
        self.phone = self.phoneField.text;
        [HttpManager checkVcodeWithCode:self.passwordFiled.text phone:self.phoneField.text success:^{
            [self sendPassword];
            [self.timer invalidate];
        } failure:nil];
    }else{
        if (self.phoneField.text.length==0) {
            [ProgressHUDManager showHUDOnlyText:@"请输入新的密码" animated:YES displayTime:1.5];
            return;
        }
        if (self.passwordFiled.text.length==0) {
            [ProgressHUDManager showHUDOnlyText:@"请确认新的密码" animated:YES displayTime:1.5];
            return;
        }
        if (![self.phoneField.text isEqualToString:self.passwordFiled.text]) {
            [ProgressHUDManager showHUDOnlyText:@"两次密码不一致" animated:YES displayTime:1.5];
            return;
        }
        [HttpManager resetPwdWithPwd:self.passwordFiled.text phone:self.phone success:^{
            
            [self resetPassword];
        } failure:nil];
    }
}

//发送验证码
- (void)sendPassword{
    self.phoneField.text = @"";
    self.passwordFiled.text = @"";
    self.phoneImgV.image = [UIImage imageNamed:@"lock"];
    self.passwordImgV.image = [UIImage imageNamed:@"lock"];
    [self.phoneButton setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [self.phoneButton setBackgroundImage:[UIImage imageNamed:@"clearHover"] forState:UIControlStateHighlighted];
    [self.passwordButton setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [self.passwordButton setBackgroundImage:[UIImage imageNamed:@"clearHover"] forState:UIControlStateHighlighted];
    [self.passwordButton setTitle:@"" forState:UIControlStateNormal];
    self.phoneField.placeholder = @"请输入新的密码";
    self.passwordFiled.placeholder = @"确认新的密码";
    [self.loginButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.passwordButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(Get375Width(20));
        make.height.mas_equalTo(Get375Width(20));
    }];
    self.phoneField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordFiled.keyboardType = UIKeyboardTypeASCIICapable;
    self.phoneField.secureTextEntry = YES;
    self.passwordFiled.secureTextEntry = YES;
}

- (void)resetPassword{
    [ProgressHUDManager showHUDOnlyText:@"重置密码成功" animated:YES displayTime:1.5];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
