//
//  NetworkState.h
//  recruit
//
//  Created by 智齿 on 16/8/8.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkState : NSObject

+ (instancetype)shared;

@property (nonatomic,assign) bool haveNetworking;

@end
