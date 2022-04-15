//
//  ParseUtils.h
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/19.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModemNotifyItem,SerialBaudItem,SerialModemItem;

@interface ParseUtils : NSObject

#pragma mark 串口状态和MODEM上报
+(ModemNotifyItem *) paramsUptModem:(NSData *)data;
#pragma mark 解析串口数据
+(SerialBaudItem *)paramsSerialBaud:(NSData *)readData;
#pragma mark 解析配置流控的87指令
+(SerialModemItem *)paramsSerialModem:(NSData *)readData;
@end

