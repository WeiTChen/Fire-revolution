//
//  TCStringManage.m
//  封装方法
//
//  Created by William on 16/4/13.
//  Copyright © 2016年 William. All rights reserved.
//

#import "TCStringManage.h"

@implementation TCStringManage

struct stringType
{
    bool isContains;
    char *str;
};

+ (NSString *)TCCreatJSONFromDictionaryRepeatParametersKey:(NSString *)key Value:(NSDictionary *)repeatdValue AndIndividualParameters:(NSDictionary *)individualDic
{
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    if (key && repeatdValue)
    {
        NSArray *keyArray = repeatdValue.allKeys;
        NSArray *valueArray = repeatdValue.allValues;
        NSMutableArray *jsonAry = [NSMutableArray array];
        for (int j = 0 ; j<[valueArray.firstObject count]; j++)
        {
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            for (int i = 0; i<keyArray.count; i++)
            {
                NSArray *valueAry = valueArray[i];
                [dataDic setValue:valueAry[j] forKey:keyArray[i]];
            }
            [jsonAry addObject:dataDic];
        }
        [jsonDic setObject:jsonAry forKey:key];
    }
    if (individualDic) {
        [jsonDic setValuesForKeysWithDictionary:individualDic];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    return jsonString;
}

+ (bool)isContainsEmoji:(NSString *)string {
 
    NSString *str = [self replaceEmoji:string];
    if ([string isEqualToString:str])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)removeEmoji:(NSString *)string
{
    return [self replaceEmoji:string];
}

+ (NSString *)replaceEmoji:(NSString *)string
{
    
    __block BOOL isEomji = NO;
    __block NSString *str = [string mutableCopy];
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     NSLog(@"1.%@",substring);
                     str = [str stringByReplacingOccurrencesOfString:substring withString:@""];
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 str = [str stringByReplacingOccurrencesOfString:substring withString:@""];
                 NSLog(@"2.%@",substring);
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 str = [str stringByReplacingOccurrencesOfString:substring withString:@""];
                 NSLog(@"3.%@",substring);
                 isEomji = YES;
             }
         }
     }];
    NSLog(@"最后替换完成的结果为%@",str);

    return str;
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,157,158,159,178,182,183,184,187,188
     * 联通：130,131,132,145,152,155,156,176,185,186
     * 电信：133,1349,153,177,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|47|5[0-9]|7[78]|8[0-9])\\d{8}$";
    /**
     10 * 中国移动：China Mobile
     11 * 134[0-8],135,136,137,138,139,147,150,151,157,158,159,178,182,183,184,187,188
     12 */
    NSString * CM = @"^1(34[0-8]|(3[0-9]|45|5[0-9]|76|8[0-9])\\d)\\d{7}$";
    /**
     15 * 中国联通：China Unicom
     16 * 130,131,132,145,152,155,156,176,185,186
     17 */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20 * 中国电信：China Telecom
     21 * 133,1349,153,177,180,181,189
     22 */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
    /**
     25 * 大陆地区固话及小灵通
     26 * 区号：010,020,021,022,023,024,025,027,028,029
     27 * 号码：七位或八位
     28 */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (CGSize)getSizeFromString:(NSString *)string font:(UIFont *)font
{
    return [string sizeWithAttributes:@{NSFontAttributeName:font}];
}

+ (CGSize)getSizeFromString:(NSString *)string font:(UIFont *)font MaxSize:(CGSize)MaxSize
{
    return [string boundingRectWithSize:MaxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
}

+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    //uppercaseString
    return pinyin;
}

@end
