//
//  PeripheralInfoViewController.m
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/16.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import "PeripheralInfoViewController.h"
#import "PeripheralCharacteristicCell.h"
#import "CharacteristicUtil.h"
#import "CharacteristicUtil.h"
#import "ServiceItem.h"
#import "CharacteristicItem.h"
#import "PeripheralInfoView.h"
#import "SendConfigItem.h"
#import "CharacteristicUtil.h"
#import "WriteConfigView.h"
#import "TransferConfig.h"
#import "SerialConfigView.h"
#import "ReadConfigView.h"
#import "ScanningView.h"
#import "PeripheraItem.h"
#import "NSString+Regex.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CH9140/CH9140BluetoothManager.h>
#import <CH9140/ModemNotifyItem.h>
#import <CH9140/SerialBaudItem.h>
#import <CH9140/SerialModemItem.h>
#import "WebShowViewController.h"
#import "ConnectUtil.h"

@interface PeripheralInfoViewController ()<
PeripheralInfoViewDelegate,
WriteConfigViewDelegate,
ReadConfigViewDelegate,
Ch9140AssistDelegate,
WriteConfigViewDelegate,
SerialConfigViewDelegate,
UIAlertViewDelegate,
ScanningViewDelegate,
MFMailComposeViewControllerDelegate>

/** navi头部*/
@property(nonatomic,strong)WLNavigationHead * naviHead;
/** 视图 */
@property(nonatomic,strong) PeripheralInfoView *peripheralInfoView;
//统计写入秒数 和 统计写入总长度
@property(nonatomic,assign)NSInteger sendStatisLength;
@property(nonatomic,assign)NSInteger sendStartTime;
@property(nonatomic,assign)NSInteger sendEndTime;
/**取消写入标志*/
@property(nonatomic,assign)Boolean cancelWriteFlag;

//统计读取秒数 和 统计读取总长度
@property(nonatomic,assign)NSInteger readStatisLength;
@property(nonatomic,assign)NSInteger readStartTime;
@property(nonatomic,assign)Boolean readStartFlag;
@property(nonatomic,assign)NSInteger readEndTime;
//辅助类
@property(nonatomic,strong)CH9140BluetoothManager *bluetoothManager;
//传输配置窗口
@property(nonatomic,strong)WriteConfigView *writeConfigView;
@property(nonatomic,strong)ReadConfigView *readConfigView;
@property(nonatomic,strong)SerialConfigView *serialConfigView;

@property(nonatomic,strong)ScanningView *scanningView;
@property(nonatomic,strong)NSMutableArray *peripheraListItems;
//数据模型
@property(nonatomic,strong)TransferConfig *transferConfig;
@property(nonatomic,strong)SerialBaudItem *serialBaudItem;
@property(nonatomic,strong)SerialModemItem *serialModemItem;
//串口
@property(nonatomic,strong)ModemNotifyItem *modemNotifyItem;
//连接按钮
@property(nonatomic,strong)UIButton *connectBtn;
//当前连接成功的外设
@property(nonatomic,strong)CBPeripheral *peripheral;
//是否自动连接
@property(assign,nonatomic)Boolean autoConnect;
@property(strong,nonatomic)NSMutableSet *historyConnect;

//发送文件
@property (strong, nonatomic) NSFileHandle * readHandle;
//文件读取句柄偏移量
@property (assign, nonatomic) unsigned long long offset;
@property (assign, nonatomic) NSInteger totalPackage;//总包数
@property (assign, nonatomic) NSUInteger currentPackage;//当前包数
//写入文件
@property (strong, nonatomic) NSFileHandle * writeHandle;
//扫描选项
@property (strong, nonatomic) NSDictionary *scanOptions;
//窗口显示模式 1=调试模式  2=监听模式
@property (assign, nonatomic) Boolean windowDebug;

@end

@implementation PeripheralInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupNaviHead];
    [self initEvent];
    [self scanExistDevice];

}

-(void)setupView{
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.windowDebug=true;
    self.peripheralInfoView.transferConfig=self.transferConfig;
    self.peripheralInfoView.enableState=false;
    [self.view addSubview:self.peripheralInfoView];
}

