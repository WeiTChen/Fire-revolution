//
//  UIAlertController+TCExpand.m
//  recruit
//
//  Created by william on 2016/12/5.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import "UIAlertController+TCExpand.h"
#import "TCActionSheetBackgroundView.h"

@implementation UIAlertController (TCExpand)

- (void)addTapGesture{
    TCActionSheetBackgroundView *view = [[TCActionSheetBackgroundView alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [view class];
    });
}


@end
