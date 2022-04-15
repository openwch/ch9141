//
//  CH9140BluetoothManager.m
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/16.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import "CH9140BluetoothManager.h"
#import "CmdUtils.h"
#import "ParseUtils.h"
#import "Ch9140Constant.h"
#import "ModemNotifyItem.h"
#import "SerialBaudItem.h"
#import "SerialModemItem.h"
#import "ByteUtils.h"

@interface CH9140BluetoothManager ()<
CBCentralManagerDelegate,
CBPeripheralManagerDelegate,
CBPeripheralDelegate>

//特征
@property(nonatomic,strong)CBCharacteristic *readCharacteristic;
@property(nonatomic,strong)CBCharacteristic *writeCharacteristic;
@property(nonatomic,strong)CBCharacteristic *configCharacteristic;

//缓冲区状态
@property(nonatomic,assign)Boolean uptSendFullFlag;
@property(nonatomic,assign)Boolean uptSendEmptyFlag;

//中心设备管理器
@property(nonatomic,strong)CBCentralManager *centralManager;

//已连接的外设
@property(nonatomic,strong)CBPeripheral *peripheral;
//连接中的外设
@property(nonatomic,strong)CBPeripheral *connectingPeripheral;
//扫描的服务列表
@property(nonatomic,strong)NSArray<CBUUID*> *scanServiceUUIDs;
//扫描选项
@property(nonatomic,strong)NSDictionary *scanOptions;
//连接超时检测定时器
@property(nonatomic,strong)NSTimer *connectTimer;
#pragma mark 波特率设置相关参数
@property(assign,nonatomic)Boolean baudReadState;
@property (assign,nonatomic)NSInteger baudRate; //波特率
@property (assign,nonatomic)NSInteger dataBit;//数据位 5-8
@property (assign,nonatomic)NSInteger stopBit;//停止位  1-2
@property (assign,nonatomic)NSInteger parity;//校验位 0=无校验   1=奇校验  2=偶校验  3=标志位 4=空白位
#pragma mark 流控设置相关参数
@property(assign,nonatomic)Boolean flowReadDate;
@property (assign,nonatomic)NSInteger dtr;
@property (assign,nonatomic)NSInteger rts;
@property (assign,nonatomic)NSInteger flow;//开启流控
//最大的写入数据
@property(nonatomic,assign)NSInteger writeWithoutMaxLen;
@property(nonatomic,assign)NSInteger writeWithMaxLen;
//无响应写入
@property(nonatomic,assign)NSInteger canSendWrite;
@property(nonatomic,assign)NSInteger canSendWriteCallbackNum;
@property(nonatomic,assign)NSInteger writeNum;

@end

@implementation CH9140BluetoothManager

#pragma mark 初始化单例
+ (CH9140BluetoothManager *)shareManager {
    static CH9140BluetoothManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CH9140BluetoothManager alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if (self =[super init]) {
       
    }
    return self;
}

//开始枚举设备
-(void)startEnumDevicesWithOptions:(NSDictionary *)options{
    if(self.centralManager.isScanning){
        [self ch9140ManagerDidDiscoverPeripheralError:ERROR_INFO_CANCEL_SCAN]; return ;
    }
    //保存扫描选项
    self.scanOptions=options;
    if(self.peripheral!=nil && self.peripheral.state==CBPeripheralStateConnected){
        [self.centralManager cancelPeripheralConnection:self.peripheral];
    }
    [self.centralManager scanForPeripheralsWithServices:self.scanServiceUUIDs options:self.scanOptions];
}
//取消扫描
-(void)stopEnumDevices{
    //停止扫描
    if(self.centralManager.isScanning){
        [self.centralManager stopScan];
    }
}

#pragma mark 发现符合要求的外设，回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(ch9140ManagerDidDiscoverPeripheral:RSSI:error:)]){
        [self.delegate ch9140ManagerDidDiscoverPeripheral:peripheral RSSI:RSSI error:nil];
    }
}

