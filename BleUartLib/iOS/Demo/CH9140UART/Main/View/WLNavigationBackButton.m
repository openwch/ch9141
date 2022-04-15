//
//  WLNavigationBackButton.m
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/25.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLNavigationBackButton.h"

@implementation WLNavigationBackButton

#pragma mark 类创建方法
+(instancetype)backButton{
    return [[self alloc]init];
}

#pragma mark 重写init
-(instancetype)init{
    if (self =[super init]) {
        self.adjustsImageWhenDisabled=NO;
        self.adjustsImageWhenHighlighted=NO;
        [self setImage:[UIImage imageNamed:@"navi_left"] forState:UIControlStateNormal];
        self.frame=CGRectMake(0, 0,50,36);
        self.imageView.contentMode=UIViewContentModeCenter;
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{
    return;
}


@end
