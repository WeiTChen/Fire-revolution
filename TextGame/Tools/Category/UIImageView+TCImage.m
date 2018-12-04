//
//  UIImageView+TCImage.m
//  封装方法
//
//  Created by William on 16/4/15.
//  Copyright © 2016年 William. All rights reserved.
//

#import "UIImageView+TCImage.h"
#import "TCImageManage.h"

static NSString *_exp;

@implementation UIImageView (TCImage)

- (void)setImageWithURL:(NSString *)urlStr placeholder:(UIImage *)placeholder ellipse:(BOOL)ellipse
{
    TCImageManage *TCManage = [TCImageManage sharedInstance];
    return [TCManage imageView:self setImageWithURL:urlStr placeholder:placeholder ellipse:(BOOL)ellipse];
}

- (void)setImageWithURL:(NSString *)urlStr placeholder:(UIImage *)placeholder ellipse:(BOOL)ellipse success:(void (^)(UIImage *))success{
    TCImageManage *TCManage = [TCImageManage sharedInstance];
    return [TCManage imageView:self setImageWithURL:urlStr placeholder:placeholder ellipse:(BOOL)ellipse];
}

- (void)setExp:(id)exp
{
    
    objc_setAssociatedObject(self, &_exp, exp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)exp
{
    return objc_getAssociatedObject(self, &_exp);
}

@end
