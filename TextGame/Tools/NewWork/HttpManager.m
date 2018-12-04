//
//  HttpManage.m
//  recruit
//
//  Created by 智齿 on 16/8/8.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "HttpManager.h"
#import "NSData+AES.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "NetworkState.h"

//正式环境中所有的请求需要加密处理
static NSString *AESKey = @"OIi7r85RbO0PBCKH";
static NSString *AESIv = @"H8EBGHcmZND02eP6";//must be 16 or 16*i length

@interface HttpManager ()<NSURLSessionDelegate>
@end

@implementation HttpManager
//登录
+ (void)login:(NSString *)phone password:(NSString *)password success:(void(^)(void))success failure:(void(^)(id error))failure;
{
    [self postURLString:[NSString stringWithFormat:@"%@login/verifyLogin",SOU_MAO_URL] WithParameter:@{@"phone":phone,@"password":password} success:^(NSDictionary *jsonDic) {
        ZCUser *user = [ZCUser sharedInstances];
        [user TCSetValuesForKeysWithDictionary:jsonDic];
        [user saveModelToLocalDataBase];
        
    } failure:failure];
}

+ (void)getVcodeToPhone:(NSString *)phoneNumber success:(void (^)(void))success failure:(void (^)(id))failure{
    [self postURLString:[NSString stringWithFormat:@"%@login/sendcapture",SOU_MAO_URL] WithParameter:@{@"userParam":phoneNumber} success:^(NSDictionary *jsonDic) {
        if (success)
        {
            success();
        }
        
    } failure:failure];
}

+ (void)checkVcodeWithCode:(NSString *)code phone:(NSString *)phone success:(void (^)(void))success failure:(void (^)(id))failure{
    [self postURLString:[NSString stringWithFormat:@"%@login/Verifycapture",SOU_MAO_URL] WithParameter:@{@"userParam":phone,@"capture":code} success:^(NSDictionary *jsonDic) {
        if (success)
        {
            success();
        }
        
    } failure:failure];
}

+ (void)resetPwdWithPwd:(NSString *)pwd phone:(NSString *)phone success:(void (^)(void))success failure:(void (^)(id))failure{
    [self postURLString:[NSString stringWithFormat:@"%@login/password",SOU_MAO_URL] WithParameter:@{@"confirmPwd":pwd,@"contact":phone} success:^(NSDictionary *jsonDic) {
        if (success)
        {
            success();
        }
        
    } failure:failure];
}