#pragma mark 创建导航头
-(void)setupNaviHead{
    UILabel *naviTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    naviTitle.textAlignment=NSTextAlignmentCenter;
    naviTitle.textColor=[UIColor whiteColor];
    naviTitle.font=font18Bold;
    naviTitle.text=@"BleUart";
    
    //左侧按钮
    UIButton *leftBtn=[[UIButton alloc]init];
    leftBtn.frame=CGRectMake(0, 0, 30, 30);
    leftBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [leftBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];

    //右侧按钮
    _connectBtn=[[UIButton alloc]init];
    [_connectBtn setTitle:@"连接蓝牙" forState:UIControlStateNormal];
    [_connectBtn setTitle:@"断开连接" forState:UIControlStateSelected];
    _connectBtn.titleLabel.font=font14Bold;
    [_connectBtn addTarget:self action:@selector(clickConnectBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //创建导航
    _naviHead=[[WLNavigationHead alloc]initWithTitleView:naviTitle leftView:leftBtn rightView:_connectBtn];
    _naviHead.frame=CGRectMake(0,0,ScreenWidth, NavigationTopHeight);
    [self.view addSubview:_naviHead];
    
}


#pragma mark 初始化事件
-(void)initEvent{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyBoardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyBoardWillHiden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark 开始扫描服务和特征
-(void)setPeripheral:(CBPeripheral *)peripheral{
    _peripheral=peripheral;
}

#pragma mark 扫描已前连接过的设备
-(void)scanExistDevice{
    self.historyConnect=[[ConnectUtil getConnect] mutableCopy];
    
    NSLog(@"historyConnect:%@",[self.historyConnect description]);
    if([self.historyConnect count]>0){
        _autoConnect=true;
        [self showHUDByView:self.navigationController.view
                       type:MBProgressHUDModeIndeterminate
                              info:@"扫描中"
                  hidenTime:1.0f];
        [self.peripheraListItems removeAllObjects];
        [self.bluetoothManager startEnumDevicesWithOptions:self.scanOptions];
        //如果秒钟没有找到存在的
        [self performSelector:@selector(checkHistoryConnect) withObject:nil afterDelay:1.0f];
    }else{
        //如果不存在历史连接
        _autoConnect=false;
        [self startScanning];
    }
    
}
#pragma mark 1秒后检测是否已ing扫到
-(void)checkHistoryConnect{
    if(_autoConnect==true){
        _autoConnect=false;
        [self startScanning];
    }
}

#pragma mark 发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if(error==nil){
        // 遍历出外设中所有的服务
        for (CBService *service in peripheral.services) {
            NSLog(@"------service:%@",service.UUID.UUIDString);
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }else{
        NSLog(@"%@",error.description);
    }
}

#pragma mark 点击配置串口
-(void)peripheralInfoViewDidClickUptBtn{
    _serialConfigView = [[SerialConfigView alloc]init];
    _serialConfigView.frame=self.view.bounds;
    _serialConfigView.serialBaudItem=self.serialBaudItem;
    _serialConfigView.serialModemItem=self.serialModemItem;
    _serialConfigView.delegate=self;
    [self.view addSubview:_serialConfigView];
}

#pragma mark 取消配置
-(void)serialConfigViewDidCancel{
    [_serialConfigView removeFromSuperview];
    _serialConfigView=nil;
}
#pragma mark 保存配置
-(void)serialConfigViewDidSure:(SerialBaudItem *)serialBaudItem{
    [self showHUDByView:self.navigationController.view
                   type:MBProgressHUDModeIndeterminate
                          info:@"开始设置"
              hidenTime:0.0f];
    _serialBaudItem=serialBaudItem;
    PeripheralInfoViewController *__selfBlock=self;
    [self.bluetoothManager setSerialBaud:serialBaudItem.baudRate
                                 dataBit:serialBaudItem.dataBit
                                 stopBit:serialBaudItem.stopBit
                                  parity:serialBaudItem.parity
                               withBlock:^(Boolean returnValue, NSString *info) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [__selfBlock showHUDByView:__selfBlock.navigationController.view
                           type:MBProgressHUDModeText
                                  info:info
                      hidenTime:2.0f];
            __selfBlock.peripheralInfoView.serialBaudItem=serialBaudItem;
        }];

    }];
}

