//
//  TransferConfig.h
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TransferConfig : NSObject

//开启安全传输
@property (assign,nonatomic)Boolean enableSecure;
//接收方式 1=实时显示  2=保存到文件
@property (assign,nonatomic)NSInteger showWay;
@property (copy,nonatomic)NSString *saveName;
//发送配置 1=单次发送 2=连续发送 3= 定时发送  4=发送文件
@property (assign,nonatomic)NSInteger sendWay;
//定时发送的间隔时间毫秒
@property (assign,nonatomic)NSInteger timer;
//从文件发送
@property (copy,nonatomic)NSString *fileName;

@end
