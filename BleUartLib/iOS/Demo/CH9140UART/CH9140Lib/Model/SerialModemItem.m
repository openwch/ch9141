//
//  SerialModemItem.m
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "SerialModemItem.h"

@implementation SerialModemItem

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
       
    }
    return self;
}

+(instancetype)dataWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

@end
