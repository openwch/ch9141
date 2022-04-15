//
//  TransferConfig.m
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "TransferConfig.h"

@implementation TransferConfig

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        _enableSecure=1; //安全传输
        _showWay=1;//实时显示
        _sendWay=1;//单次发送
    }
    return self;
}

+(instancetype)dataWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
