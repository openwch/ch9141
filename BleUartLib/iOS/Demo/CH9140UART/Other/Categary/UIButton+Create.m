//
//  UIButton+Submit.m
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/25.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "UIButton+Create.h"
#import "Constant.h"

@implementation UIButton (Create)

+(instancetype)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:AppMainColor];
    button.layer.cornerRadius=4.0f;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark 订单按钮
+(instancetype)orderButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius=4.0f;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:AppMainColor forState:UIControlStateNormal];
    button.titleLabel.font=StandFont;
    [button.layer setCornerRadius:2];
    button.layer.masksToBounds = YES;
    button.layer.borderWidth=1.0f;
    button.layer.borderColor=AppMainColor.CGColor;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark 首页按钮
+(instancetype)homeButtonWithTarget:(id)target action:(SEL)action{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"comment_home"] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark 首页模块按钮
+(instancetype)homeBlockButtonWithTarget:(id)target action:(SEL)action{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"comment_home"] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


@end
