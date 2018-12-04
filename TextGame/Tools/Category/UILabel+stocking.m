//
//  UILabel+stocking.m
//  recruit
//
//  Created by 智齿 on 16/8/17.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "UILabel+stocking.h"

@implementation UILabel (stocking)

+(UILabel*)createWithTitle:(NSString*)title Frame:(CGRect)frame{
    //CGSize fontSize = [title sizeWithFont:kDefaultFont constrainedToSize:frame.size];
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.backgroundColor = [UIColor clearColor];
    l.text = title;
    l.numberOfLines = 0;
    return l;
}

@end