-(void)serialConfigViewDidModem:(SerialModemItem *)cacheModemItem{
    [self showHUDByView:self.navigationController.view
                   type:MBProgressHUDModeIndeterminate
                          info:@"开始设置"
              hidenTime:0.0f];
    _serialModemItem=cacheModemItem;

    PeripheralInfoViewController *__selfBlock=self;
    [self.bluetoothManager setSerialModem:cacheModemItem.flow
                                      dtr:cacheModemItem.dtr
                                      rts:cacheModemItem.rts
                                withBlock:^(Boolean returnValue,NSString *info) {

        //主线程更新视图
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [__selfBlock showHUDByView:__selfBlock.navigationController.view
                           type:MBProgressHUDModeText
                                  info:info
                      hidenTime:2.0f];
        }];
    }];
}

#pragma mark 单次写入
-(void)peripheralInfoViewDidOnceWrite:(NSData *)writeData{
    //启动一个新线程发送数据
    __block PeripheralInfoViewController* __selfBlock = self;
    __block NSData* __writeDataBlock=writeData;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger writeNum=0;
        if((writeNum=[__selfBlock.bluetoothManager ch9140DidWrite:__writeDataBlock])>0){
            __selfBlock.sendEndTime=(int)[[NSDate date] timeIntervalSince1970];
            NSInteger diffent=__selfBlock.sendEndTime-__selfBlock.sendStartTime;
            __selfBlock.sendStatisLength+=writeNum; //累计写入长度
             dispatch_async(dispatch_get_main_queue(), ^{
                 [__selfBlock.peripheralInfoView staticWriteLength:self.sendStatisLength withTime:diffent];
             });
        }
    });
}
#pragma mark 重复写入
-(void)peripheralInfoViewDidRepeatWrite:(NSData *)writeData{
    //流控状态
    _cancelWriteFlag=false;
    _sendStartTime=(int)([[NSDate date] timeIntervalSince1970]);//写
    _sendStatisLength=0;
    _readStartFlag=false;
    //启动一个新线程发送数据
    __block PeripheralInfoViewController* __selfBlock = self;
    __block NSData* __writeDataBlock=writeData;
    __block TransferConfig *__transferConfig=self.transferConfig;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger writeNum=0;
        while((writeNum=[self.bluetoothManager ch9140DidWrite:__writeDataBlock])>0){
            if(__transferConfig.sendWay==3 && __transferConfig.timer>0){
                [NSThread sleepForTimeInterval:__transferConfig.timer*0.001]; //自定义添加间隔
            }
            __selfBlock.sendEndTime=(int)[[NSDate date] timeIntervalSince1970];
            NSInteger diffent=__selfBlock.sendEndTime-__selfBlock.sendStartTime;
            __selfBlock.sendStatisLength+=writeNum; //累计写入长度
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.peripheralInfoView staticWriteLength:self.sendStatisLength withTime:diffent];
             });
            //如果是连续发送泽继续
            if(self.cancelWriteFlag){
                break;
            }
        }
    });
    
}


#pragma mark 重复写入
-(void)peripheralInfoViewDidWriteFile{
    //流控状态
    _cancelWriteFlag=false;
    _sendStartTime=(int)([[NSDate date] timeIntervalSince1970]);//写
    _readStartTime=(int)([[NSDate date] timeIntervalSince1970]);;//读
    _sendStatisLength=0;
    _readStatisLength=0;
    //1.获取文件数据
    NSString *filePath=[self writeFilePath:_transferConfig.fileName];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:filePath]) {
        [self showHUDByView:self.navigationController.view
                       type:MBProgressHUDModeText info:@"文件不存在"
                  hidenTime:1.0f];
        return;
    }
    
    //创建读文件的句柄
    self.readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    self.offset = 0;//用来记录偏移量
    unsigned long long totalRet = [self.readHandle seekToEndOfFile];//返回文件大小
    self.totalPackage = (int)ceilf(totalRet*1.0/PackgeSize); //计算总包数
    self.currentPackage = 0; //当前包
    __block PeripheralInfoViewController* __selfBlock = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger writeNum=0;
        NSData *writeData=nil;
        NSInteger totalLen=0;
        while ((writeData=[self readFileData])!=nil) {
            if(writeData==nil)break;
            totalLen=totalLen+writeData.length;
            if ((writeNum=[self.bluetoothManager ch9140DidWrite:writeData])>0){
                NSLog(@"写入成功writeNum==%ld",writeNum);
                __selfBlock.sendEndTime=(int)[[NSDate date] timeIntervalSince1970];
                NSInteger diffent=__selfBlock.sendEndTime-__selfBlock.sendStartTime;
                __selfBlock.sendStatisLength+=writeNum; //累计写入长度
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.peripheralInfoView staticWriteLength:self.sendStatisLength withTime:diffent];
                 });
                //如果是连续发送泽继续
                if(self.cancelWriteFlag){
                    break;
                }
            }
        }

    });
        
}

