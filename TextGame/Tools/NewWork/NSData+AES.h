//
//  NSData+AES.h
//  recruit
//
//  Created by 智齿 on 16/8/8.
//  Copyright © 2016年 智齿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NSData (AES)
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSString *)base64Encoding;
+ (id)dataWithBase64EncodedString:(NSString *)string;
@end

