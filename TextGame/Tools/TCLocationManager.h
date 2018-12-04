//
//  TCLocationManager.h
//  定位与编码
//
//  Created by william on 2016/11/2.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCLocationManager : NSObject

- (void)location;

//成功回调(默认在子线程中完成)
@property (nonatomic,copy) void(^locationSuccess)(NSDictionary *addressDic);

@end