#pragma mark 根据中心设备来扫描外设
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // 蓝牙可用，开始扫描外设
    [self didUpdateState:central.state];
}

#pragma mark 外设状态更新
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    [self didUpdateState:peripheral.state];
}

-(void)didUpdateState:(NSInteger)state{
    switch (state) {
        case CBManagerStatePoweredOn:
            // 扫描所有蓝牙设备
            [_centralManager scanForPeripheralsWithServices:self.scanServiceUUIDs options:self.scanOptions];
            break;
        case CBManagerStateUnsupported:
            [self ch9140ManagerDidDiscoverPeripheralError:Manager_State_Unsupported];
            break;
        case CBManagerStatePoweredOff:
            [self ch9140ManagerDidDiscoverPeripheralError:Manager_State_PoweredOff];
            break;
        case CBManagerStateResetting:
            [self ch9140ManagerDidDiscoverPeripheralError:Manager_State_Resetting];
            break;
        case CBManagerStateUnauthorized:
            [self ch9140ManagerDidDiscoverPeripheralError:Manager_State_Unauthorized];
            break;
        default:
            [self ch9140ManagerDidDiscoverPeripheralError:Manager_State_Unknow];
            break;
    }
}
//扫描出错
-(void)ch9140ManagerDidDiscoverPeripheralError:(NSError*)error{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(ch9140ManagerDidDiscoverPeripheral:RSSI:error:)]){
        [self.delegate ch9140ManagerDidDiscoverPeripheral:nil RSSI:nil error:error];
    }
}

#pragma mark 发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if(error==nil){
        // 遍历出外设中所有的服务
        for (CBService *service in peripheral.services) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }else{
        NSLog(@"%@",error.description);
    }
}

#pragma mark 发现到特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    if(error==nil){
        for (CBCharacteristic *characteristic in service.characteristics) {
            NSString *characterUUID=characteristic.UUID.UUIDString ;
            if([characterUUID isEqualToString:READ_CHARACTER_UUID]){
                //开启监听
                self.readCharacteristic=characteristic;
                if(self.readCharacteristic.isNotifying==false){
                    NSLog(@"=================开启监听===%@",characterUUID);
                    [self.peripheral setNotifyValue:YES forCharacteristic:self.readCharacteristic];
                }
                NSLog(@"READ_CHARACTER_UUID最大值:%ld",[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse]);
                NSLog(@"READ_CHARACTER_UUID最大值:%ld",[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithResponse]);
            }else if([characterUUID isEqualToString:WRITE_CHARACTER_UUID]){
                self.writeCharacteristic=characteristic;
                _writeWithMaxLen=[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithResponse];
                _writeWithoutMaxLen=[peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse];
            }else if([characterUUID isEqualToString:CONFIG_CHARACTER_UUID]){
                self.configCharacteristic=characteristic;
                if(self.configCharacteristic.isNotifying==false){
                    NSLog(@"=================开启监听===%@",characterUUID);
                    [self.peripheral setNotifyValue:YES forCharacteristic:self.configCharacteristic];
                }
            }
        }
    }else{
        NSLog(@"读取特征值出错%@",error.description);
    }
}


