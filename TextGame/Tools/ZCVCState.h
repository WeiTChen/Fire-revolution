//
//  ZCVCState.h
//  recruit
//
//  Created by william on 16/9/28.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCVCState : NSObject
+ (instancetype)shared;

@property (nonatomic,strong) NSString *joinInterviewRoom;

//是否有未读推送消息
@property (nonatomic,strong) NSNumber *havaNewMessage;

//像素状态
@property (nonatomic,strong) NSNumber *pixel;

- (void)getDeviceBasePixel;

@end
