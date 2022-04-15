//
//  SendConfigItem.m
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "SendConfigItem.h"

@implementation SendConfigItem

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        if (dict[@"name"]) {
            [self setValue:dict[@"name"] forKey:@"name"];
        }
        if (dict[@"value"]) {
            [self setValue:dict[@"value"] forKey:@"value"];
        }
    }
    return self;
}

+(instancetype)dataWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}


@end
