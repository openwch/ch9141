//
//  WLNoLoginView.m
//  children
//
//  Created by 娟华 胡 on 15/4/14.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLNoticeView.h"
#import "UIImage+Extension.h"
#import "NSString+Tool.h"
#import "NSString+Regex.h"
#import "Constant.h"

@interface WLNoticeView(){
    /** 重新加载 */
    UIButton *_reloadButton;
    /** 图标 */
    UIImageView *_iconImage;
    /** 提示信息 */
    UILabel *_remindLabel;
}

@end

@implementation WLNoticeView

#pragma mark 类创建方法
+(instancetype) noticeView{
    WLNoticeView *noticeView=[[WLNoticeView alloc]init];
    return noticeView;
}

#pragma mark 创建子控件
-(instancetype)init{
    if (self=[super init]) {
        
        //图标
        _iconImage=[[UIImageView alloc]init];
        _iconImage.contentMode=UIViewContentModeScaleAspectFit;
        
        //提示信息
        _remindLabel=[[UILabel alloc]init];
        _remindLabel.textAlignment=NSTextAlignmentCenter;
        _remindLabel.textColor=LightGreyColor;
        _remindLabel.font=StandFont;
        
        //按钮
        _reloadButton=[[UIButton alloc]init];
        _reloadButton.layer.masksToBounds=YES;
        _reloadButton.layer.borderColor=LightGreyColor3.CGColor;
        _reloadButton.layer.cornerRadius=5.0f;
        _reloadButton.layer.borderWidth=1.0f;
        _reloadButton.titleLabel.font=MiddleFont;
        [_reloadButton setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(clickReloadButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_reloadButton];
        [self addSubview:_iconImage];
        [self addSubview:_remindLabel];
        
    }
    return self;
}

#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_w=self.frame.size.width;
    CGFloat self_h=self.frame.size.height;
    
    //提醒消息
    CGFloat remind_h=50;
    CGFloat remind_w=ScreenWidth;
    CGFloat remind_x=(self_w-remind_w)*0.5;
    CGFloat remind_y=(self_h-remind_h)*0.5;
    _remindLabel.frame=CGRectMake(remind_x, remind_y, remind_w, remind_h);
    
    //图标
    CGFloat icon_w=100;
    CGFloat icon_h=100;
    CGFloat icon_x=(self_w-icon_w)*0.5;
    CGFloat icon_y=remind_y-icon_h;
    _iconImage.frame=CGRectMake(icon_x, icon_y, icon_w, icon_h);
    
    //按钮
    CGFloat reload_h=36;
    CGFloat reload_w=120;
    CGFloat reload_x=(self_w-reload_w)/2;
    CGFloat reload_y=CGRectGetMaxY(_remindLabel.frame);
    _reloadButton.frame=CGRectMake(reload_x, reload_y, reload_w, reload_h);
}

#pragma mark 设置图标
-(void)setIcon:(NSString *)icon{
    if (![NSString isBlankString:icon]) {
         _iconImage.image=[UIImage imageNamed:icon];
         _iconImage.hidden=NO;
    }else{
         _iconImage.hidden=YES;
    }
}

#pragma mark 按钮标题
-(void)setTitle:(NSString *)title{
    
    if (![NSString isBlankString:title]) {
        [_reloadButton setTitle:title forState:UIControlStateNormal];
        _reloadButton.hidden=NO;
    }else{
        _reloadButton.hidden=YES;
    }
}

#pragma mark 提示信息
-(void)setInfo:(NSString *)info{
    if (![NSString isBlankString:info]) {
        _remindLabel.text=info;
        _remindLabel.hidden=NO;
    }else{
        _remindLabel.hidden=YES;
    }
}

#pragma mark 重新加载
- (void)clickReloadButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(noticeViewDidClickButton:)]) {
        [self.delegate noticeViewDidClickButton:self];
    }
}


@end
