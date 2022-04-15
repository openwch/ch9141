//
//  ConnectUtil.m
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/19.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import "ConnectUtil.h"

#define ConnectFile @"connect.data"

@implementation ConnectUtil

//归档账号信息
+(void)saveConnect:(NSSet *)uuids{
    NSString *doc=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *file=[doc stringByAppendingPathComponent:ConnectFile];
    [NSKeyedArchiver archiveRootObject:uuids toFile:file];
}

//解档账号信息
+(NSSet *)getConnect{
    NSString *doc=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path=[doc stringByAppendingPathComponent:ConnectFile];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

//删除账号信息
+(BOOL)deleteConnect{
    NSString *doc=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *file=[doc stringByAppendingPathComponent:ConnectFile];
    BOOL isExists=[[NSFileManager defaultManager] fileExistsAtPath:file];
    if (isExists) {
        BOOL isSuccess= [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        if(isSuccess){
            return YES;
        }
        return NO;
    }else{
        return NO;
    }
}
@end
