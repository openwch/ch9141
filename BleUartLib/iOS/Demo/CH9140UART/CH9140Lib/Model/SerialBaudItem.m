//
//  SerialBaudItem.m
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "SerialBaudItem.h"

@implementation SerialBaudItem

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        self.baudRate=112500;
        self.dataBit=8;
        self.stopBit=1;
        self.parity=0;
    }
    return self;
}

+(instancetype)dataWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}


@end