#pragma mark 读回调
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic
            error:(nullable NSError *)error{
    if(error==nil){
        NSData *readData=characteristic.value;
        if(readData!=nil && readData.length>0){
            if([characteristic isEqual:self.readCharacteristic]){
                if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(ch9140DidTransparentRead:)]){
                    [self.delegate ch9140DidTransparentRead:readData];
                }
            }else if([characteristic isEqual:self.configCharacteristic]){
                Byte *readBytes=(Byte *)[readData bytes];
                if((readBytes[0] & 0xFF)==0x86){//串口配置的响应包
                    _baudReadState=true;//修改读取标示
                    SerialBaudItem *tempItem= [ParseUtils paramsSerialBaud:readData];
                    if(tempItem.baudRate==_baudRate && tempItem.dataBit==_dataBit && tempItem.stopBit==_stopBit && tempItem.parity==_parity){
                        if(_serialBaudBlock!=nil){
                            _serialBaudBlock(true,@"配置波特率成功");
                        }
                    }else{
                        if(_serialBaudBlock!=nil){
                            _serialBaudBlock(false,@"配置波特率失败");
                        }
                        
                    }
                }else if((readBytes[0] & 0xFF)==0x87){//上报串口和模块状态
                    _flowReadDate=true;//流控读取标示
                    SerialModemItem *serialModemItem=[ParseUtils paramsSerialModem:readData];
                    if(serialModemItem.flow==_flow && serialModemItem.dtr==_dtr && serialModemItem.rts==_rts){
                        if(_serialModemBlock!=nil){
                            _serialModemBlock(true,@"配置流控成功");
                        }
                    }else{
                        if(_serialModemBlock!=nil){
                            _serialModemBlock(false,@"配置流控失败");
                        }
                    }
                }else if((readBytes[0] & 0xFF)==0x88){//上报串口和模块状态
                    ModemNotifyItem *modemNotifyItem=[ParseUtils paramsUptModem:readData];
                    if(modemNotifyItem!=nil && modemNotifyItem.uptSendFull==1){
                        _uptSendFullFlag=true;
                        //NSLog(@"-------发送区域------满");
                    }else if(modemNotifyItem!=nil && modemNotifyItem.uptSendEmpty==1){
                        _uptSendFullFlag=false;
                        //NSLog(@"-------发送区域------空");
                    }
                    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(ch9140DidSerialModemNotify:)]){
                        [self.delegate ch9140DidSerialModemNotify:modemNotifyItem];
                    }
                }
            }
        }
    }else{
        if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(ch9140DidReportLog:)]){
            [self.delegate ch9140DidReportLog:error.localizedDescription];
        }
    }
}

#pragma mark 透传写
-(NSInteger)ch9140DidWrite:(NSData *)data{
    if(data!=nil && data.length>0){
        NSInteger writeLen=0;
        NSInteger dataLen=data.length;
        NSInteger writeNum=0;
        if(dataLen<=_writeWithoutMaxLen){
            writeNum=1;
        }else{
            writeNum=ceilf(dataLen/(float)_writeWithoutMaxLen) ;
        }
        for (int i=0; i<writeNum; i++) {
            //1.处理蓝牙缓冲区满
            if(_uptSendFullFlag==true){
                //NSLog(@"蓝牙缓冲区满----------");
                for(int i=1;i<=TIMEOUT_REPEAT_NUM;i++){
                    [NSThread sleepForTimeInterval:0.001];
                    if(_uptSendFullFlag==false){
                       // NSLog(@"蓝牙缓冲区空----------");
                        break;
                    }
                    if(i==TIMEOUT_REPEAT_NUM){
                        //NSLog(@"蓝牙缓冲区空等待超时----------");
                        return -1;
                    }
                }
            }
            //2.裁切获取数据
            NSData *writeData =nil;
            if(dataLen>=(i+1)*_writeWithoutMaxLen){
                writeData= [data subdataWithRange:NSMakeRange(i*_writeWithoutMaxLen,_writeWithoutMaxLen)];
            }else{
                NSInteger spaceSize=dataLen-i*_writeWithoutMaxLen;
                writeData= [data subdataWithRange:NSMakeRange(i*_writeWithoutMaxLen, spaceSize)];
            }
            //判断是否可写
            _canSendWrite=[self.peripheral canSendWriteWithoutResponse];
            if(_canSendWrite==false){
                //尝试发一包
                    [NSThread sleepForTimeInterval:0.001];
                    [self.peripheral writeValue:writeData
                              forCharacteristic:self.writeCharacteristic
                                           type:CBCharacteristicWriteWithoutResponse];
                    //等待结果
                    for(int j=1;j<=TIMEOUT_REPEAT_NUM;j++){
                        [NSThread sleepForTimeInterval:0.001];
                        if(_canSendWrite==true){
                            writeLen+=writeData.length;
                            break;
                        }
                        if(j==TIMEOUT_REPEAT_NUM){
                            return writeLen;
                        }
                    }
            }else{
                [NSThread sleepForTimeInterval:0.001];
                [self.peripheral writeValue:writeData
                          forCharacteristic:self.writeCharacteristic
                                       type:CBCharacteristicWriteWithoutResponse];
                //累加写入的数据
                writeLen+=writeData.length;
            }
        
        }
        return writeLen;
    }
    return -1;
}

