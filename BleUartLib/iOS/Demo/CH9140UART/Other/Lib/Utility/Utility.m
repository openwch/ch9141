//
//  Utility.m
//  children
//
//  Created by 娟华 胡 on 15/5/6.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "Utility.h"
#import "MyBase64.h"
#import <CommonCrypto/CommonCryptor.h>

const Byte iv[] = {1,2,3,4,5,6,7,8};

@implementation Utility

#pragma mark 解密
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key{
    
    NSString *plaintext = nil;
    NSData *cipherdata = [MyBase64 decode:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;

    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}


#pragma mark 加密
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key{
    
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [MyBase64 encode:data];
    }
    return ciphertext;
}

@end
