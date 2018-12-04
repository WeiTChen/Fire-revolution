//
//  ZCVCState.m
//  recruit
//
//  Created by william on 16/9/28.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "ZCVCState.h"

@implementation ZCVCState
+ (instancetype)shared
{
    static ZCVCState *state;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        state = [self alloc];
    });
    return state;
}

- (void)getDeviceBasePixel{
    struct utsname systemInfo;
    uname(&systemInfo);
    float pixel = 2;
    NSString * deviceString = [[[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""];;
    if ([deviceString isEqualToString:@"72"] || [deviceString isEqualToString:@"81"]) {
        pixel = 1.0f;
    }else if ([deviceString isEqualToString:@"71"] || [deviceString isEqualToString:@"82"] || [deviceString isEqualToString:@"92"]){
        pixel = 2208/1334.0f;
    }else{
        pixel = 1136/1334.0f;
    }
    self.pixel = [NSNumber numberWithFloat:pixel];
}

@end
