//
//  ByteUtils.h
//  枪神王座配置工具
//
//  Created by wcl on 2019/1/9.
//  Copyright © 2019年 wcl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ByteUtils : NSObject

// 将short转成byte[2]
+(Byte*)short2Byte:(short)value;
//将byte[2]转换成short
+(short) byte2Short:(Byte *)byteBuf;
//byte数组转int
+(NSInteger) byte2Int:(Byte*)b;
//int转byte数组
+(Byte*)int2Byte:(NSInteger)value;

+(Byte*)float2Byte:(float)value;

#pragma mark 检测校验和
+(Boolean)checkPacketSum:(NSData *)readData;
#pragma mark 计算校验和
+(int)completeSum:(NSData *)readData;

#pragma mark 以大端模式将int转成byte[]
+(Byte*)intToBytesBig:(NSInteger)value ;
#pragma mark 以小端模式将int转成byte[]
+(Byte*)intToBytesLittle:(NSInteger)value;
#pragma mark 以小端模式将byte[]转成int
+(NSInteger) bytesToIntLittle:(Byte*)src offset:(int) offset;
#pragma mark 以大端模式将byte[]转成int
-(NSInteger) bytesToIntBig:(Byte*)src offset:(int) offset;

//将16进制转NSData
+ (NSData *)convertHexStrToData:(NSString *)str;
//将NSData转16进制
+ (NSString *)convertDataToHexStr:(NSData *)data;

@end
