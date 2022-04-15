//
//  ConfigCmd.m
//  GameHandle
//
//  Created by wcl on 2019/1/9.
//  Copyright © 2019 wcl. All rights reserved.
//

#import "CmdUtils.h"
#import "ByteUtils.h"
#import "SerialBaudItem.h"

@implementation CmdUtils

/**
 * 配置串口
 */
+(NSData *) cmdSetSerialBaud:(NSInteger)baudRate
                     dataBit:(NSInteger)dataBit
                     stopBit:(NSInteger)stopBit
                      parity:(NSInteger)parity{
    NSMutableData *writeData=[[NSMutableData alloc] init];
    //命令码
    int totalLen=11;
    Byte *cmdData=alloca(totalLen);
    cmdData[0]=0x06;
    cmdData[1]=0x00;
    cmdData[2]=0x09;
    cmdData[3]=0x00;
    //波特率
    Byte *bpsBytes=[ByteUtils intToBytesLittle:baudRate];
    cmdData[4]=bpsBytes[0]; //波特率
    cmdData[5]=bpsBytes[1];;
    cmdData[6]=bpsBytes[2];;
    cmdData[7]=bpsBytes[3];
    cmdData[8]=(Byte)dataBit; //数据位
    cmdData[9]=(Byte)stopBit;//停止位
    cmdData[10]=(Byte)parity;//校验位
    [writeData appendBytes:cmdData length:totalLen];
    //校验和
    Byte *checkBytes=alloca(1);
    NSData *incheckData=[writeData subdataWithRange:NSMakeRange(3, totalLen-3)]; //只需要减去前面三个字节
    checkBytes[0]=[ByteUtils completeSum:incheckData];
    [writeData appendBytes:checkBytes length:1];
    return writeData;
}

#pragma mark 配置流控
+(NSData *) cmdSetSerialModem:(Boolean)flow
                     dtr:(NSInteger)dtr
                     rts:(NSInteger)rts{
    NSMutableData *writeData=[[NSMutableData alloc] init];
    //命令码
    Byte *cmdData=alloca(4);
    cmdData[0]=0x07;
    cmdData[1]=0x00;
    cmdData[2]=0x05;
    cmdData[3]=0x00;
    [writeData appendBytes:cmdData length:4];
    //是否开启流控
    Byte *flowBytes=alloca(1);
    if(flow==true){
        flowBytes[0]=0x01;
    }else{
        flowBytes[0]=0x00;
    }
    [writeData appendBytes:flowBytes length:1];
    //DTR引脚设置
    Byte *dtrBytes=alloca(1);
    dtrBytes[0]=(Byte)dtr;
    [writeData appendBytes:dtrBytes length:1];
    //RTS引脚设置
    Byte *rtsBytes=alloca(1);
    rtsBytes[0]=(Byte)rts;
    [writeData appendBytes:rtsBytes length:1];
    //校验和
    Byte *checkBytes=alloca(1);
    NSData *incheckData=[writeData subdataWithRange:NSMakeRange(3, writeData.length-3)];//只需要减去前面三个字节
    checkBytes[0]=[ByteUtils completeSum:incheckData];
    [writeData appendBytes:checkBytes length:1];
    return writeData;
}


@end
