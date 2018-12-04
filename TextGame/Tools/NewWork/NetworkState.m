//
//  NetworkState.m
//  recruit
//
//  Created by 智齿 on 16/8/8.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "NetworkState.h"

@implementation NetworkState

+ (instancetype)shared
{
    static NetworkState *state;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        state = [self alloc];
    });
    return state;
}

@end
