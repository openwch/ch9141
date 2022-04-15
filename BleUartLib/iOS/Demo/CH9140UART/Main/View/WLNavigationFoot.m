//
//  WLNavigationFoot.m
//  自定义NavigationController
//
//  Created by 娟华 胡 on 15/6/1.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLNavigationFoot.h"
#import "Constant.h"

@interface WLNavigationFoot()

@property(nonatomic,strong)UILabel *title1Label;
@property(nonatomic,strong)UILabel *title2Label;
@property(nonatomic,strong)UIButton *scroeButton;

@property(nonatomic,strong)UIView *topLine;

@property(nonatomic,strong)NSMutableArray *buttonArray;

@end

@implementation WLNavigationFoot

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=RGBA(255, 255, 255, 0.1);
        //顶部线条
        _topLine=[[UIView alloc]init];
        _topLine.backgroundColor=RGB(157, 203, 203);
        
        [self addSubview:_topLine];
    }
    return self;
}

#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_w=self.frame.size.width;
    CGFloat self_h=self.frame.size.height;
    //顶部线条
    CGFloat line_x=0;
    CGFloat line_y=0;
    CGFloat line_w=self_w;
    CGFloat line_h=1;
    _topLine.frame=CGRectMake(line_x, line_y, line_w, line_h);
    
    //按钮
    NSInteger count=self.buttonArray.count;
    CGFloat btn_y=0;
    CGFloat btn_w=self_w/count;
    CGFloat btn_h=self_h;
    NSInteger index=0;
    for (UIButton *button in self.buttonArray) {
        CGFloat btn_x=btn_w*index;
        button.frame=CGRectMake(btn_x, btn_y, btn_w, btn_h);
        index++;
    }
}

#pragma mark 点击按钮 通知代理
-(void)clickBottomButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationFoot:didClickButton:)]) {
        [self.delegate navigationFoot:self didClickButton:button];
    }
}

#pragma mark 懒加载数组
-(NSMutableArray *)buttonArray{
    if (_buttonArray==nil) {
        _buttonArray=[NSMutableArray array];
    }
    return _buttonArray;
}

@end
