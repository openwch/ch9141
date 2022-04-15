//
//  PeripheralInfoView.h
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PeripheralInfoView,TransferConfig,ModemNotifyItem,SerialBaudItem;

@protocol PeripheralInfoViewDelegate<NSObject>
//写入数据
-(void)peripheralInfoViewDidRepeatWrite:(NSData *)data;
-(void)peripheralInfoViewDidOnceWrite:(NSData *)data;
-(void)peripheralInfoViewDidWriteFile;
//取消写入
-(void)peripheralInfoViewDidCancelWrite;
//分享
-(void)peripheralInfoViewDidReadShare;
//点击清除按钮
-(void)peripheralInfoViewDidClearRead;
-(void)peripheralInfoViewDidClearWrite;
//点击配置串口
-(void)peripheralInfoViewDidClickUptBtn;
//读配置
-(void)peripheralInfoViewDidReadConfig;
-(void)peripheralInfoViewDidWriteConfig;
//提示信息
-(void)peripheralInfoViewDidTipInfo:(NSString *)info;


@end

@interface PeripheralInfoView : UIView

//代理
@property(nonatomic,assign)id<PeripheralInfoViewDelegate>delegate;
//配置参数
@property(nonatomic,strong)TransferConfig *transferConfig;
@property(nonatomic,strong)ModemNotifyItem *modemNotifyItem;
//波特率配置
@property(nonatomic,strong)SerialBaudItem *serialBaudItem;
//可用状态
@property(nonatomic,assign)Boolean enableState;
//统计发送结果
-(void)staticWriteLength:(NSInteger)wirteLength withTime:(NSTimeInterval)second;
//统计读取结果
-(void)staticReadLength:(NSInteger)readLength withTime:(NSTimeInterval)second;
//写入读取的数据
-(void)appendReadData:(NSData *)value;
//获取读取的数据
-(NSString*)getReadData;
//窗口显示模式
@property(nonatomic,assign)Boolean windowDebug;

@end
