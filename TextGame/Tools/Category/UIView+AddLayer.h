//
//  UIView+AddLayer.h
//  recruit
//
//  Created by william on 16/8/17.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AddLayer)

//默认黑色边线,宽度为1
- (void)addDefaultLayer;

- (void)addLayerWidth:(NSUInteger )width color:(UIColor *)color;

@end