#pragma mark 取消写入
-(void)peripheralInfoViewDidCancelWrite{
    _cancelWriteFlag=true;
}

#pragma mark 上报错误信息
-(void)ch9140DidReportLog:(NSString *)info{
        NSLog(@"日志上报----%@",info);
}
#pragma mark MODEM上报状态
-(void)ch9140DidSerialModemNotify:(ModemNotifyItem *)modemNotifyItem{
    _modemNotifyItem=modemNotifyItem;
    _peripheralInfoView.modemNotifyItem=modemNotifyItem;
}
#pragma mark 监听透传读通道的读取到的值
-(void)ch9140DidRead:(NSData *)data{
   // NSLog(@"读特征读到数据长度:%@",[CharacteristicUtil convertDataToHexStr:data]);
    if(data!=nil && data.length>0){
        //累加读到的数据长度
        if(_readStartFlag==false){
            _readStartFlag=true;
            _readStartTime=(int)([[NSDate date] timeIntervalSince1970]);;//读
            _readStatisLength=0;
        }
        _readStatisLength+=data.length;
        _readEndTime=(int)[[NSDate date]timeIntervalSince1970];
        NSInteger deffient=_readEndTime-_readStartTime;
        //主线程更新视图
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.peripheralInfoView staticReadLength:self.readStatisLength withTime:deffient];
        }];
        if(_transferConfig.showWay==1 || _transferConfig.showWay==3 || _transferConfig.showWay==4){
            [self.peripheralInfoView appendReadData:data];//添加
        }else if(_transferConfig.showWay==2 ){
            //写入到文件
            [self writeDataToFile:data];
        }
    }
}

#pragma 传输配置
-(void)clickConnectBtn{
    if(_connectBtn.selected==false){
        //开始扫描
        [self startScanning];
    }else{
        [self closeDeviceConnect];
    }
}

#pragma mark 关闭连接
-(void)closeDeviceConnect{
    [self.bluetoothManager closeDevice:self.peripheral];
}
#pragma mark 开始扫描
-(void)startScanning{
    [self.peripheraListItems removeAllObjects];
    [self.bluetoothManager startEnumDevicesWithOptions:self.scanOptions];
    //连接蓝牙
    _scanningView = [[ScanningView alloc]init];
    _scanningView.frame=self.view.bounds;
    _scanningView.scanningItems=self.peripheraListItems;
    _scanningView.delegate=self;
    [self.view addSubview:_scanningView];
}
#pragma mark 取消扫描
-(void)scanningViewDidCancel{
    [self.bluetoothManager stopEnumDevices];
    [_scanningView removeFromSuperview];
}

#pragma mark 发现符合要求的外设，回调
- (void)ch9140ManagerDidDiscoverPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI error:(NSError *)error{
    if(error!=nil){
        NSLog(@"扫描出错:%@",error.localizedDescription);
    }else{
        //如果需要自动连接
        if(_autoConnect==true){
            //如果存在数组中则直接连接
            if([self.historyConnect containsObject:peripheral.identifier.UUIDString]){
                _autoConnect=false;
                //取消延迟器
                [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                         selector:@selector(checkHistoryConnect)
                                                           object:nil];
                //取消扫描
                [self.bluetoothManager stopEnumDevices];
                //开启连接
                [self.bluetoothManager openDevice:peripheral];
                [self showHUDByView:self.navigationController.view
                               type:MBProgressHUDModeIndeterminate info:@"正在连接"
                          hidenTime:0.0f];
                
            }
        }else{
            //保存扫描到的外设
            if(peripheral.name!=nil && RSSI !=nil){
                BOOL scanned=false;
                for (PeripheraItem *item in self.peripheraListItems) {
                    if([item.peripheral isEqual:peripheral]){
                        scanned=true;
                        item.RSSI=RSSI;
                        item.name=peripheral.name;
                        item.uuid=peripheral.identifier.UUIDString;
                        break;
                    }
                }
                //如果没有则保存
                if(scanned==false){
                    PeripheraItem *item= [[PeripheraItem alloc]init];
                    item.peripheral=peripheral;
                    item.name=peripheral.name;
                    item.RSSI=RSSI;
                    item.uuid=peripheral.identifier.UUIDString;
                    [self.peripheraListItems addObject:item];
                    _scanningView.scanningItems=self.peripheraListItems;
                }
            }
        }
         
    }
    
}

