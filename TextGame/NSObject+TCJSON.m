//
//  NSObject+TCJSON.m
//  封装方法
//
//  Created by William on 16/4/14.
//  Copyright © 2016年 William. All rights reserved.
//

#import "NSObject+TCJSON.h"
#import <objc/runtime.h>

@implementation NSObject (JSON)


#pragma mark - ----------内部实现----------
#pragma mark - 根据类型进行不同赋值
- (void)fromNumber:(Ivar)var dic:(NSDictionary *)keyedValues key:(NSString *)key
{
    if ([keyedValues[key] isKindOfClass:[NSNumber class]])
    {
        object_setIvar(self, var, keyedValues[key]);
    }
    else if ([keyedValues[key] isKindOfClass:[NSString class]])
    {
        NSString *value = keyedValues[key];
        if ([value rangeOfString:@"."].length>0)
        {
            object_setIvar(self, var, @([value doubleValue]));
        }
        else
        {
            object_setIvar(self, var, @([value intValue]));
        }
        
    }
    else
    {
        NSLog(@"%@类型不匹配",[NSString stringWithUTF8String:ivar_getName(var)]);
        return;
    }
}

//日后扩展
- (void)fromDictionary:(Ivar)var dic:(NSDictionary *)keyedValues key:(NSString *)key
{
    if (![keyedValues[key] isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"%@类型不匹配",[NSString stringWithUTF8String:ivar_getName(var)]);
        return;
    }
    object_setIvar(self, var, keyedValues[key]);
}

//类型为日期
- (void)fromDate:(Ivar)var dic:(NSDictionary *)keyedValues key:(NSString *)key
{
    if ([keyedValues[key] isKindOfClass:[NSDate class]])
    {
        object_setIvar(self, var,keyedValues[key]);
    }
    else if ([keyedValues[key] isKindOfClass:[NSString class]])
    {
        NSString *dateStr = keyedValues[key];
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:dateStr];
        object_setIvar(self, var,date);
    }
    else
    {
        NSLog(@"%@类型不匹配",[NSString stringWithUTF8String:ivar_getName(var)]);
        return;
    }
    
}

- (void)fromArray:(Ivar)var dic:(NSDictionary *)keyedValues key:(NSString *)key
{
    if ([keyedValues[key] isKindOfClass:[NSArray class]])
    {
        object_setIvar(self, var,keyedValues[key]);
    }
    else
    {
        NSLog(@"%@类型不匹配",[NSString stringWithUTF8String:ivar_getName(var)]);
        return;
    }

}

- (BOOL)checkTypeIsBasic:(NSString *)type
{
    /* i = int;
       f = float;
       d = double;
       q/Q = long long **
     */
    NSString *basicChar = @"ifdqQ";
    if ([basicChar rangeOfString:type].length>0)
    {
        return YES;
    }
    return NO;
}

- (id)jsonObjectWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"不是一个有效jSON,error=%@",err);
        return nil;
    }
    return jsonObject;
}

#pragma mark - ----------外部调用----------
static NSString *_KVDic;
- (void)setModelKeyToJsonKey:(NSDictionary *)KVDic
{
    objc_setAssociatedObject(self, &_KVDic, KVDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - 字典模型互转
//字典转模型
- (void)TCSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
{
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    if (!propertys){
        return;
    }
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = propertys[i];
        const char *propertyCName = property_getName(property);
        const char *propertyAttributes = property_getAttributes(property);
        NSString *type = [NSString stringWithUTF8String:propertyAttributes];
        NSString *propertyName = [NSString stringWithUTF8String:propertyCName];
        NSDictionary *modelToJsonDic = objc_getAssociatedObject(self, &_KVDic);
        id value;
        if (modelToJsonDic){
            NSArray *modelToJsonKeyAry = modelToJsonDic.allKeys;
            for (int i = 0; i < modelToJsonKeyAry.count; i++)
            {
                NSString *dicKey = modelToJsonKeyAry[i];
                if ([dicKey isEqualToString:propertyName]){
                    value = keyedValues[modelToJsonDic[dicKey]];
                }
                if (i == modelToJsonKeyAry.count - 1 && !value){
                    value = keyedValues[propertyName];
                }
            }
        }
        else{
            value = [keyedValues valueForKey:propertyName];
        }
        if (value && ![value isKindOfClass:[NSNull class]]){
            if ([type rangeOfString:@"NSString"].length>0) {
                NSString *stringValue = [NSString stringWithFormat:@"%@",value];
                [self setValue:stringValue forKey:propertyName];
            }
            else if ([type rangeOfString:@"NSDictionary"].length>0 && [value isKindOfClass:[NSString class]]) {
                NSDictionary *jsonObjcet = [self jsonObjectWithJsonString:value];
                if (!jsonObjcet) {
                    return;
                }
                NSDictionary *objectDic = jsonObjcet[propertyName];
                if (objectDic && [objectDic isKindOfClass:[NSDictionary class]]) {
                    [self setValue:objectDic forKey:propertyName];
                }
            }
            else if ([type rangeOfString:@"NSArray"].length>0 && [value isKindOfClass:[NSString class]]) {
                NSDictionary *jsonObjcet = [self jsonObjectWithJsonString:value];
                if (!jsonObjcet) {
                    return;
                }
                NSArray *objectAry = jsonObjcet[propertyName];
                if (objectAry && [objectAry isKindOfClass:[NSArray class]]) {
                    [self setValue:objectAry forKey:propertyName];
                }
            }
            else{
                [self setValue:value forKey:propertyName];
            }
        }else if ([type rangeOfString:@"NSString"].length>0 && ![self valueForKey:propertyName]){
            [self setValue:@"" forKey:propertyName];
        }
    }
    objc_removeAssociatedObjects(self);
    free(propertys);
}

//
//模型转字典
- (NSDictionary *)TCGetDictionaryFromValuesAndKeys
{
    NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    //我猜ivars是一连串的内存地址
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:nameStr];
        NSDictionary *dic = objc_getAssociatedObject(self, &_KVDic);
        for (NSString *str in dic.allKeys)
        {
            if ([nameStr isEqualToString:str])
            {
                nameStr = dic[str];
            }
        }
        if ([value isKindOfClass:[NSObject class]])
        {
            [modelDic setObject:value forKey:nameStr];
        }
        
    }
    free(propertys);
    return modelDic;
}

- (NSDictionary *)TCGetDictionaryFromValuesAndKeysAndNotChangeKey
{
    NSMutableDictionary *modelDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    //我猜ivars是一连串的内存地址
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *nameStr = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:nameStr];
        if ([value isKindOfClass:[NSObject class]])
        {
            if ([nameStr isEqualToString:@"model"]) {
                [modelDic setObject:[value TCGetDictionaryFromValuesAndKeysAndNotChangeKey] forKey:nameStr];
                continue;
            }
            [modelDic setObject:value forKey:nameStr];
        }
    }
    free(propertys);
    return modelDic;
}

- (BOOL)key:(NSString *)key existInClass:(Class)metaClass{
    unsigned int count = 0;
    BOOL exist = NO;
    Ivar *ivars = class_copyIvarList(metaClass, &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        if ([keyName rangeOfString:key].length>0) {
            exist = YES;
        }
    }
    return exist;
}

@end
