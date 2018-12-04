//
//  BaseJsonModel.h
//  recruit
//
//  Created by 智齿 on 16/8/11.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseJsonModel : NSObject

@property (nonatomic,strong) NSString *code;

@property (nonatomic,strong) NSString *message;

@property (nonatomic,strong) id dataDic;

//请求时间戳
@property (nonatomic,strong) NSString *requestTime;

@end
