//
//  ZCCache.m
//  recruit
//
//  Created by william on 2016/12/26.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "ZCCache.h"

@implementation ZCCache

+ (instancetype)SharedCache{
    
    static ZCCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] init];
    });
    return cache;
}


- (NSDateFormatter *)formater{
    if (!_formater) {
        _formater = [[NSDateFormatter alloc] init];
        [_formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    return _formater;
}

- (NSDateFormatter *)displayFormatter{
    if (!_displayFormatter) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy年MM月dd日"];
        _displayFormatter = formater;
    }
    return _displayFormatter;
}

- (BOOL)setObject:(id)object ForKey:(NSString *)key activeTime:(NSTimeInterval)activeTime{
    if (object && key && ![key isEqualToString:@""]) {
        [self setObject:object forKey:key];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(activeTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeObjectForKey:key];
        });
        return YES;
    }
    return NO;
}

@end
