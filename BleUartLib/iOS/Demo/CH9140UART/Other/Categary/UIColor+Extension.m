//
//  UIColor+Extension.m
//  淘宝商城
//
//  Created by wangchunlei on 15-1-16.
//  Copyright (c) 2015年 wangchunlei. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


+ (UIColor *)randomColor{
    
    //生成随机色
    return [self colorWithRed:arc4random() %256 /255.0 green:arc4random() %256 /255.0 blue:arc4random() %256 /255.0 alpha:1];
}

@end
