//
//  RootViewController.h
//  recruit
//
//  Created by 智齿 on 16/8/9.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIBarButtonItem *leftItem; //default is add

@property (nonatomic,strong) UIBarButtonItem *rightItem; //default is nil

@property (nonatomic,assign) float cursorHeight;//光标距底部的高度

@property (nonatomic,assign) float spacingWithKeyboardAndCursor; //光标与键盘之间的距离

//底部按钮
@property (nonatomic,strong) UIButton *nextBtn;

//uitableview
@property (nonatomic,strong) UITableView *tableView;

- (void)addCancelLeft;

- (void)hideBackButton;

- (void)back;

- (void)rightClick;

- (void)setupNavTitleText:(NSString *)text;

- (void)setupTabbarNavTitleText:(NSString *)text;

- (void)setupNavtitleView:(UIView *)view;

- (void)addRightTitleWithImage:(UIImage *)image target:(id)target selector:(SEL)selecter;

- (void)addRightTitleWithTitle:(NSString *)title target:(id)target selector:(SEL)selecter;

//添加右侧自定义视图
- (void)addRightTitleWithView:(UIView *)view;

//移除右侧barButtonItem
- (void)removeRightItemIfExist;

- (UIButton *)addBottomButton;

- (UIButton *)addBottomButton:(UIView *)view;

- (UIView *)addBackgroundView;

- (void)pushToNextVC;

- (void)changeRootVC:(UIViewController *)vc;

- (void)addNotification;

- (void)keyboardWillShow:(NSNotification *)notifi;
- (void)keyboardWillHide:(NSNotification *)notifi;

- (void)addTextAlertControllerWithTitle:(NSString *)title message:(NSString *)message placeHolder:(NSString *)placeHolder OKBlock:(void(^)(UITextField *tf))OKBlock cancelBlock:(void(^)(void))cancelBlock;
- (void)addAlertControllerWithTitle:(NSString *)title message:(NSString *)message OKBlock:(void(^)(void))OKBlock cancelBlock:(void(^)(void))cancelBlock;
- (void)addActionSheetWithTitleAry:(NSArray *)titleAry selectBlock:(void(^)(UIAlertAction *action,int index))selectBlock;

- (void)selectPhoto;
- (void)createDateView:(__strong UIView **)datePickerView AndPickview:(__strong UIDatePicker **)datepicker WithDatePickerMode:(UIDatePickerMode )model finishSEL:(SEL)sel;

@end
