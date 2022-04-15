//
//  UIBarButtonItem+Extension.m
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-15.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIImage+Extension.h"

@implementation UIBarButtonItem (Extension)

+(instancetype)itemWithImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)action{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    button.bounds=CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+(instancetype)itemWithImage:(NSString *)normalImage target:(id)target action:(SEL)action{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted=NO;
    button.bounds=CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

@end