#pragma mark delegate 读配置视图
-(void)peripheralInfoViewDidReadConfig{
    _readConfigView = [[ReadConfigView alloc]init];
    _readConfigView.frame=self.view.bounds;
    _readConfigView.transferConfig=self.transferConfig;
    _readConfigView.delegate=self;
    [self.view addSubview:_readConfigView];
}
-(void)readConfigViewDidCancel{
    if(_readConfigView!=nil){
        [_readConfigView removeFromSuperview];
        _readConfigView=nil;
    }
}
-(void)readConfigViewDidSure:(TransferConfig *)cacheConfig{
    //保存配置
    _transferConfig=cacheConfig;
    //取消view
    if(_readConfigView!=nil){
        [_readConfigView removeFromSuperview];
        _readConfigView=nil;
    }
    //设置值
    self.peripheralInfoView.transferConfig=_transferConfig;
}


#pragma mark delegate 写配置视图
-(void)peripheralInfoViewDidWriteConfig{
    _writeConfigView = [[WriteConfigView alloc]init];
    _writeConfigView.frame=self.view.bounds;
    _writeConfigView.transferConfig=self.transferConfig;
    _writeConfigView.delegate=self;
    [self.view addSubview:_writeConfigView];
}
-(void)writeConfigViewDidCancel{
    if(_writeConfigView!=nil){
        [_writeConfigView removeFromSuperview];
        _writeConfigView=nil;
    }
}
-(void)writeConfigViewDidSure:(TransferConfig *)cacheConfig{
    if(cacheConfig.sendWay==3){
        if(cacheConfig.timer==0){
            [self showHUDByView:self.navigationController.view
                           type:MBProgressHUDModeText info:@"请先设置时间间隔"
                      hidenTime:1.0f];
            return;
        }
    }if(cacheConfig.sendWay==4){
        NSString *fileName=cacheConfig.fileName;
        if([NSString isBlankString:fileName]){
            [self showHUDByView:self.navigationController.view
                           type:MBProgressHUDModeText info:@"请输入文件名"
                      hidenTime:1.0f];
            return;
        }
        //判断文件是否存在
        NSString *filePath=[self writeFilePath:fileName];
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if (![defaultManager fileExistsAtPath:filePath]) {
            [self showHUDByView:self.navigationController.view
                           type:MBProgressHUDModeText info:@"文件不存在"
                      hidenTime:1.0f];
            return;
        }
    }
    _transferConfig=cacheConfig;
    if(_writeConfigView!=nil){
        [_writeConfigView removeFromSuperview];
        _writeConfigView=nil;
    }
    self.peripheralInfoView.transferConfig=cacheConfig;
}

#pragma mark 查看更多
-(void)clickMoreBtn{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"更多操作"
                                                                         message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *aboutusAction = [UIAlertAction actionWithTitle:@"关于我们"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        //展示详情
        WebShowViewController *webViewVC=[[WebShowViewController alloc]init];
        webViewVC.linkStr=Aboutus_URL;
        [self.navigationController pushViewController:webViewVC animated:YES];
    }];
    
//    NSString *title=self.windowDebug==true?@"监听模式":@"调试模式";
//    UIAlertAction *modelAction = [UIAlertAction actionWithTitle:title
//                                                      style:UIAlertActionStyleDefault
//                                                    handler:^(UIAlertAction * _Nonnull action) {
//        //展示详情
//        self.windowDebug=!self.windowDebug;
//        self.peripheralInfoView.windowDebug=self.windowDebug;
//    }];
//
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];

    [actionSheet addAction:aboutusAction];
   // [actionSheet addAction:modelAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];

}

