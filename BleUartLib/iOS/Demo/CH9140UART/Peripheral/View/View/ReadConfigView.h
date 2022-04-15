//
//  ReadConfigView.h
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
// 传输配置
//

#import <UIKit/UIKit.h>

@class TransferConfig;

@protocol ReadConfigViewDelegate<NSObject>
//写入数据
-(void)readConfigViewDidCancel;
-(void)readConfigViewDidSure:(TransferConfig *)transferConfig;

@end

@interface ReadConfigView : UIView

//配置参数
@property(nonatomic,strong)TransferConfig *transferConfig;

//代理
@property(nonatomic,assign)id<ReadConfigViewDelegate>delegate;

@end
