//
//  CharacteristicUtil.h
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/19.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define P_BROADCAST  @"Broadcast"
#define P_READ  @"Read"
#define P_WRITE_WITHOUT_RESPONSE  @"WriteWithoutResponse"
#define P_WRITE  @"Write"
#define P_NOTIFY  @"Notify"
#define P_INDICATE @"Indicate"
#define P_AUTHENTICATED_SIGNED_WRITES @"AuthenticatedSignedWrites"
#define P_EXTENDED_PROPERTIES @"ExtendedProperties"
#define P_NOTIFY_ENCRYPTION_REQUIRED @"NotifyEncryptionRequired"
#define P_INDICATE_ENCRYPTION_REQUIRED @"IndicateEncryptionRequired"


@interface CharacteristicUtil : NSObject

//权限列表转化
+(NSMutableArray<NSString *> *)convertPropertiesList:(CBCharacteristicProperties)properties;

//判断是否有写的权限
+(BOOL)hasWriteProperties:(CBCharacteristicProperties)properties;

//判断是否有读的权限
+(BOOL)hasReadProperties:(CBCharacteristicProperties)properties;

//监听
+(BOOL)hasNotifyProperties:(CBCharacteristicProperties)properties;

//将16进制字符串格式化成空格显示
+ (NSString *)formatHexStr:(NSString *)hexStr withZero:(BOOL)zero;

//将16进制字符串转为NSData
+ (NSData *)hexToBytes:(NSString *)str;

//将NSData转16进制
+ (NSString *)convertDataToHexStr:(NSData *)data;
+ (NSData *)convertHexStrToData:(NSString *)str;

@end
