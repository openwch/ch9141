//
//  CharacteristicReadWriteView.h
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class CharacteristicReadWriteView;

@protocol CharacteristicReadWriteViewDelegate<NSObject>
//写入数据
-(void)characteristic:(CharacteristicReadWriteView *)writeReadView didWriteData:(NSData *)data withTime:(double)interval;
-(void)characteristicDidRead:(CharacteristicReadWriteView *)writeReadView;
-(void)characteristicDidCancelWrite:(CharacteristicReadWriteView *)writeReadView;
-(void)characteristicSetNotify:(BOOL)isNotify;

@end

@interface CharacteristicReadWriteView : UIView

//代理
@property(nonatomic,assign)id<CharacteristicReadWriteViewDelegate>delegate;
//特征
@property(nonatomic,strong)CBCharacteristic *readCharacteristic;
@property(nonatomic,strong)CBCharacteristic *writeCharacteristic;
@property(nonatomic,strong) UIButton *sendDataBtn;

-(void)staticWriteLength:(NSInteger)wirteLength withTime:(NSInteger)statisSecond;

//统计结果
#pragma mark 设置读取统计结果
-(void)resetReadStatisLabel:(NSString *)info;
#pragma mark 设置读取的值
-(void)appendReadData:(NSData *)value;

@end
