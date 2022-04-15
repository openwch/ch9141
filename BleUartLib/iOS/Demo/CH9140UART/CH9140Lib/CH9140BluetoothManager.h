//
//  CH9140BluetoothManager.h
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/16.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

@class CBPeripheral,ModemNotifyItem;

@protocol Ch9140AssistDelegate<NSObject>
#pragma mark 上报错误信息
-(void)ch9140DidReportLog:(NSString *)info;
#pragma mark 监听上报串口及Modem状态通知
-(void)ch9140DidSerialModemNotify:(ModemNotifyItem *)modemNotifyItem;
#pragma mark 监听透传读通道的读取到的值
-(void)ch9140DidTransparentRead:(NSData *)data;
#pragma mark 监听扫描蓝牙通知
- (void)ch9140ManagerDidDiscoverPeripheral:(CBPeripheral *)peripheral
                                               RSSI:(NSNumber *)RSSI
                                               error:(NSError*)error;
#pragma mark 监听设备连接状态变更通知
-(void)ch9140DidPeripheralConnectUpateState:(CBPeripheral *)peripheral
                                      error:(NSError *)error;
@end

@interface CH9140BluetoothManager :NSObject

#pragma mark 这里采用代理模式监听通知
@property(nonatomic,assign)id<Ch9140AssistDelegate>delegate;

#pragma mark 开始枚举设备
-(void)startEnumDevicesWithOptions:(NSDictionary *)options;
#pragma mark 停止枚举设备
-(void)stopEnumDevices;

#pragma mark 打开连接设备
-(void)openDevice:(CBPeripheral *)peripheral;
#pragma mark 关闭连接设备
-(void)closeDevice:(CBPeripheral *)peripheral;

#pragma mark 设置波特率以及其他参数
typedef void (^SerialBaudBlock) (Boolean returnValue,NSString *info);
@property (strong, nonatomic) SerialBaudBlock serialBaudBlock;
-(void)setSerialBaud:(NSInteger)baudRate
             dataBit:(NSInteger)dataBit
             stopBit:(NSInteger)stopBit
              parity:(NSInteger)parity
           withBlock:(SerialBaudBlock)setSerialBaudBlock;

#pragma mark 设置流控开关及Modem状态
typedef void (^SerialModemBlock) (Boolean returnValue,NSString *info);
@property (strong, nonatomic) SerialModemBlock serialModemBlock;
-(void)setSerialModem:(Boolean)flow
             dtr:(NSInteger)dtr
             rts:(NSInteger)rts
           withBlock:(SerialModemBlock)serialModemBlock;

#pragma mark 写入数据
-(NSInteger)ch9140DidWrite:(NSData *)data;
#pragma mark 根据类型获取可写入的最大数据
-(NSInteger)ch9140MaxWriteValueLengthForType:(CBCharacteristicWriteType)type;
#pragma mark 初始化单例
+ (CH9140BluetoothManager *)shareManager;

@end
