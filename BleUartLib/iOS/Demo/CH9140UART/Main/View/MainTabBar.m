//
//  MainTabBar.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "MainTabBar.h"
#import "Constant.h"

@interface MainTabBar(){
    
    UIButton *_communicatBtn;
    UIButton *_aboutusBtn;
    
}
@end
@implementation MainTabBar

#pragma mark 创建子控件
-(instancetype)init{
    if (self=[super init]) {
        
        //工作
        _communicatBtn=[[UIButton alloc]init];
        _communicatBtn.tag=1;
        [_communicatBtn setTitle:@"通信" forState:UIControlStateNormal];
        _communicatBtn.titleLabel.font=BlodStandFont;
        [_communicatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_communicatBtn setTitleColor:BottomToolBjColor forState:UIControlStateSelected];
        [_communicatBtn setBackgroundImage:[UIImage imageNamed:@"solidBlue"] forState:UIControlStateNormal];
        [_communicatBtn setBackgroundImage:[UIImage imageNamed:@"solidWhite"] forState:UIControlStateSelected];
        [_communicatBtn addTarget:self action:@selector(clickChangeButton:) forControlEvents:UIControlEventTouchUpInside];
        _communicatBtn.selected=YES;
        
        //消息
        _aboutusBtn=[[UIButton alloc]init];
        _aboutusBtn.tag=2;
        _aboutusBtn.titleLabel.font=BlodStandFont;
        [_aboutusBtn setTitle:@"关于" forState:UIControlStateNormal];
        [_aboutusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_aboutusBtn setTitleColor:BottomToolBjColor forState:UIControlStateSelected];
        [_aboutusBtn setBackgroundImage:[UIImage imageNamed:@"solidBlue"] forState:UIControlStateNormal];
        [_aboutusBtn setBackgroundImage:[UIImage imageNamed:@"solidWhite"] forState:UIControlStateSelected];
        [_aboutusBtn addTarget:self action:@selector(clickChangeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_communicatBtn];
        [self addSubview:_aboutusBtn];
        
    }
    return self;
}

#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_w=self.frame.size.width;
    CGFloat self_h=self.frame.size.height;
    
    //通信
    CGFloat communicat_x=0;
    CGFloat communicat_y=0;
    CGFloat communicat_w=round(self_w*0.5);
    CGFloat communicat_h=self_h;
    _communicatBtn.frame=CGRectMake(communicat_x, communicat_y, communicat_w, communicat_h);
    
    //关于按钮
    CGFloat aboutus_w=self_w-communicat_w;
    CGFloat aboutus_x=CGRectGetMaxX(_communicatBtn.frame);
    CGFloat aboutus_y=0;
    CGFloat aboutus_h=self_h;
    _aboutusBtn.frame=CGRectMake(aboutus_x, aboutus_y, aboutus_w, aboutus_h);
    _aboutusBtn.layer.cornerRadius=aboutus_w*0.5;
    
}

#pragma mark 点击切换按钮
-(void)clickChangeButton:(UIButton *)button{
    _communicatBtn.selected=NO;
    _aboutusBtn.selected=NO;
    button.selected=YES;
    if ([self.delegate respondsToSelector:@selector(tabbar:didClickSwitch:)]) {
        [self.delegate tabbar:self didClickSwitch:button.tag];
    }
}

@end
