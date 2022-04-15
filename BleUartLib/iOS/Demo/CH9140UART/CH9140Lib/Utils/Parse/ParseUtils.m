//
//  ParseUtils.m
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/19.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import "ParseUtils.h"
#import "ModemNotifyItem.h"
#import "ByteUtils.h"
#import "SerialBaudItem.h"
#import "SerialModemItem.h"

@implementation ParseUtils

#pragma mark 解析0x88上报的串口状态和MODEM
+(ModemNotifyItem *)paramsUptModem:(NSData *)readData{
    
    ModemNotifyItem *modemNotifyItem =[[ModemNotifyItem alloc]init];
    if([ByteUtils checkPacketSum:readData]){
        //解析串口状态
        int uptState;
        [readData getBytes:&uptState range:NSMakeRange(4, 1)];
        modemNotifyItem.uptSendEmpty=(uptState & 0x01)==0x01?1:0;//串口发送空
        modemNotifyItem.modemChange=(uptState & 0x02)==0x02?1:0;//MODEM变化
        modemNotifyItem.uptSendFull=(uptState & 0x04)==0x04?1:0;//串口发送满
        
        //解析MODEM状态
        int modemState;
        [readData getBytes:&modemState range:NSMakeRange(5, 1)];
        modemNotifyItem.modemCts=(modemState & 0x10)==0x10?1:0;//cts
        modemNotifyItem.modemDsr=(modemState & 0x20)==0x20?1:0;//dsr
        modemNotifyItem.modemRi=(modemState & 0x40)==0x40?1:0;//RI
        modemNotifyItem.modemDcd=(modemState & 0x80)==0x80?1:0;//DCD
    }
    return modemNotifyItem;
}

#pragma mark 解析配置串口的86指令
+(SerialBaudItem *)paramsSerialBaud:(NSData *)readData{
    SerialBaudItem *serialBaudItem=[[SerialBaudItem alloc]init];
    if([ByteUtils checkPacketSum:readData]){

        //波特率  86000900 00c20100 080100cc
        int baudBytes;
        [readData getBytes:&baudBytes range:NSMakeRange(4, 4)];
        serialBaudItem.baudRate=baudBytes;
        //数据位
        int  dataBit;
        [readData getBytes:&dataBit range:NSMakeRange(8, 1)];
        serialBaudItem.dataBit=dataBit&0xFF;
        //停止位
        int  stopBit;
        [readData getBytes:&stopBit range:NSMakeRange(9, 1)];
        serialBaudItem.stopBit=stopBit&0xFF;
        //校验位
        int  parity;
        [readData getBytes:&parity range:NSMakeRange(10, 1)];
        serialBaudItem.parity=parity&0xFF;
    }
    return serialBaudItem;
}

#pragma mark 解析配置流控的87指令
+(SerialModemItem *)paramsSerialModem:(NSData *)readData{
    SerialModemItem *serialModemItem=[[SerialModemItem alloc]init];
    if([ByteUtils checkPacketSum:readData]){
        //波特率
        int flowState;
        [readData getBytes:&flowState range:NSMakeRange(4, 1)];
        serialModemItem.flow=flowState &0xFF;
        //DTR
        int  dtr;
        [readData getBytes:&dtr range:NSMakeRange(5, 1)];
        serialModemItem.dtr=dtr&0xFF;
        //rts
        int  rts;
        [readData getBytes:&rts range:NSMakeRange(6, 1)];
        serialModemItem.rts=rts&0xFF;
    }
    return serialModemItem;
}


@end
