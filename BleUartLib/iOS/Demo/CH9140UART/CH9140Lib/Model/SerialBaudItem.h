//
//  SerialBaudItem.h
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SerialBaudItem : NSObject
//波特率
@property (assign,nonatomic)NSInteger baudRate;
//数据位 5-8
@property (assign,nonatomic)NSInteger dataBit;
//停止位  1-2
@property (assign,nonatomic)NSInteger stopBit;
//校验位 0=无校验   1=奇校验  2=偶校验  3=标志位 4=空白位
@property (assign,nonatomic)NSInteger parity;

@end

