//
//  Define.h
//  recruit
//
//  Created by william on 16/8/31.
//  Copyright © 2016年 智齿. All rights reserved.
//

#ifndef Define_h
#define Define_h

#define DEVELOPER 01



#define SOU_MAO_ROOT_URL @"http:192.168.21.102:5000/"
#define SOU_MAO_URL @"http:192.168.21.102:5000/app/"

#define Get375Height(h)  (h) * SCREEN_W / 375
#define Get375Width(w)   (w) * SCREEN_W / 375

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define BASE_SCREEN_HEIGHT (1334.0/[UIScreen mainScreen].bounds.size.height)

#define TRUE_SIZE(size) (size) * [[ZCVCState shared].pixel floatValue]/[[UIScreen mainScreen] scale]

#define TRUE_FONT(font) font*([UIScreen mainScreen].bounds.size.height*2)/1334
//字体
#define BIG_BUTTON_FONT [UIFont systemFontOfSize:TRUE_FONT(19)]//用于较大按钮
#define NAV_FONT [UIFont systemFontOfSize:TRUE_FONT(17)]//用于Nav标题
#define DEFAULT_FONT [UIFont systemFontOfSize:TRUE_FONT(15)]//用于普通按钮,普通说明标题
#define PLACEHOLDER_FONT [UIFont systemFontOfSize:TRUE_FONT(14)]//用于placeholder
#define PAY_FONT [UIFont systemFontOfSize:TRUE_FONT(13)]//用于薪资
#define TEXT_FONT [UIFont systemFontOfSize:TRUE_FONT(12)]//用于普通text
#define SMALL_FONT [UIFont systemFontOfSize:TRUE_FONT(10)]//用于最小text
#define test_FONT [UIFont systemFontOfSize:TRUE_FONT(6)]//用于最小text

//颜色
#define BLUE_COLOR [UIColor HexColor:0x408ed6] //普通蓝色

#define GRAY_COLOR RGB_COLOR(211, 220, 232) //普通灰色

#define BLACK_COLOR [UIColor HexColor:0x7a8a99] //普通黑色

#define RGB_COLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#define RGB_COLOR_ALPHA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define DEFAULT_COLOR RGB_COLOR(244, 244, 244)
#define DEFAULT_BACKGROUNDCOLOR RGB_COLOR(241, 244, 255)

#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"icon_info_placeholder"]

//keyboard动画时间
#define kAnimationDuration 1.0f

/**
 判断string是否为空 nil 或者 @"" 或者 (null)；
 */
#define kisNilString(__String) (__String==nil || __String == (id)[NSNull null] || ![__String isKindOfClass:[NSString class]] || [__String isEqualToString:@""] || [[__String stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])


#endif /* Define_h */
