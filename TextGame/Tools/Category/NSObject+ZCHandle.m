//
//  NSObject+ZCHandle.m
//  recruit
//
//  Created by 智齿 on 16/11/8.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/NSObject.h>

@implementation NSObject (ZCHandle)

//- (void)setValue:(id)value forKey:(NSString *)key {
//    
//    if ([value isKindOfClass:[NSNull class]]) {
//        [self setNilValueForKey:key];
//        return;
//    }
//    if ([value isKindOfClass:[NSString class]]) {
//        // 判断是否为空串
//        [self removeNullString:key value:value];
//    }
//}
//
//- (void)removeNullString:(NSString *)key value:(NSString *)value{
//    unsigned int count = 0;
//    objc_property_t *propertys = class_copyPropertyList([self class], &count);
//    if (!propertys){
//        return;
//    }
//    for (int i = 0; i < count; i++)
//    {
//        objc_property_t property = propertys[i];
//        const char *propertyName = property_getName(property);
//        NSString *key = [NSString stringWithUTF8String:propertyName];
//        const char *propertyAttributes = property_getAttributes(property);
//        NSString *type = [NSString stringWithUTF8String:propertyAttributes];
//        
//    }
//}

@end
