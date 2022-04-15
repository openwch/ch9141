//
//  ByteUtils.m
//  枪神王座配置工具
//
//  Created by wcl on 2019/1/9.
//  Copyright © 2019年 wcl. All rights reserved.
//

#import "ByteUtils.h"

@implementation ByteUtils

#pragma mark 将short转成byte[2]
+(Byte*)short2Byte:(short)value{
    Byte* byteBuf=alloca(2);
    byteBuf[0] = (Byte) ((value >> 8) & 0xFF);
    byteBuf[1] = (Byte) (value & 0xFF);
    return byteBuf;
}


#pragma mark 将byte[2]转换成short
+(short) byte2Short:(Byte *)byteBuf{
    return (short) (((byteBuf[0] & 0xff) << 8) | (byteBuf[1] & 0xff));
}

#pragma mark byte数组转int
+(NSInteger) byte2Int:(Byte*)b{
    return ((b[0] & 0xff) << 24) | ((b[1] & 0xff) << 16) | ((b[2] & 0xff) << 8) | (b[3] & 0xff);
}


#pragma mark int转byte数组
+(Byte*)int2Byte:(NSInteger)value{
    Byte* byteBuf = alloca(4);
    byteBuf[0] = (Byte) (value >> 24);
    byteBuf[1] = (Byte) (value >> 16);
    byteBuf[2] = (Byte) (value >> 8);
    byteBuf[3] = (Byte) (value);
    return byteBuf;
}

#pragma mark 以大端模式将int转成byte[]
+(Byte*)intToBytesBig:(NSInteger)value {
    Byte* byteBuf = alloca(4);
    byteBuf[0] = (Byte) ((value >> 24) & 0xFF);
    byteBuf[1] = (Byte) ((value >> 16) & 0xFF);
    byteBuf[2] = (Byte) ((value >> 8) & 0xFF);
    byteBuf[3] = (Byte) (value & 0xFF);
    return byteBuf;
}

#pragma mark 以小端模式将int转成byte[]
+(Byte*)intToBytesLittle:(NSInteger)value {
    Byte * byteBuf = alloca(4);
    byteBuf[3] = (Byte) ((value >> 24) & 0xFF);
    byteBuf[2] = (Byte) ((value >> 16) & 0xFF);
    byteBuf[1] = (Byte) ((value >> 8) & 0xFF);
    byteBuf[0] = (Byte) (value & 0xFF);
    return byteBuf;
}

#pragma mark 以小端模式将byte[]转成int
+(NSInteger) bytesToIntLittle:(Byte*)src offset:(int) offset {
    int value;
    value = (int) ((src[offset] & 0xFF)
            | ((src[offset + 1] & 0xFF) << 8)
            | ((src[offset + 2] & 0xFF) << 16)
            | ((src[offset + 3] & 0xFF) << 24));
    return value;
}

#pragma mark 以大端模式将byte[]转成int
-(NSInteger) bytesToIntBig:(Byte*)src offset:(int) offset {
    int value;
    value = (int) (((src[offset] & 0xFF) << 24)
            | ((src[offset + 1] & 0xFF) << 16)
            | ((src[offset + 2] & 0xFF) << 8)
            | (src[offset + 3] & 0xFF));
    return value;
}

+(Byte*)float2Byte:(float)value {
    float wTemp=value;
    Byte * byteBuf = alloca(4);
    char* temp;
    temp=(char*)(&wTemp);
    byteBuf[0] = temp[0] ;
    byteBuf[1] = temp[1];
    byteBuf[2] = temp[2];
    byteBuf[3] = temp[3];
    return byteBuf;
}


#pragma mark check数据包
+(Boolean)checkPacketSum:(NSData *)readData{
    if(readData==nil || readData.length<5){
        return false;
    }
    //计算校验和
    NSData *incheckData=[readData subdataWithRange:NSMakeRange(3, readData.length-4)];
    int sum=[ByteUtils completeSum:incheckData];
    //获取check值
    int check=0;
    [readData getBytes:&check range:NSMakeRange(readData.length-1,1)];
    //比较
    if((sum & 0xFF)==(check & 0xFF)){
        return true;
    }else{
        return false;
    }
}

#pragma mark 计算校验和
+(int)completeSum:(NSData *)readData{
    //计算校验和
    int sum=0;
    for (int i=0; i<readData.length; i++) {
        int buf;
        [readData getBytes:&buf range:NSMakeRange(i, 1)];
        sum+=(buf& 0xFF);
    }
    return sum & 0xFF;
}



#pragma mark NSData转 16进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

#pragma mark 16进制转NSData
+ (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end
