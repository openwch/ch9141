//
//  ConfigCmd.h
//  GameHandle
//
//  Created by wcl on 2019/1/9.
//  Copyright © 2019 wcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SerialBaudItem;

typedef NS_ENUM(NSInteger, CmdCode) {
    CMD_SET_SERIAL_BAUD =0x86 //配置串口
};

@interface CmdUtils : NSObject

//命令码
@property(nonatomic,assign) CmdCode cmdCode;

#pragma mark配置串口
+(NSData *) cmdSetSerialBaud:(NSInteger)baudRate
                     dataBit:(NSInteger)dataBit
                     stopBit:(NSInteger)stopBit
                      parity:(NSInteger)parity;
#pragma mark 配置流控
+(NSData *) cmdSetSerialModem:(Boolean)flow
                     dtr:(NSInteger)dtr
                          rts:(NSInteger)rts;
@end
