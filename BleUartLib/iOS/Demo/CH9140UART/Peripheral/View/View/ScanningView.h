//
//  ScanningView.h
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
// 串口配置
//

#import <UIKit/UIKit.h>


@class NSIndexPath;

@protocol ScanningViewDelegate<NSObject>
//配置流控
-(void)scanningViewDidConnent:(NSIndexPath *)indexPath;
//取消扫描
-(void)scanningViewDidCancel;
@end

@interface ScanningView : UIView

//代理
@property(nonatomic,assign)id<ScanningViewDelegate>delegate;
//扫描的列表
@property(nonatomic,strong)NSMutableArray *scanningItems;

@end
