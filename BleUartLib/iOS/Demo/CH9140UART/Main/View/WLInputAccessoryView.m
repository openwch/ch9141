//
//  WLInputToolBarView.m
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/24.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLInputAccessoryView.h"
#import "Constant.h"

@interface WLInputAccessoryView(){
    
    //确定按钮
    UIButton *_sureButton;
    //取消按钮
    UIButton *_cancelButton;
    //线条
    UIView *_topLine;
    UIView *_bottomLine;
    //标题
    UILabel *_titleLabel;
}

@end

@implementation WLInputAccessoryView

#pragma mark 根据view创建
-(instancetype)init{
    
    if (self=[super init]) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        //顶部线条
        _topLine=[[UIView alloc]init];
        _topLine.backgroundColor=LightGreyColor4;
        
        //底部线条
        _bottomLine=[[UIView alloc]init];
        _bottomLine.backgroundColor=AppMainColor;
        
        //确认按钮
        _sureButton =[[UIButton alloc]init];
        [_sureButton setBackgroundColor:AppMainColor];
        _sureButton.layer.cornerRadius=2;
        _sureButton.layer.masksToBounds=YES;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(clickSureButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //取消按钮
        _cancelButton =[[UIButton alloc]init];
        [_cancelButton setBackgroundColor:AppMainColor];
        _cancelButton.layer.cornerRadius=2;
        _cancelButton.layer.masksToBounds=YES;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //标题
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        
        [self addSubview:_topLine];
        [self addSubview:_bottomLine];
        [self addSubview:_sureButton];
        [self addSubview:_titleLabel];
        [self addSubview:_cancelButton];
    }
    return self;
}

#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_h=self.frame.size.height;
    CGFloat self_w=self.frame.size.width;
    
    //顶部线条
    _topLine.frame=CGRectMake(0, 0, self_w, 1);
    
    //底部线条
    _bottomLine.frame=CGRectMake(0, self_h-2, self_w, 2);
    
    //确认按钮
    CGFloat sure_w=50;
    CGFloat sure_h=26;
    CGFloat sure_x=20;
    CGFloat sure_y=(self_h-sure_h)/2;
    _sureButton.frame=CGRectMake(sure_x,sure_y, sure_w, sure_h);
    
    //取消按钮
    CGFloat cancel_w=50;
    CGFloat cancel_h=sure_h;
    CGFloat cancel_x=self_w-20-cancel_w;
    CGFloat cancel_y=(self_h-cancel_h)/2;
    _cancelButton.frame=CGRectMake(cancel_x,cancel_y, cancel_w, cancel_h);
    
    //设置标题的frame
    CGFloat title_h=sure_h;
    CGFloat title_x=CGRectGetMaxX(_sureButton.frame)+10;
    CGFloat title_y=(self_h-title_h)/2;
    CGFloat title_w=cancel_x-title_x-10;
    _titleLabel.frame=CGRectMake(title_x, title_y, title_w, title_h);
}

#pragma mark 点击确定
-(void)clickSureButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputAccessoryView:didClickSure:)]) {
        [self.delegate inputAccessoryView:self didClickSure:button];
    }
}

#pragma mark 点击取消
-(void)clickCancelButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputAccessoryView:didClickCancel:)]) {
        [self.delegate inputAccessoryView:self didClickCancel:button];
    }
}


@end
