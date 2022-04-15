//
//  StringUtils.m
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/19.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

# pragma mark 根据特征获取属性

+(NSData *)testSpeedRandom{
    NSMutableData *totalData=[NSMutableData data];
    //setup包
    int cmdLength=2;
    Byte *cmdBuf=alloca(cmdLength);
    cmdBuf[0]=0x80;
    cmdBuf[1]=0x10;
    [totalData appendBytes:cmdBuf length:cmdLength];
    //地址
    int addrLength=2;
    Byte *addrBuf=[StringUtils setupRandomBytes:addrLength];
    [totalData appendBytes:addrBuf length:addrLength];
    //数据
    int dataLength=16;
    Byte *dataBuf=[StringUtils setupRandomBytes:dataLength];
    [totalData appendBytes:dataBuf length:dataLength];
    return totalData;
}

/**
 *获取固定字节的随机数
 */
+(Byte*)setupRandomBytes:(NSInteger)length{
    Byte* bytes=malloc(length);
    for (int i = 0; i < length; i++) {
        bytes[i] = (Byte) (arc4random_uniform(254) + 1);
    }
    return bytes;
}

//格式化字节尺寸
+(NSString *) formatByteSize:(NSInteger)size{
    //如果字节数少于1024，则直接以B为单位，否则先除于1024，后3位因太少无意义
    if (size < 1024) {
        return [NSString stringWithFormat:@"%ld B",size];
    } else {
        size = size / 1024;
    }
    //如果原字节数除于1024之后，少于1024，则可以直接以KB作为单位
    //因为还没有到达要使用另一个单位的时候
    //接下去以此类推
    if (size < 1024) {
        return [NSString stringWithFormat:@"%ld KB",size];
    } else {
        size = size / 1024;
    }
    if (size < 1024) {
        //因为如果以MB为单位的话，要保留最后1位小数，
        //因此，把此数乘以100之后再取余
        size = size * 100;
        return [NSString stringWithFormat:@"%ld.%ld MB",(size / 100),(size % 100)];
    } else {
        //否则如果要以GB为单位的，先除于1024再作同样的处理
        size = size * 100 / 1024;
        return [NSString stringWithFormat:@"%ld.%ld GB",(size / 100),(size % 100)];
    }
}

//判断是否位hex字符串
+(Boolean) isHex:(NSString *)info{
    if(info==nil || info.length==0) return false;
    if(info.length%2!=0) return false;
    NSString *pattern=@"^[A-Fa-f0-9]+$";
    NSRegularExpression *regula=[[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    NSUInteger matchNum=[regula numberOfMatchesInString:info
                                          options:0
                                            range:NSMakeRange(0, info.length)];
    if(matchNum==1){
        return true;
    }else{
        return false;
    }
}
@end
