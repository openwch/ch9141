//
//  FileHandleTool.h
//  TestAPlayerIOS
//
//  Created by chrise on 2018/3/14.
//  Copyright © 2018年 xlxmp. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FileHandleTool : NSObject

//读句柄
@property (strong, nonatomic) NSFileHandle * readHandle;
//写句柄
@property (strong, nonatomic) NSFileHandle *descHandle;
//句柄偏移量
@property (assign, nonatomic) unsigned long long offset;

//总包数
@property (assign, nonatomic) NSUInteger totalPackage;

//当前包数
@property (assign, nonatomic) NSUInteger currentPackage;

@property (strong, nonatomic) NSString *checksum;

#pragma mark 读数据
-(NSData *)readData;
#pragma mark 读写数据
-(void)readAndWriteData;
#pragma mark 写数据
-(void)writeDataWithData:(NSData*)data;

#pragma mark 创建服务器写句柄
-(void)creatReadServerFileHandelFileName:(NSString*)fileName totalPackage:(NSUInteger)total;
#pragma mark 创建读本读句柄
-(void)creatReadLocalFileHandelName:(NSString*)filePath;
#pragma mark 创建读写句柄
-(void)creatReadAndWriteFileHandelName:(NSString*)fileName;

@end