#pragma mark 处理键盘高度变化
-(void)handleKeyBoardWillShow:(NSNotification *)data {
    NSString *durationStr=[data.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    float durationValue=[durationStr floatValue];
    NSValue *value = [data.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    float keyboardHeight = keyboardSize.height;
  //  NSLog(@"键盘高度发生变化:%@",sender.description);
    [UIView beginAnimations:@"ShowAni" context:nil];
    [UIView setAnimationDuration:durationValue];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _peripheralInfoView.frame=CGRectMake(0,-keyboardHeight+NavigationTopHeight, ScreenWidth, ScreenHeight);
    [UIView commitAnimations];
}


-(void)peripheralInfoViewDidClearRead{
    _readStartTime=0;
    _readEndTime=0;
    _readStatisLength=0;
    _readStartFlag=false;
    //清除保存的文件
    [self removeSaveFile];
}
-(void)peripheralInfoViewDidClearWrite{
    _sendStatisLength=0;
}

-(TransferConfig *)transferConfig{
    if(_transferConfig==nil){
        _transferConfig=[TransferConfig alloc];
        _transferConfig.enableSecure=1; //安全传输
        _transferConfig.showWay=3;//实时显示定时清除
        _transferConfig.sendWay=1;//单次发送
    }
    return _transferConfig;
}

#pragma mark 点击关闭键盘
-(void)tapCloseKeyBoard:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
    [self handleKeyBoardWillHiden:nil];
}
//键盘消失
-(void)handleKeyBoardWillHiden:(NSNotification *)data {
    [UIView beginAnimations:@"HidenAni" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    _peripheralInfoView.frame=CGRectMake(0, NavigationTopHeight, ScreenWidth, ScreenHeight-NavigationTopHeight);
    [UIView commitAnimations];
}
#pragma mark 连接外设
-(void)scanningViewDidConnent:(NSIndexPath *)indexPath{
    //获取外设
    PeripheraItem *peripheraItem=self.peripheraListItems[indexPath.row];
    CBPeripheral *peripheral=peripheraItem.peripheral;
    //发起连接
    [self.bluetoothManager openDevice:peripheral];
    //提醒
    [self showHUDByView:self.navigationController.view
                   type:MBProgressHUDModeIndeterminate info:@"正在连接"
              hidenTime:0.0f];
}

#pragma mark 连接回调
-(void)ch9140DidPeripheralConnectUpateState:(CBPeripheral *)peripheral error:(NSError *)error{
    switch (peripheral.state) {
        case CBPeripheralStateDisconnected:
            NSLog(@"CBPeripheralStateDisconnected");
            [self peripheralDisConnect];
            break;
        case CBPeripheralStateConnecting:
            NSLog(@"CBPeripheralStateConnecting");
            break;
        case CBPeripheralStateConnected:
            NSLog(@"CBPeripheralStateConnected");
            [self peripheralStateConnected:peripheral];
            break;
        case CBPeripheralStateDisconnecting:
            NSLog(@"CBPeripheralStateDisconnecting");
            break;
        default:
            NSLog(@"未知状态");
            break;
    }
}
//连接成功
-(void)peripheralStateConnected:(CBPeripheral *)peripheral{
    self.peripheral=peripheral;
    _connectBtn.selected=true;
    [self hidenHUDByTime:0.0f];
    [_scanningView removeFromSuperview];
    [self performSelector:@selector(synchSerialBaud) withObject:nil afterDelay:1];//同步波特率
    self.peripheralInfoView.enableState=true; //显示按钮状态
    //归档保存
    [self.historyConnect addObject:peripheral.identifier.UUIDString ];
    [ConnectUtil saveConnect:self.historyConnect];
}
-(NSMutableSet*)historyConnect{
    if(_historyConnect==nil){
        _historyConnect=[NSMutableSet set];
    }
    return _historyConnect;
}
#pragma mark 同步波特率
-(void)synchSerialBaud{
    [self resetSerialBaud];
    [self showHUDByView:self.navigationController.view
                   type:MBProgressHUDModeIndeterminate
                          info:@"开始同步波特率"
              hidenTime:0.0f];
    PeripheralInfoViewController *__selfBlock=self;
    [self.bluetoothManager setSerialBaud:self.serialBaudItem.baudRate
                                 dataBit:self.serialBaudItem.dataBit
                                 stopBit:self.serialBaudItem.stopBit
                                  parity:self.serialBaudItem.parity withBlock:^(Boolean returnValue, NSString *info) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            if(returnValue==true){
                [__selfBlock synchSerialModem];
                __selfBlock.peripheralInfoView.serialBaudItem=__selfBlock.serialBaudItem;//设置
            }else{
                [__selfBlock showHUDByView:__selfBlock.navigationController.view
                               type:MBProgressHUDModeText
                                      info:info
                          hidenTime:1.0f];
            }

        }];
    }];
}
#pragma mark 同步流控
-(void)synchSerialModem{
    [self resetSerialModem];
    [self showHUDByView:self.navigationController.view
                   type:MBProgressHUDModeIndeterminate
                          info:@"开始同步流控"
              hidenTime:0.0f];
    PeripheralInfoViewController *__selfBlock=self;
    [self.bluetoothManager setSerialModem:self.serialModemItem.flow
                                      dtr:self.serialModemItem.dtr
                                      rts:self.serialModemItem.rts
                                withBlock:^(Boolean returnValue, NSString *info) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            NSString *tipInfo=info;
            if(returnValue==true){
                tipInfo=@"同步流控成功";
            }
            [__selfBlock showHUDByView:__selfBlock.navigationController.view
                           type:MBProgressHUDModeText
                                  info:tipInfo
                      hidenTime:1.0f];
        }];
    }];
}

