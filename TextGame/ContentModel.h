//
//  ContentModel.h
//  TextGame
//
//  Created by william on 2018/1/16.
//  Copyright © 2018年 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContentModel : NSObject

//文字
@property (nonatomic,strong) NSString *text;

//颜色
@property (nonatomic,strong) UIColor *color;

//按钮或者文字
@property (nonatomic,strong) NSArray *textAry;

@property (nonatomic,strong) NSArray *selAry;

//selectIndex
@property (nonatomic,strong) NSString *selectIndex;

@end
