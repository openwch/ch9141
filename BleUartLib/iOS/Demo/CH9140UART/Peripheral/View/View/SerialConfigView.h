//
//  SerialConfigView.h
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
// 串口配置
//

#import <UIKit/UIKit.h>

@class SerialBaudItem,SerialModemItem;

@protocol SerialConfigViewDelegate<NSObject>
//配置流控
-(void)serialConfigViewDidModem:(SerialModemItem *)serialModemItem;
//取消配置
-(void)serialConfigViewDidCancel;
//保存配置
-(void)serialConfigViewDidSure:(SerialBaudItem*)serialBaudItem;
@end

@interface SerialConfigView : UIView

//代理
@property(nonatomic,assign)id<SerialConfigViewDelegate>delegate;
//波特率配置
@property(nonatomic,strong)SerialBaudItem *serialBaudItem;
//流控配置
@property(nonatomic,strong)SerialModemItem *serialModemItem;


@end
