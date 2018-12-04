//
//  NSObject+TCJSON.h
//  封装方法
//
//  Created by William on 16/4/14.
//  Copyright © 2016年 William. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

/**
 *  字典转模型
 *
 *  @param keyedValues 字典
 */
- (void)TCSetValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues;

/**
 *  模型转字典
 *
 *  @return 字典
 */
- (NSDictionary *)TCGetDictionaryFromValuesAndKeys;

//将模型的key转换为接收json的key
- (void)setModelKeyToJsonKey:(NSDictionary *)KVDic;

//在不改变key的情况下,获取字典
- (NSDictionary *)TCGetDictionaryFromValuesAndKeysAndNotChangeKey;

- (BOOL)key:(NSString *)key existInClass:(Class )metaClass;

@end
