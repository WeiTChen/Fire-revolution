//
//  ZCUser.h
//  recruit
//
//  Created by william on 16/8/24.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCUser : NSObject

//鉴权字符串
@property (nonatomic,strong) NSString *token;

//用户ID
@property (nonatomic,strong) NSString *userId;

//id
@property (nonatomic,strong) NSString *id;

//手机
@property (nonatomic,strong) NSString *phone;

//用户名
@property (nonatomic,strong) NSString *username;

//头像URL
@property (nonatomic,strong) NSString *imageM;

//邮箱
@property (nonatomic,strong) NSString *email;

//user本地目录文件
@property (nonatomic,strong,readonly) NSString *filePath;

+ (instancetype)sharedInstances;

- (void)saveModelToLocalDataBase;

- (void)getDataFormDataBase;

- (void)logout;

//重置登录界面,无法左滑返回,重写根视图不会增加内存
+ (void)restartLogin;

@end
