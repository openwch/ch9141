//
//  SerialModemItem.h
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SerialModemItem : NSObject

#pragma mark 硬件串口自动流控开启  true=开启
@property (assign,nonatomic)Boolean flow;
#pragma mark 1 有效低电平  0无效高电平
@property (assign,nonatomic)NSInteger dtr;
#pragma mark 1 有效低电平  0无效高电平
@property (assign,nonatomic)NSInteger rts;

@end