#pragma mark -------------------以下为类中自身实现--------------------
#pragma mark - 请求基类
//几乎所有请求都会走这个方法发送
+ (void)postURLString:(NSString *)urlString WithParameter:(NSDictionary *)dic success:(void(^)(id jsonDic))success failure:(void(^)(id error))failure;
{
//    [ProgressHUDManager showHUDText:@"加载中" animated:YES];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUDManager showHUDImageAnimated:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //默认为post请求
    request.HTTPMethod = @"post";
    if (!([urlString rangeOfString:@"login/verifyLogin"].length>0)) {
        if ([ZCUser sharedInstances].userId) {
            [request setValue:[NSString stringWithFormat:@"%@_%@",[ZCUser sharedInstances].userId,[ZCUser sharedInstances].token]  forHTTPHeaderField:@"authorization"];
        }
    }
    NSMutableDictionary *appendDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    request.HTTPBody = [self creatJsonStringFormDic:appendDic];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:(id<NSURLSessionDelegate> _Nullable)self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if ([self checkResponseHaveError:(NSHTTPURLResponse*)response error:error failure:failure]) {
                return;
            }
            NSDictionary *jsonDic;
#if !DEVELOPER
            jsonDic = [self decodeDicFromAESData:data];
#else
            NSError *err = nil;
            jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
#endif
            if (!jsonDic){
                [ProgressHUDManager removeHudView];
                NSLog(@"不是一个有效的json串");
                return;
            }
            BaseJsonModel *baseModel = [[BaseJsonModel alloc] init];
            [baseModel setModelKeyToJsonKey:@{@"dataDic":@"data"}];
            [baseModel  TCSetValuesForKeysWithDictionary:jsonDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![[NSString stringWithFormat:@"%@",baseModel.code] isEqualToString:@"0"]){
                [ProgressHUDManager removeHudView];
//                [ProgressHUDManager showHUDOnlyText:baseModel.message animated:YES displayTime:1.5];
                NSLog(@"请求失败,错误提示:%@,第%d行,%@",baseModel.message,__LINE__,urlString);
                [self enumCodeToDoSomething:[NSString stringWithFormat:@"%@",baseModel.code]];
                if (failure){
                    failure(baseModel.message);
                }
                return;
            }/*else if (baseModel.dataDic[@"msg"]){
                if (![[self getErrDic] valueForKey:baseModel.dataDic[@"msg"]]) {
                    [ProgressHUDManager removeHudView];
                    [ProgressHUDManager showHUDOnlyText:baseModel.dataDic[@"msg"] animated:YES displayTime:1.5];
                    NSLog(@"请求失败,错误提示:%@,第%d行,%@",baseModel.dataDic[@"msg"],__LINE__,urlString);
                    [self enumCodeToDoSomething:[NSString stringWithFormat:@"%@",baseModel.code]];
                    if (failure){
                        failure(baseModel.dataDic[@"msg"]);
                    }
                    return;
                }
            }*/
            else if (success){
                [ProgressHUDManager removeHudView];
                if ([baseModel.message length]>0) {
                    [ProgressHUDManager showHUDOnlyText:baseModel.message animated:YES displayTime:1.5];
                }
                if (baseModel.dataDic && ![baseModel.dataDic isKindOfClass:[NSNull class]]){
                    success(baseModel.dataDic);
                }
                else{
                    success(@{});
                }
            }
        });
    }];
    [dataTask resume];
}

//几乎所有请求都会走这个方法发送
+ (void)getURLString:(NSString *)urlString success:(void(^)(id jsonDic))success failure:(void(^)(id error))failure;
{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [ProgressHUDManager showHUDText:@"加载中" animated:YES];
    [ProgressHUDManager showHUDImageAnimated:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //默认为post请求
    request.HTTPMethod = @"get";
    [request setValue:[NSString stringWithFormat:@"%@_%@",[ZCUser sharedInstances].userId,[ZCUser sharedInstances].token]  forHTTPHeaderField:@"authorization"];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:(id<NSURLSessionDelegate> _Nullable)self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self checkResponseHaveError:(NSHTTPURLResponse*)response error:error failure:failure]) {
            return;
        }
        NSDictionary *jsonDic;
#if !DEVELOPER
        jsonDic = [self decodeDicFromAESData:data];
#else
        NSError *err = nil;
        jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
#endif
        if (!jsonDic){
            [ProgressHUDManager removeHudView];
            NSLog(@"不是一个有效的json串");
            return;
        }
        BaseJsonModel *baseModel = [[BaseJsonModel alloc] init];
        [baseModel setModelKeyToJsonKey:@{@"dataDic":@"data"}];
        [baseModel  TCSetValuesForKeysWithDictionary:jsonDic];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![[NSString stringWithFormat:@"%@",baseModel.code] isEqualToString:@"0"]){
                [ProgressHUDManager removeHudView];
                [ProgressHUDManager showHUDOnlyText:baseModel.message animated:YES displayTime:1.5];
                NSLog(@"请求失败,错误提示:%@,第%d行,%@",baseModel.message,__LINE__,urlString);
                [self enumCodeToDoSomething:[NSString stringWithFormat:@"%@",baseModel.code]];
                if (failure){
                    failure(baseModel.message);
                }
                return;
            }
            else if (success){
                [ProgressHUDManager removeHudView];
                if (baseModel.dataDic && ![baseModel.dataDic isKindOfClass:[NSNull class]]){
                    success(baseModel.dataDic);
                }
                else{
                    success(@{});
                }
            }
        });
    }];
    [dataTask resume];
}

