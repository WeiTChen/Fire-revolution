//
//  UIColor+ZCHexColor.m
//  recruit
//
//  Created by william on 16/8/23.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "UIColor+ZCHexColor.h"

@implementation UIColor (ZCHexColor)
+ (UIColor *)HexColor:(int)hex
{
    NSString *hexColor = [NSString stringWithFormat:@"%x",hex];
    long R = strtoul([[hexColor substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
    long G = strtoul([[hexColor substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
    long B = strtoul([[hexColor substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}
@end
