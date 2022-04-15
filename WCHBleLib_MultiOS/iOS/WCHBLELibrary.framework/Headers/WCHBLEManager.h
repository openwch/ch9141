//
//  WCHBLEManager.h
//  WCHBLELibrary
//
//  Created by 娟华 胡 on 2021/3/15.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


typedef void(^writeDataCallBack)(long);

typedef void(^rssiCallBack)(NSNumber *);

#pragma mark - 代理方法
@protocol BLEAssistDelegate <NSObject>

//蓝牙状态回调
- (void)BLEManagerDidUpdateState:(NSError *)error;

//监听设备连接状态变更通知
- (void)BLEManagerDidPeripheralConnectUpateState:(CBPeripheral *)peripheral error:(NSError *)error;

//发现设备回调
- (void)BLEManagerDidDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;

//发现服务回调
- (void)BLEManagerPeriphearl:(CBPeripheral *)peripheral services:(NSArray<CBService *> *)services error:(NSError *)error;

//发现服务特征回调
- (void)BLEManagerService:(CBService *)service characteristics:(NSArray<CBCharacteristic *> *)characteristics error:(NSError *)error;

//特征通道的值发生改变
- (void)BLEManagerUpdateValueForCharacteristic:(CBPeripheral *)peripheral Characteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

@end

@interface WCHBLEManager : NSObject

@property (nonatomic, weak) id<BLEAssistDelegate> delegate;

//开启调试信息
@property (nonatomic, assign)BOOL isDebug;
//可以根据传入的UUID扫描服务
@property (nonatomic, strong) NSArray<CBUUID *> * serviceUUIDS;

//读取日志
- (NSArray *)readLog;

//生成单列
+ (instancetype) getInstance;

//开始扫描
//@scanRuler  扫描过滤规则
//@scanObserver 扫描回调
- (void)startScan:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary *)scanRuler;

//扫描附近的CH914X设备
- (void)startScanCH914X;

//停止扫描
- (void)stopScan;

//连接设备
- (void)connect:(CBPeripheral *)peripheral;

//断开连接
- (void)disconnect:(CBPeripheral *)peripheral;

//获取连接过的设备
- (NSArray<CBPeripheral *> *)retrievePeripheralsWithIdentifiers:(NSArray<NSUUID *> *)identifiers;

//发送数据
//@data 待发送数据
- (void)writeData:(NSData *)data peripheral:(CBPeripheral *)peripheral writeForChar:(CBCharacteristic *)characteristic writeCallBack:(writeDataCallBack)writeBlock;

//读取数据
- (void)readData:(CBPeripheral *)peripheral readValueForChar:(CBCharacteristic *)characteristic;

//订阅某个特征值
- (void)peripheralNotify:(CBPeripheral *)peripheral setNotifyForChar:(CBCharacteristic *)characteristic;

//取消某个订阅
- (void)peripheralNotify:(CBPeripheral *)peripheral cancleNotifyForChar:(CBCharacteristic *)characteristic;

//读取信号
- (void)readRSSI:(CBPeripheral *)peripheral rssiCallBack:(rssiCallBack)rssiBlock;

@end

