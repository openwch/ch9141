//
//  WriteConfigView.h
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
// 传输配置
//

#import <UIKit/UIKit.h>

@class WriteConfigView,TransferConfig;

@protocol WriteConfigViewDelegate<NSObject>
//写入数据
-(void)writeConfigViewDidCancel;
-(void)writeConfigViewDidSure:(TransferConfig *)transferConfig;

@end

@interface WriteConfigView : UIView

//配置参数
@property(nonatomic,strong)TransferConfig *transferConfig;

//代理
@property(nonatomic,assign)id<WriteConfigViewDelegate>delegate;

@end
