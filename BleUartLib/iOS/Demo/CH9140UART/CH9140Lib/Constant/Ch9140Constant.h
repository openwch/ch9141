//
//  Ch9140Constant.h
//
//  Created by wangchunlei on 15-1-12.
//  Copyright (c) 2015年 wangchunlei. All rights reserved.
//

#ifndef _____constant_h

#define _____constant_h



#define SERVICE_UUID @"FFF0"
#define READ_CHARACTER_UUID @"FFF1"
#define WRITE_CHARACTER_UUID @"FFF2"
#define CONFIG_CHARACTER_UUID @"FFF3"


#define CONNECT_DOMAIN_INFO @"FFF3"
#define ERROR_INFO_CANCEL_SCAN  [NSError errorWithDomain:CONNECT_DOMAIN_INFO code:1 userInfo:@{NSUnderlyingErrorKey:@"已经在扫描请先取消"}]
#define Manager_State_Unsupported  [NSError errorWithDomain:CONNECT_DOMAIN_INFO code:1 userInfo:@{NSUnderlyingErrorKey:@"该设备不支持蓝牙"}]
#define Manager_State_PoweredOff  [NSError errorWithDomain:CONNECT_DOMAIN_INFO code:2 userInfo:@{NSUnderlyingErrorKey:@"蓝牙已关闭"}]
#define Manager_State_Resetting  [NSError errorWithDomain:CONNECT_DOMAIN_INFO code:2 userInfo:@{NSUnderlyingErrorKey:@"蓝牙正在重置"}]
#define Manager_State_Unauthorized  [NSError errorWithDomain:CONNECT_DOMAIN_INFO code:2 userInfo:@{NSUnderlyingErrorKey:@"蓝牙未授权"}]
#define Manager_State_Unknow  [NSError errorWithDomain:CONNECT_DOMAIN_INFO code:2 userInfo:@{NSUnderlyingErrorKey:@"蓝牙存在未知问题"}]

#define READ_MAX_REPEAT 20
#define READ_INTERVAL 0.1

#define TIMEOUT_REPEAT_NUM 5000

#endif


