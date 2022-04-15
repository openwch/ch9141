//
//  FileHandleTool.m
//  TestAPlayerIOS
//
//  Created by chrise on 2018/3/14.
//  Copyright © 2018年 xlxmp. All rights reserved.
//

#import "FileHandleTool.h"
//包大小10KB
#define PackgeSize (1024*10)


@implementation FileHandleTool

#pragma mark 创建服务器写句柄
-(void)creatReadServerFileHandelFileName:(NSString*)fileName totalPackage:(NSUInteger)total
{
    
    //目标
    NSString * docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *destFile =[docpath stringByAppendingPathComponent:fileName];
    //创建文件
    [[NSFileManager defaultManager] createFileAtPath:destFile contents:nil attributes:nil];
    
    self.descHandle = [NSFileHandle fileHandleForWritingAtPath:destFile];
    
    
    self.offset = 0;
    
    self.totalPackage = total;
    self.currentPackage = 0;
    
}

#pragma mark 创建读本读句柄
-(void)creatReadLocalFileHandelName:(NSString*)filePath
{
    //创建读文件的句柄
    self.readHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    //用来记录偏移量
    self.offset = 0;
    //获取文件大小
    unsigned long long totalRet = [self.readHandle seekToEndOfFile];//返回文件大小
    
    //计算总包数
    self.totalPackage = (int)ceilf(totalRet*1.0/PackgeSize);
    self.currentPackage = 0;
}

#pragma mark 创建读写句柄
-(void)creatReadAndWriteFileHandelName:(NSString*)fileName
{
    
    //待复制的文件
    NSString  *path=  [[NSBundle mainBundle] pathForResource:@"ceshi" ofType:@"jpeg"];
    //创建读文件的句柄
    self.readHandle = [NSFileHandle fileHandleForReadingAtPath:path];//读到内存
    //目标路径
    NSString * docpath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *destFile =[docpath stringByAppendingPathComponent:fileName];
    //创建文件
    [[NSFileManager defaultManager] createFileAtPath:destFile contents:nil attributes:nil];
    //创建写文件的句柄
    self.descHandle = [NSFileHandle fileHandleForWritingAtPath:destFile];
    
    
    self.offset = 0;
    
    
    unsigned long long totalRet = [self.readHandle seekToEndOfFile];//返回文件大小
    //计算总包数
    self.totalPackage = (int)ceilf(totalRet/PackgeSize);
    self.currentPackage = 0;
}


#pragma mark 读数据
-(NSData *)readData{
    
    NSData * data = nil;
   
    if ((self.totalPackage - self.currentPackage)==1) {//最后一次
        //将句柄移动到已读取内容的最后
        [self.readHandle seekToFileOffset:self.offset];
        //从指定位置读到文件最后
        data = [self.readHandle readDataToEndOfFile];
        //关闭读句柄
        [self.readHandle closeFile];
        NSLog(@"读完了文件：%llu",self.offset);
    }else{
        //将句柄移动到已读取内容的最后
        [self.readHandle seekToFileOffset:self.offset];
        //读取指定大小的内容（PackgeSize）
        data = [self.readHandle readDataOfLength:PackgeSize];
        //偏移量累加
        self.offset += PackgeSize;
        NSLog(@"读了：%@",data);
        
    }
    self.currentPackage += 1;
    return data;
}

#pragma mark 写数据
-(void)writeDataWithData:(NSData*)data{

    //偏移量设置为目标文件的最后，要不然会覆盖原来的内容
    [self.descHandle seekToEndOfFile];
    //写数据
    [self.descHandle writeData:data];
    
    self.offset += data.length;
    NSLog(@"写了：%@",data);
    self.currentPackage += 1;
    if (self.currentPackage  == self.totalPackage) {
        [self.descHandle closeFile];
        NSLog(@"写完了");
    }
    
}


#pragma mark 读写数据
-(void)readAndWriteData{
    
    NSData * _data = nil;
    
    if ((self.totalPackage - self.currentPackage)==1) {
        [self.readHandle seekToFileOffset:self.offset];
        _data = [self.readHandle readDataToEndOfFile];
        
        //偏移量设置为目标文件的最后，要不然会覆盖原来的内容
        [self.descHandle seekToEndOfFile];
        //写数据
        [self.descHandle writeData:_data];
        [self.descHandle closeFile];
        [self.readHandle closeFile];
        
        
        NSLog(@"写完了：写入了文件：%llu",self.offset);
    }else{
        //大于1M的文件多次读写
        [self.readHandle seekToFileOffset:self.offset];
        
        _data = [self.readHandle readDataOfLength:PackgeSize];
        
        //偏移量设置为目标文件的最后，要不然会覆盖原来的内容
        [self.descHandle seekToEndOfFile];
        //写数据
        [self.descHandle writeData:_data];
        
        self.offset += PackgeSize;
        
        [self performSelector:@selector(readAndWriteData) withObject:nil afterDelay:1];
        NSLog(@"写入了文件：%llu",self.offset);
    }
    self.currentPackage += 1;
}



@end
