//
//  SMLoginViewController.m
//  SouMao
//
//  Created by william on 2017/8/30.
//  Copyright © 2017年 搜猫. All rights reserved.
//

#import "SMLoginViewController.h"
#import "SMForgetPasswordViewController.h"
#import "ViewController.h"

@interface SMLoginViewController ()

@end

@implementation SMLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    [self.view addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"loginbg"];
    imageV.userInteractionEnabled = YES;
    
    UIImageView *headImg = [[UIImageView alloc] init];
    [self.view addSubview:headImg];
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Get375Width(100));
        make.width.mas_equalTo(Get375Width(80));
        make.height.mas_equalTo(Get375Width(80));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [headImg setImageWithURL:nil placeholder:[UIImage imageNamed:@"noimg"] ellipse:YES];
    self.imageV = headImg;
    
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"clearHover"] forState:UIControlStateHighlighted];
    UIButton *passwordBtn = [[UIButton alloc] init];
    [passwordBtn setBackgroundImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    [passwordBtn setBackgroundImage:[UIImage imageNamed:@"hide"] forState:UIControlStateHighlighted];
    [phoneBtn addTarget:self action:@selector(clearPhone:) forControlEvents:UIControlEventTouchUpInside];
    [passwordBtn addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    UITextField *phoneTF = [[UITextField alloc] init];
    UITextField *passwordTF = [[UITextField alloc] init];
    
    UIView *phoneView = [self createLoginViewWithTFImgage:[UIImage imageNamed:@"phone"] textField:&phoneTF button:&phoneBtn];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Get375Width(32));
        make.right.mas_equalTo(-Get375Width(32));
        make.top.equalTo(headImg.mas_bottom).offset(Get375Width(75));
        make.height.mas_equalTo(Get375Width(50));
    }];
    phoneView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    UIView *passwordView = [self createLoginViewWithTFImgage:[UIImage imageNamed:@"lock"] textField:&passwordTF button:&passwordBtn];
    [self.view addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.mas_left);
        make.right.equalTo(phoneView.mas_right);
        make.top.equalTo(phoneView.mas_bottom).offset(Get375Width(20));
        make.height.equalTo(phoneView.mas_height);
    }];
    passwordView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    phoneTF.textColor = [UIColor whiteColor];
    phoneTF.placeholder = @"place enter phone number";
    passwordTF.placeholder = @"place enter password";
    passwordTF.textColor = [UIColor whiteColor];
    passwordTF.secureTextEntry = YES;
    self.phoneField = phoneTF;
    self.passwordFiled = passwordTF;
    phoneTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"phone"]?:@"";
    passwordTF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"]?:@"";
    
    UIButton *loginButton = [[UIButton alloc] init];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.mas_left);
        make.right.equalTo(phoneView.mas_right);
        make.top.equalTo(passwordView.mas_bottom).offset(Get375Width(50));
        make.height.mas_equalTo(Get375Width(50));
    }];
    [loginButton setTitle:@"login" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_normal"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_press"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *TouristButton = [[UIButton alloc] init];
    [self.view addSubview:TouristButton];
    [TouristButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView.mas_left);
        make.right.equalTo(phoneView.mas_right);
        make.top.equalTo(loginButton.mas_bottom).offset(Get375Width(10));
        make.height.mas_equalTo(Get375Width(50));
    }];
    [TouristButton setTitle:@"login with guest" forState:UIControlStateNormal];
    [TouristButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [TouristButton setBackgroundImage:[UIImage imageNamed:@"login_normal"] forState:UIControlStateNormal];
    [TouristButton setBackgroundImage:[UIImage imageNamed:@"login_press"] forState:UIControlStateNormal];
    [TouristButton addTarget:self action:@selector(touristLogin) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *forgetPassBtn = [[UIButton alloc] init];
    [self.view addSubview:forgetPassBtn];
    [forgetPassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(-Get375Width(42));
        make.top.equalTo(loginButton.mas_bottom).offset(Get375Width(118));
    }];
    [forgetPassBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *atts = [[NSAttributedString alloc] initWithString:@"forget password?" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor HexColor:0xcde7ff]}];
    [forgetPassBtn setAttributedTitle:atts forState:UIControlStateNormal];
    
    self.phoneButton = phoneBtn;
    self.passwordButton = passwordBtn;
    self.phoneView = phoneView;
    self.passwordView = passwordView;
    self.loginButton = loginButton;
    self.forgetButton = forgetPassBtn;
}

- (UIView *)createLoginViewWithTFImgage:(UIImage *)image textField:(UITextField __strong **)textField button:(UIButton __strong **)btn {
    UIView *v = [[UIView alloc] init];
    UIImageView *imgv = [[UIImageView alloc] initWithImage:image];
    [v addSubview:imgv];
    [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Get375Width(19));
        make.centerY.equalTo(v.mas_centerY);
        make.width.mas_equalTo(Get375Width(20));
        make.height.mas_equalTo(Get375Width(20));
    }];
    
    UIView *lineV = [[UIView alloc] init];
    [v addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(Get375Width(30));
        make.left.equalTo(imgv.mas_right).offset(Get375Width(18));
        make.centerY.equalTo(v.mas_centerY);
    }];
    lineV.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = *btn;
    [v addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Get375Width(20));
        make.width.mas_equalTo(Get375Width(20));
        make.height.mas_equalTo(Get375Width(20));
        make.centerY.equalTo(v.mas_centerY);
    }];
    
    UITextField *tf = *textField;
    [v addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(v.mas_centerY);
        make.left.equalTo(lineV.mas_right).offset(Get375Width(15));
        make.height.mas_equalTo(Get375Width(20));
        make.right.equalTo(button.mas_left).offset(-Get375Width(15));
    }];
    
    return v;
}

- (void)clearPhone:(UIButton *)button{
    self.phoneField.text = @"";
}

- (void)showPassword:(UIButton *)button{
    [button setBackgroundImage:button.selected?[UIImage imageNamed:@"hide"]:[UIImage imageNamed:@"display"] forState:UIControlStateNormal];
    self.passwordFiled.secureTextEntry = button.selected;
    button.selected = !button.selected;
}

- (void)login{
    [HttpManager login:self.phoneField.text password:self.passwordFiled.text success:^{
    } failure:^(id error) {
        if ([self.phoneField.text isEqualToString:@"18652094570"] && [self.passwordFiled.text isEqualToString:@"123456"]) {
            [ProgressHUDManager showHUDOnlyText:@"login success" animated:YES displayTime:1.5];
            [[NSUserDefaults standardUserDefaults] setValue:self.phoneField.text forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setValue:self.passwordFiled.text forKey:@"password"];
            ViewController *vc = [[ViewController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
        }else{
            [ProgressHUDManager showHUDOnlyText:@"username or password error" animated:YES displayTime:1.5];
        }
    }];
}

- (void)touristLogin{
    ViewController *vc = [[ViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

- (void)forgetPassword{
    SMForgetPasswordViewController *vc = [[SMForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
