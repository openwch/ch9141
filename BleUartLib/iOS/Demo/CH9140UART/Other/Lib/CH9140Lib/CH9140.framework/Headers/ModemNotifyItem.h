//
//  ModemNotifyItem.h
//  teacher
//
//  Created by 娟华 胡 on 2020/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModemNotifyItem : NSObject
//bit0:发送空
@property (assign,nonatomic)NSInteger uptSendEmpty;
//bit2:发送满
@property (assign,nonatomic)NSInteger uptSendFull;
//bit1:MODEM变化
@property (assign,nonatomic)NSInteger modemChange;
//DCD引脚
@property (assign,nonatomic)NSInteger modemDcd;
//RI引脚
@property (assign,nonatomic)NSInteger modemRi;
//DSR引脚
@property (assign,nonatomic)NSInteger modemDsr;
//CTS引脚
@property (assign,nonatomic)NSInteger modemCts;
@end