//创建格式化的json,如果是正式坏境,会进行加密处理
+ (NSData *)creatJsonStringFormDic:(NSDictionary *)dic
{
    if (!dic || dic.count == 0)
    {
        return nil;
    }
    NSArray *keyAry = dic.allKeys;
    NSArray *valueAry = dic.allValues;
    NSMutableString *dataString = [NSMutableString string];
    for (int i = 0; i < keyAry.count; i++)
    {
        [dataString appendFormat:@"&%@=%@",keyAry[i],valueAry[i]];
    }
    NSString *appendString = [[dataString substringFromIndex:1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    appendString = [appendString stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSData *jsonData;
    jsonData = [appendString dataUsingEncoding:NSUTF8StringEncoding];
    
#if !DEVELOPER
    jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    if (!jsonData)
    {
        NSLog(@"json创建失败");
        return nil;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonStr = [self encodeJSONString:jsonStr];
    return [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
#else
    return jsonData;
#endif
}

#pragma mark - https证书设置
//NSURLAuthenticationChallenge 中的protectionSpace对象存放了服务器返回的证书信息
//如何处理证书?(使用、忽略、拒绝。。)
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler//通过调用block，来告诉NSURLSession要不要收到这个证书
{
    //(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
    //NSURLSessionAuthChallengeDisposition （枚举）如何处理这个证书
    //NSURLCredential 授权
    //证书分为好几种：服务器信任的证书、输入密码的证书  。。，所以这里最好判断
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){//服务器信任证书
        
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];//服务器信任证书
        if(completionHandler)
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }
    NSLog(@"completionHandler---:%@",challenge.protectionSpace.authenticationMethod);
}

#pragma mark - AES加密后再进行Base64编码
+ (NSString *)encodeJSONString:(NSString *)string
{
    NSData *encodeData =  [[string dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptWithKey:AESKey iv:AESIv];
    NSString *base64Str = [encodeData base64Encoding];
    NSLog(@"encode data:%@",base64Str);// print base64 code
    
    return base64Str;
}

+ (NSDictionary *)decodeDicFromAESData:(NSData *)data
{
    NSError *err = nil;
    NSData *AESData = [NSData dataWithBase64EncodedString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    NSData *baseData = [AESData AES128DecryptWithKey:AESKey iv:AESIv];
    NSString *jsonStr = [[NSString stringWithFormat:@"%@",[[NSString alloc] initWithData:baseData encoding:NSUTF8StringEncoding]] stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&err];
    return jsonDic;
}

//枚举错误码单独提出为以后拓展做准备
+ (void)enumCodeToDoSomething:(NSString *)code
{
    ErrorCode returnCode = [code intValue];
    
    if (returnCode == NeedUserAuth)
    {
        [ZCUser restartLogin];
        NSLog(@"需要用户重新登录");
    }
}



+ (BOOL)checkResponseHaveError:(NSHTTPURLResponse *)response error:(NSError *)error failure:(void(^)(id error))failure{
    if (error)
    {
        [ProgressHUDManager removeHudView];
        [ProgressHUDManager showHUDOnlyText:@"网络请求超时" animated:YES displayTime:1.5];
        if (failure)
        {
            failure(error);
        }
        NSLog(@"网络错误%@",error);
        return YES;
    }
    if (response.statusCode != 200) {
        [ProgressHUDManager removeHudView];
        if (failure)
        {
            failure(error);
        }
        NSLog(@"服务器连接错误%@",error);
        return YES;
    }
    return NO;
}

+ (void)setDic:(NSMutableDictionary **)a key:(NSString *)key value:(NSString *)value{
    NSMutableDictionary *dic = *a;
    [dic setValue:value forKey:key];
}

#pragma mark - 监测网络状态
+ (void)checkNetWorking
{
    [NetworkState shared].haveNetworking = YES;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                [NetworkState shared].haveNetworking = NO;
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [NetworkState shared].haveNetworking = NO;
                NSLog(@"无法连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [NetworkState shared].haveNetworking = YES;
                NSLog(@"无线网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [NetworkState shared].haveNetworking = YES;
                NSLog(@"WiFi网络");
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (NSDictionary *)getErrDic{
    return @{@"修改密码成功":@"1"};
}

@end
