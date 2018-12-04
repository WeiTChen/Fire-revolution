//
//  UIView+AddLayer.m
//  recruit
//
//  Created by william on 16/8/17.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "UIView+AddLayer.h"

@implementation UIView (AddLayer)

- (void)addDefaultLayer
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)addLayerWidth:(NSUInteger)width color:(UIColor *)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

@end