//设备断开连接
-(void)peripheralDisConnect{
    _connectBtn.selected=false;
    //显示按钮状态
    self.peripheralInfoView.enableState=false;
    self.peripheral=nil;
    _sendStatisLength=0; //发送统计长度
    _sendStartTime=0;//发送统计时间
    _sendEndTime=0;//发送统计开始时间
    _cancelWriteFlag=false;
    _readStatisLength=0;
    _readStartTime=0;
    _readEndTime=0;

    [self showHUDByView:self.navigationController.view
                   type:MBProgressHUDModeText info:@"蓝牙已断开请重新连接"
              hidenTime:2.0f];
}


-(SerialBaudItem*)serialBaudItem{
    if(_serialBaudItem==nil){
        _serialBaudItem=[[SerialBaudItem alloc]init];
        _serialBaudItem.baudRate=115200;
        _serialBaudItem.dataBit=8;
        _serialBaudItem.stopBit=1;
        _serialBaudItem.parity=0;
    }
    return _serialBaudItem;
}

//重置波特率
-(void)resetSerialBaud{
    self.serialBaudItem.baudRate=115200;
    self.serialBaudItem.dataBit=8;
    self.serialBaudItem.stopBit=1;
    self.serialBaudItem.parity=0;
}

-(SerialModemItem*)serialModemItem{
    if(_serialModemItem==nil){
        _serialModemItem=[[SerialModemItem alloc]init];
        _serialModemItem.flow=0;
        _serialModemItem.dtr=1;
        _serialModemItem.rts=1;
    }
    return _serialModemItem;
}

-(void)resetSerialModem{
    self.serialModemItem.flow=0;
    self.serialModemItem.dtr=1;
    self.serialModemItem.rts=1;
}

#pragma mark 创建管理器
-(CH9140BluetoothManager *)bluetoothManager{
    if(_bluetoothManager==nil){
        _bluetoothManager=[CH9140BluetoothManager shareManager];
        _bluetoothManager.delegate=self;
        _bluetoothManager.isDebug=true;
        NSLog(@"版本:%@", [self.bluetoothManager managerVersion]);
    }
    return _bluetoothManager;
}

#pragma mark 设备列表
-(NSMutableArray*)peripheraListItems{
    if(_peripheraListItems==nil){
        _peripheraListItems=[NSMutableArray array];
    }
    return _peripheraListItems;
}

-(PeripheralInfoView*)peripheralInfoView{
    if(_peripheralInfoView==nil){
        _peripheralInfoView=[[PeripheralInfoView alloc]init];
        _peripheralInfoView.frame=CGRectMake(0, NavigationTopHeight, ScreenWidth, ScreenHeight-NavigationTopHeight);
        _peripheralInfoView.delegate=self;
        [self.view addSubview:_peripheralInfoView];
    }
    return _peripheralInfoView;
}

#pragma mark 扫描的服务列表
-(void)peripheralInfoViewDidTipInfo:(NSString*)info{
    [self showHUDByView:self.navigationController.view
                   type:MBProgressHUDModeText info:info
              hidenTime:1.0f];
}

