//
//  UIButton+Submit.h
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/25.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)
/**
 *创建提交按钮
 */
+(instancetype)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *创建订单按钮
 */
+(instancetype)orderButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 *创建navi右侧首页按钮
 */
+(instancetype)homeButtonWithTarget:(id)target action:(SEL)action;
@end
