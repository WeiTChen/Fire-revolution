//
//  UIBarButtonItem+stocking.m
//  recruit
//
//  Created by 智齿 on 16/10/14.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "UIBarButtonItem+stocking.h"
#import <objc/runtime.h>

static NSString *_select;

@implementation UIBarButtonItem (stocking)

- (void)setSelect:(NSNumber *)select {
    
    objc_setAssociatedObject(self, &_select, select, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)select {
    
    return objc_getAssociatedObject(self, &_select);
}

@end