#pragma mark 分享日志文件
-(void)peripheralInfoViewDidReadShare{
    [self shareReadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark 读文件数据
-(NSData *)readFileData{
    NSData * data = nil;
    if ((self.totalPackage - self.currentPackage)>1) {//最后一次
        //将句柄移动到已读取内容的最后
        [self.readHandle seekToFileOffset:self.offset];
        //读取指定大小的内容（PackgeSize）
        data = [self.readHandle readDataOfLength:PackgeSize];
        //偏移量累加
        self.offset += PackgeSize;
        NSLog(@"读了：%@",data);
    }else if ((self.totalPackage - self.currentPackage)==1) {//最后一次
        //将句柄移动到已读取内容的最后
        [self.readHandle seekToFileOffset:self.offset];
        //从指定位置读到文件最后
        data = [self.readHandle readDataToEndOfFile];
        //偏移量累加
        self.offset += data.length;
        NSLog(@"读完了文件：%llu",self.offset);
    }else{
        //关闭读句柄
        NSLog(@"关闭句柄：%llu",self.offset);
        [self.readHandle closeFile];
        return nil;
    }
    self.currentPackage += 1;
    return data;
}

//向文件中写入数据
-(void)writeDataToFile:(NSData*)data{
    [self createSaveFile];
    [self.writeHandle seekToEndOfFile];
    [self.writeHandle writeData:data];//写数据
   // NSLog(@"写了：%@",data);
}

#pragma mark 创建保存文件
-(void)createSaveFile{
    NSString *filePath=[self writeFilePath:Save_File_Name];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:filePath]) {
        //创建文件
        [defaultManager createFileAtPath:filePath contents:nil attributes:nil];
        //创建文件句柄
        self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    }
}

#pragma mark 删除保存文件
-(void)removeSaveFile{
    //移除句柄
    if(self.writeHandle!=nil){
        [self.writeHandle closeFile];
        self.writeHandle=nil;
    }
    //删除文件
    NSString *filePath=[self writeFilePath:Save_File_Name];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager fileExistsAtPath:filePath]) {
        NSError *error;
        [defaultManager removeItemAtPath:filePath error:&error];
        if(error!=nil){
            [self showHUDByView:self.navigationController.view
                           type:MBProgressHUDModeText info:@"删除文件出错"
                      hidenTime:1.0f];
            return ;
        }
    }
}
//根据文件名获取文件路径
- (NSString *)writeFilePath:(NSString*)fileName{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *logFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    return logFilePath;
}

/// 通过社交app分享log文件
- (void)shareReadData {
    MFMailComposeViewController *mailcompose=[[MFMailComposeViewController alloc]init];
    mailcompose.mailComposeDelegate=self;
    //附件
    Boolean attached=false;
    NSString *fileName=_transferConfig.saveName;
    if(![NSString isBlankString:fileName]){
        NSString *filePath = [self writeFilePath:fileName];
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if ([defaultManager fileExistsAtPath:filePath]) {
            NSArray *components=[filePath componentsSeparatedByString:@"."];
            NSString *ext=[components lastObject];
            NSData *fdata=[[NSData alloc]initWithContentsOfFile:filePath];
            [mailcompose addAttachmentData:fdata mimeType:ext fileName:fileName];
            attached=true;
        }
    }
    //内容
    Boolean content=false;
    NSString *readData=[_peripheralInfoView getReadData];
    if(![NSString isBlankString:readData]){
        [mailcompose setMessageBody:readData isHTML:NO];
        content=true;
    }
    if(attached==false && content==false){
        [self showHUDByView:self.navigationController.view
                       type:MBProgressHUDModeText info:@"没有可以分享内容"
                  hidenTime:1.0f];
        return;
    }
    [self presentViewController:mailcompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:
            [self showHUDByView:self.navigationController.view
                           type:MBProgressHUDModeText info:@"发送成功"
                      hidenTime:1.0f];
            break;
        case MFMailComposeResultFailed:
            [self showHUDByView:self.navigationController.view
                           type:MBProgressHUDModeText info:@"发送失败"
                      hidenTime:1.0f];
            break;
        case MFMailComposeResultCancelled:
            [self showHUDByView:self.navigationController.view
                           type:MBProgressHUDModeText info:@"取消发送"
                      hidenTime:1.0f];
            break;
        case MFMailComposeResultSaved:
            [self showHUDByView:self.navigationController.view
                           type:MBProgressHUDModeText info:@"已保存"
                      hidenTime:1.0f];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark 扫描选项
-(NSDictionary*)scanOptions{
    if(_scanOptions==nil){
        _scanOptions=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber  numberWithBool:YES],
                      CBCentralManagerScanOptionAllowDuplicatesKey,nil];
    }
    return _scanOptions;
}

-(void)dealloc{
    if(self.writeHandle!=nil){
        [self.writeHandle closeFile];
        self.writeHandle=nil;
    }
    if(self.readHandle!=nil){
        [self.readHandle closeFile];
        self.readHandle=nil;
    }
}
@end
