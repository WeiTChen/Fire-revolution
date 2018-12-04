//
//  ZCUser.m
//  recruit
//
//  Created by william on 16/8/24.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "ZCUser.h"

@implementation ZCUser


+ (instancetype)sharedInstances
{
    static ZCUser *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [self alloc];
        [user setFilePath:@""];
    });
    return user;
}

- (void)setFilePath:(NSString *)filePath
{
    _filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"user.db"];
}

- (void)setId:(NSString *)id{
    _userId = id.length>0?id:_userId;
}

- (void)setUserId:(NSString *)userId{
    _userId = userId;
}

- (void)saveModelToLocalDataBase
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [self TCGetDictionaryFromValuesAndKeysAndNotChangeKey];
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:self.filePath])
        {
            [manager createFileAtPath:self.filePath contents:nil attributes:nil];
        }
        [dic writeToFile:self.filePath atomically:NO];
        NSData *data = [NSData dataWithContentsOfFile:self.filePath];
        NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [str writeToFile:[self.filePath stringByReplacingOccurrencesOfString:@".db" withString:@".plist"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
        [manager removeItemAtPath:self.filePath error:nil];
    });
}

- (void)getDataFormDataBase
{
    NSString *base64Str = [[NSString alloc] initWithContentsOfFile:[self.filePath stringByReplacingOccurrencesOfString:@".db" withString:@".plist"] encoding:NSUTF8StringEncoding error:nil];
    if (!base64Str) {
        return;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    [data writeToFile:self.filePath atomically:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    if (dic)
    {
        [self TCSetValuesForKeysWithDictionary:dic];
        //因为默认方法会遍历存储属性数据,会导致filePath路径出错,使用实例变量可以解决这个问题
        //但是因为选择用了懒加载,所以在这里手动置为nil然他重新获取
        self.filePath = nil;
    }
}

- (void)logout
{
    NSString *truePath = [self.filePath stringByReplacingOccurrencesOfString:@".db" withString:@".plist"];
    [[NSFileManager defaultManager] removeItemAtPath:truePath error:nil];
    [self resetSelf];
    NSLog(@"退出登录");
}

- (void)resetSelf{
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        [self setValue:nil forKey:nameStr];
    }
    free(propertys);
}

+ (void)restartLogin
{
    UIViewController *loginVC = [[NSClassFromString(@"LoginViewController") alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [nav.navigationBar addGestureRecognizer:tap];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
}


@end

