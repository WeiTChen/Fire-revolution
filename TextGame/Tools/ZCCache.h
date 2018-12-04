//
//  ZCCache.h
//  recruit
//
//  Created by william on 2016/12/26.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCCache : NSCache

+ (instancetype)SharedCache;

- (BOOL)setObject:(id)object ForKey:(NSString *)key activeTime:(NSTimeInterval )activeTime;

@property (nonatomic,strong) NSDateFormatter *formater;

//日期格式
@property (nonatomic,strong) NSDateFormatter *displayFormatter;

@end