-(void)peripheralIsReadyToSendWriteWithoutResponse:(CBPeripheral *)peripheral{
    _canSendWrite=true;
  //  NSLog(@"-----WithoutResponse可写状态更新------%ld",_canSendWriteCallbackNum++);
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if(error!=nil){
        NSLog(@"写入出错:%@",error.description);
    }else{
        NSLog(@"写入成功-----------");
    }
}

#pragma mark 打开设备连接
-(void)openDevice:(CBPeripheral *)peripheral{
    _connectingPeripheral=peripheral;
    //发起连接
    self.peripheral=nil;
    [self.centralManager connectPeripheral:peripheral options:nil];
    [self performSelector:@selector(checkConnectinState) withObject:nil afterDelay:2.0f];
}
-(void)checkConnectinState{
    //未连接则取消连
    if(self.peripheral==nil){
        //NSLog(@"延时器----连接失败");
        [self.centralManager cancelPeripheralConnection:_connectingPeripheral];
    }
}

#pragma mark 关闭连接
-(void)closeDevice:(CBPeripheral *)peripheral{
    [self.centralManager cancelPeripheralConnection:peripheral];
}
#pragma mark 设备连接成功
-(void)centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral{
    //取消延迟检测器
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkConnectinState) object:nil];
    //保存链接的外设
    self.peripheral=peripheral;
    //停止扫描
    [self.centralManager stopScan];
    //通知连接成功
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(ch9140DidPeripheralConnectUpateState:error:)]){
        [self.delegate ch9140DidPeripheralConnectUpateState:peripheral error:nil];
    }
    //设置代理
    _peripheral.delegate=self;
    // 扫描所有服务
    NSArray<CBUUID *> * serviceUUIDS=@[[CBUUID UUIDWithString:SERVICE_UUID]];
    [_peripheral discoverServices:serviceUUIDS];
}

#pragma mark 设备连接失败回调
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral
                error:(NSError *)error {
    //取消延迟
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkConnectinState) object:nil];
    
    self.connectingPeripheral=nil;
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(ch9140DidPeripheralConnectUpateState:error:)]){
        [self.delegate ch9140DidPeripheralConnectUpateState:peripheral error:error];
    }
}

#pragma mark 设备断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral
                 error:(nullable NSError *)error {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkConnectinState) object:nil];
    
    self.connectingPeripheral=nil;
    self.peripheral=nil;
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(ch9140DidPeripheralConnectUpateState:error:)]){
        [self.delegate ch9140DidPeripheralConnectUpateState:peripheral error:error];
    }
}

#pragma mark 波特率
-(void)setSerialBaud:(NSInteger)baudRate
             dataBit:(NSInteger)dataBit
             stopBit:(NSInteger)stopBit
              parity:(NSInteger)parity
           withBlock:(SerialBaudBlock)serialBaudBlock{
    _serialBaudBlock=serialBaudBlock;
    if(_configCharacteristic==nil){
        if(_serialBaudBlock!=nil){
            _serialBaudBlock(false,@"没有搜索到配置通道");return ;
        }
    }
    _baudRate=baudRate;
    _dataBit=dataBit;
    _stopBit=stopBit;
    _parity=parity;
    //获取写入的指令数据
    NSData *serialBaudData=[CmdUtils cmdSetSerialBaud:baudRate dataBit:dataBit stopBit:stopBit parity:parity];
    [self.peripheral writeValue:serialBaudData forCharacteristic:_configCharacteristic type:CBCharacteristicWriteWithResponse];
    //读取
    __block CH9140BluetoothManager* __selfBlock = self;
    _baudReadState=false;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<READ_MAX_REPEAT; i++) {
            [__selfBlock.peripheral readValueForCharacteristic:__selfBlock.configCharacteristic];
            if(__selfBlock.baudReadState==true){
                break;
            }
            [NSThread sleepForTimeInterval:READ_INTERVAL];
        }
        //如果读取了10次还是没有读取到
        if(__selfBlock.baudReadState==false){
            if(__selfBlock.serialBaudBlock!=nil){
                __selfBlock.serialBaudBlock(false,@"蓝牙没有上报波特率设置状态");
            }
        }
    });
}


