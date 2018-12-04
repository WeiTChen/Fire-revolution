//
//  RootViewController.m
//  recruit
//
//  Created by 智齿 on 16/8/9.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "RootViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 80.0f;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [self addNotification];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 15, 20)];
    imgv.image = [[UIImage imageNamed:@"left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [v addSubview:imgv];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(18, 10, 42, 20)];
    lb.text = @"back";
    [v addSubview:lb];
    UITapGestureRecognizer *backT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [v addGestureRecognizer:backT];
    self.leftItem = [[UIBarButtonItem alloc] initWithCustomView:v];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)addCancelLeft{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftBtn setTitle:@"cancel" forState:UIControlStateNormal];
    [leftBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = self.leftItem;
}

- (void)rightClick{
    [self.view endEditing:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.view endEditing:YES];
}

- (void)setupNavTitleText:(NSString *)text
{
    self.navigationItem.title = text;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)setupNavtitleView:(UIView *)view
{
    self.navigationItem.titleView = view;
}

- (void)hideBackButton
{
    self.leftItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)addRightTitleWithImage:(UIImage *)image target:(id)target selector:(SEL)selecter
{
    self.rightItem = [[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:target action:selecter];
    self.rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

- (void)addRightTitleWithTitle:(NSString *)title target:(id)target selector:(SEL)selecter
{
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:selecter];
    self.rightItem.tintColor = GRAY_COLOR;
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

- (void)addRightTitleWithView:(UIView *)view
{
    self.rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.rightItem;
}

- (void)removeRightItemIfExist
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (UIButton *)addBottomButton
{
    self.nextBtn = [[UIButton alloc] init];
    [self.view addSubview:self.nextBtn];
    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(TRUE_SIZE(38));
        make.right.equalTo(self.view.mas_right).offset(-TRUE_SIZE(38));
        make.top.equalTo(self.view.mas_top).offset(SCREEN_H*0.88-64);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TRUE_SIZE(62));
    }];
    [self.nextBtn addTarget:self action:@selector(pushToNextVC) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn.titleLabel.font = [UIFont systemFontOfSize:TRUE_FONT(19)];
    [self.nextBtn setTitle:@"下 一 步" forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"button_nor"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"button_press"] forState:UIControlStateHighlighted];
    [TCViewManger addShadowForView:self.nextBtn];
    
    return self.nextBtn;
}

- (UIButton *)addBottomButton:(UIView *)view
{
    UIButton *nextBtn = [[UIButton alloc] init];
    [view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(TRUE_SIZE(38));
        make.right.equalTo(view.mas_right).offset(-TRUE_SIZE(38));
        make.top.equalTo(view.mas_top).offset(SCREEN_H*0.88-64);
        make.bottom.equalTo(view.mas_bottom).offset(-TRUE_SIZE(62));
    }];
    [nextBtn addTarget:self action:@selector(pushToNextVC) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:TRUE_FONT(19)];
    [nextBtn setTitle:@"下 一 步" forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"button_nor"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"button_press"] forState:UIControlStateHighlighted];
    [TCViewManger addShadowForView:nextBtn];
    
    return nextBtn;
}

- (UIView *)addBackgroundView
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    [self.view addSubview:baseView];
    baseView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    return baseView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)pushToNextVC
{
    
}

- (void)changeRootVC:(UIViewController *)vc
{
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)endEditing
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)addNotification {
    
    /**
     增加监听，当键盘出现或改变时收到消息
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    /**
     增加监听，当键盘退出时收到消息
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark --
#pragma mark -- 键盘selector方法
- (void)keyboardWillShow:(NSNotification *)notifi {
    
    //获取键盘高度
    NSDictionary *userInfo = [notifi userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyboardHeight = keyboardRect.size.height;
    _spacingWithKeyboardAndCursor = keyboardHeight - _cursorHeight;
    
    if (_spacingWithKeyboardAndCursor > 0) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于键盘的显示
            self.view.frame = CGRectMake(0, -(_spacingWithKeyboardAndCursor), SCREEN_W, SCREEN_H);
//            self.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        }];
    }/*else {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于键盘的显示
//            self.view.frame = CGRectMake(0, -(_spacingWithKeyboardAndCursor), SCREEN_W, SCREEN_H);
            self.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        }];
    }*/
}

- (void)keyboardWillHide:(NSNotification *)notifi {
    
    if (_spacingWithKeyboardAndCursor > 0) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

#pragma mark --
#pragma mark -- textField代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    CGRect screenFrame = [[UIApplication sharedApplication].keyWindow convertRect:textField.frame fromView:self.view];
    _cursorHeight = SCREEN_H - CGRectGetMaxY(screenFrame) - 18;
    
    return YES;
}

#pragma mark - 系统库封装
- (void)addAlertControllerWithTitle:(NSString *)title message:(NSString *)message OKBlock:(void(^)(void))OKBlock cancelBlock:(void(^)(void))cancelBlock{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (OKBlock) {
            OKBlock();
        }
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addTextAlertControllerWithTitle:(NSString *)title message:(NSString *)message placeHolder:(NSString *)placeHolder OKBlock:(void(^)(UITextField *tf))OKBlock cancelBlock:(void(^)(void))cancelBlock{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (OKBlock) {
            OKBlock(alertController.textFields[0]);
        }
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.placeholder = placeHolder;
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addActionSheetWithTitleAry:(NSArray *)titleAry selectBlock:(void(^)(UIAlertAction *action,int index))selectBlock{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addTapGesture];
    for (int i = 0; i < titleAry.count; i++) {
        NSString *title = titleAry[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (selectBlock) {
                selectBlock(action,i);
            }
        }];
        [alertController addAction:action];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)selectPhoto{
    UIAlertController *alertController = [UIAlertController new];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self makeChoose:0];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self makeChoose:1];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:photoAction];
    [alertController addAction:albumAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)makeChoose:(int)index {
    
    UIImagePickerController *PickerController = [UIImagePickerController new];
    if (index == 0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            PickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else{
            NSLog(@"无法打开相机");
        }
    }
    else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            PickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
    }
    PickerController.delegate = self;
    PickerController.allowsEditing = YES;
    [self presentViewController:PickerController animated:YES completion:nil];
    
}

- (void)createDateView:(__strong UIView **)datePickerView AndPickview:(__strong UIDatePicker **)datepicker WithDatePickerMode:(UIDatePickerMode )model finishSEL:(SEL)sel{
    
    UIView *view = *datePickerView;
    UIDatePicker *picker = *datepicker;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H - 256, SCREEN_W, 256)];
    view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,30,0,0.0)];
    picker.center = CGPointMake(view.center.x, picker.center.y);
    picker.datePickerMode = model;
    [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    [view addSubview:picker];
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 25)];
    [quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quitBtn setTitle:@"取消" forState:UIControlStateNormal];
    [view addSubview:quitBtn];
    [quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - 50, 10, 45, 25)];
    [view addSubview:finishBtn];
    [finishBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    view.hidden = YES;
    *datePickerView = view;
    *datepicker = picker;
}
- (void)dateChanged:(UIDatePicker*)picker{}
- (void)dateBtnAction:(UIButton *)sender {
}

- (void)quit{
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
