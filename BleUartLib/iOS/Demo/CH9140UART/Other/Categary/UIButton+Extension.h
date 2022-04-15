//
//  UIButton+Extension.h
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/23.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

#pragma mark 根据状态设置背景颜色
-(void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end