#pragma mark 配置流控及MODEM状态
-(void)setSerialModem:(Boolean)flow
             dtr:(NSInteger)dtr
             rts:(NSInteger)rts
            withBlock:(SerialModemBlock)serialModemBlock{
    _serialModemBlock=serialModemBlock;
    if(_configCharacteristic==nil){
        if(_serialModemBlock!=nil){
            _serialModemBlock(false,@"没有搜索到配置通道");return ;
        }
    }
    _flow=flow;
    _dtr=dtr;
    _rts=rts;
    //获取写入的指令数据
    NSData *serialModemData=[CmdUtils cmdSetSerialModem:flow dtr:dtr rts:rts];
    [self.peripheral writeValue:serialModemData forCharacteristic:_configCharacteristic type:CBCharacteristicWriteWithResponse];
    //读取
    __block CH9140BluetoothManager* __selfBlock = self;
    _flowReadDate=false;
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        for (int i=0; i<READ_MAX_REPEAT; i++) {
            [__selfBlock.peripheral readValueForCharacteristic:__selfBlock.configCharacteristic];
            if(__selfBlock.flowReadDate==true){
                break;
            }
            [NSThread sleepForTimeInterval:READ_INTERVAL];
        }
        if(__selfBlock.flowReadDate==false){
            if(__selfBlock.serialModemBlock!=nil){
                __selfBlock.serialModemBlock(false,@"蓝牙没有上报流控设置状态");
            }
        }
    });
}


#pragma mark 创建中心管理器
-(CBCentralManager*)centralManager{
    if(_centralManager==nil){
        //开启扫描外设
        NSDictionary *option=@{CBCentralManagerOptionShowPowerAlertKey:@YES};
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                   queue:nil
                                                                 options:option];
    }
    return _centralManager;
}

#pragma mark 扫描的服务列表
-(NSArray<CBUUID*>*)scanServiceUUIDs{
    if(_scanServiceUUIDs==nil){
        _scanServiceUUIDs=@[[CBUUID UUIDWithString:SERVICE_UUID]];
    }
    return nil;
}

#pragma mark 超时定时器,如果5秒钟还没有连上则超时
-(NSTimer *)connectTimer{
    if(_connectTimer==nil){
        _connectTimer= [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                        target:self
                                                      selector:@selector(checkConnectTimeOut)
                                                      userInfo:nil
                                                       repeats:YES];
        
    }
    return _connectTimer;
}

#pragma mark 检查超时情况
-(void)checkConnectTimeOut{
    if(self.connectingPeripheral!=nil){
        if(self.connectingPeripheral.state==CBPeripheralStateConnecting){
            NSLog(@"连接超时");
            //取消连接
            [_centralManager cancelPeripheralConnection:self.connectingPeripheral];
            self.connectingPeripheral=nil;
        }
    }
}

//获取最大的可写数据长度
-(NSInteger)ch9140MaxWriteValueLengthForType:(CBCharacteristicWriteType)type{
    if(type==CBCharacteristicWriteWithoutResponse){
        return _writeWithoutMaxLen;
    }else if(type==CBCharacteristicWriteWithResponse){
        return _writeWithMaxLen;
    }
    return 0;
}
@end
