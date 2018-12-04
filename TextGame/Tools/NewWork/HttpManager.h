//
//  HttpManage.h
//  recruit
//
//  Created by 智齿 on 16/8/8.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    NotStart = 1,
    Starting = 2,
    End = 3,
} InterviewState;

typedef enum : NSUInteger {
    Pending = 1,    //待接受
    Accept = 2,     //已接受
    Refuse = 3      //已拒绝
} JobMessageState;

typedef enum : NSUInteger {
    
    Success = 0,//成功
    ParameterError = 1000,//参数错误
    CodeError = 1001,//验证码错误
    CreateUserfailure = 1002,//创建用户失败
    UpdateDatafailure = 1003,//更新资料失败
    Scancodefailure = 1004,//扫码验证码失败
    NeedUserAuth = 1005,//需要auth鉴权
    GetTokenfailure = 1006,//获取Token失败
} ErrorCode;

@interface HttpManager : NSObject

@property (nonatomic,assign) bool haveNetwork;

+ (void)checkNetWorking;

//登录
+ (void)login:(NSString *)phone password:(NSString *)password success:(void(^)(void))success failure:(void(^)(id error))failure;

//获取验证码
+ (void)getVcodeToPhone:(NSString *)phoneNumber success:(void(^)(void))success failure:(void(^)(id error))failure;

//验证验证码
+ (void)checkVcodeWithCode:(NSString *)code phone:(NSString *)phone success:(void(^)(void))success failure:(void(^)(id error))failure;

//重置密码
+ (void)resetPwdWithPwd:(NSString *)pwd phone:(NSString *)phone success:(void(^)(void))success failure:(void(^)(id error))failure;

+ (NSDictionary *)getErrDic;

@end
