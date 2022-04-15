//
//  CharacteristicUtil.m
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/19.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import "CharacteristicUtil.h"
#import "NSString+Regex.h"

@implementation CharacteristicUtil

# pragma mark 根据特征获取属性
+(NSMutableArray<NSString *> *)convertPropertiesList:(CBCharacteristicProperties)properties{
    NSMutableArray<NSString *> *propertiesList = [[NSMutableArray alloc]init];
    if ((properties & CBCharacteristicPropertyBroadcast) == CBCharacteristicPropertyBroadcast) {
        [propertiesList addObject:P_BROADCAST];
    }
    if ((properties & CBCharacteristicPropertyRead) == CBCharacteristicPropertyRead) {
        [propertiesList addObject:P_READ];
    }
    if ((properties & CBCharacteristicPropertyWriteWithoutResponse) == CBCharacteristicPropertyWriteWithoutResponse) {
        [propertiesList addObject:P_WRITE_WITHOUT_RESPONSE];
    }
    if ((properties & CBCharacteristicPropertyWrite) == CBCharacteristicPropertyWrite) {
        [propertiesList addObject:P_WRITE];
    }
    if ((properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify) {
        [propertiesList addObject:P_NOTIFY];
    }
    if ((properties & CBCharacteristicPropertyIndicate) == CBCharacteristicPropertyIndicate) {
        [propertiesList addObject:P_INDICATE];
    }
    if ((properties & CBCharacteristicPropertyAuthenticatedSignedWrites) == CBCharacteristicPropertyAuthenticatedSignedWrites) {
        [propertiesList addObject:P_AUTHENTICATED_SIGNED_WRITES];
    }
    if ((properties & CBCharacteristicPropertyExtendedProperties) == CBCharacteristicPropertyExtendedProperties) {
        [propertiesList addObject:P_EXTENDED_PROPERTIES];
    }
    if ((properties & CBCharacteristicPropertyNotifyEncryptionRequired) == CBCharacteristicPropertyNotifyEncryptionRequired) {
        [propertiesList addObject:P_NOTIFY_ENCRYPTION_REQUIRED];
    }
    if ((properties & CBCharacteristicPropertyIndicateEncryptionRequired) == CBCharacteristicPropertyIndicateEncryptionRequired) {
        [propertiesList addObject:P_INDICATE_ENCRYPTION_REQUIRED];
    }
    return propertiesList;
}

# pragma mark 判断是否有写的权限
+(BOOL)hasWriteProperties:(CBCharacteristicProperties)properties{
    NSMutableArray<NSString *> *propertiesList=[CharacteristicUtil convertPropertiesList:properties];
    if([propertiesList containsObject:P_WRITE]){
        return true;
    }
    return false;
}

# pragma mark 判断是否有读的权限
+(BOOL)hasReadProperties:(CBCharacteristicProperties)properties{
    NSMutableArray<NSString *> *propertiesList=[CharacteristicUtil convertPropertiesList:properties];
    if([propertiesList containsObject:P_READ]){
        return true;
    }
    return false;
}

# pragma mark 判断是否有读的权限
+(BOOL)hasNotifyProperties:(CBCharacteristicProperties)properties{
    NSMutableArray<NSString *> *propertiesList=[CharacteristicUtil convertPropertiesList:properties];
    if([propertiesList containsObject:P_NOTIFY]){
        return true;
    }
    return false;
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


#pragma mark 将字符串格式化成16进制显示，2个加空格，如果有多余则添加0
+ (NSString *)formatHexStr:(NSString *)hexStr withZero:(BOOL)zero{
    if ([NSString isBlankString:hexStr]) {
        return @"";
    }
    //去掉空格
    hexStr=[hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //格式化
    NSMutableArray<NSString *> *tempArray=[NSMutableArray array];
    int model=hexStr.length%2;
    NSInteger stringLength=hexStr.length;
    int eachCount=ceil((float)stringLength/2);
    for (int index=0; index<eachCount; index++) {
        NSUInteger loc=index*2;
        NSUInteger len=2;
        if(model==1 && hexStr.length-index*2==1){
            len=1;
        }
        NSRange range=NSMakeRange(loc,len);
        NSString *tempStr=[hexStr substringWithRange:range];
        //剩余一个字符
        if(len==1 && zero==true){
            [tempArray addObject:[NSString stringWithFormat:@"0%@",tempStr]];
        }else{
            [tempArray addObject:tempStr];
        }
    }
    if([tempArray count]>0){
        return [tempArray componentsJoinedByString:@" "];
    }
    return @"";
}


#pragma mark 将16进制字符串转为NSData
+ (NSData *)hexToBytes:(NSString *)str{
    //去掉空格
    if(str==nil){
        return nil;
    }
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData* data = [NSMutableData data];
    int model=str.length%2;
    NSInteger strLength=str.length;
    int eachCount=ceil((float)strLength/2);
    for (int index=0; index<eachCount; index++) {
        NSUInteger loc=index*2;
        NSUInteger len=2;
        if(model==1 && str.length-index*2==1){
            len=1;
        }
        NSRange range=NSMakeRange(loc,len);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner        scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}


@end
