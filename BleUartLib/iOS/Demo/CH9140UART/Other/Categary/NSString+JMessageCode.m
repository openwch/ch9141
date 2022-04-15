//
//  NSString+JMessageCode.m
//  Created by wangchunlei on 14-11-12.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "NSString+JMessageCode.h"

@implementation NSString (Tool)

#pragma mark 根据code查找提示信息
+(NSString *)fetchInfoByCode:(NSInteger)code{
    NSString *info=nil;
    switch (code) {
        case 898000:
            info=@"内部错误";
            break;
        case 898001:
            info=@"用户已存在";
            break;
        case 898007:
            info=@"校验信息为空";
            break;
        case 899001:
            info=@"用户已存在!";
            break;
        case 810001:
            info=@"目标群组ID不存在!";
            break;
        case 899002:
            info=@"用户不存在!";
            break;
        case 801003:
            info=@"登录的用户名未注册，登录失败!";
            break;
        case 898004:
            info=@"更新密码操作，用户密码错误!";
            break;
        case 801005:
            info=@"登录的用户设备有误，登录失败!";
            break;
        case 801006:
            info=@"该用户被禁用!";
            break;
        case 863004:
            info=@"用户没有登录!";
            break;
        default:
            break;
    }
    return info;
}


@end
