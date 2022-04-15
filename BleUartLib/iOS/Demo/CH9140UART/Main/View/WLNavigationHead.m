//
//  WLNavigationHead.m
//  自定义NavigationController
//
//  Created by 娟华 胡 on 15/6/1.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLNavigationHead.h"
#import "Constant.h"
#define NaviHeadTopPadding  10.0f
#define NaviHeadLeftPadding  10.0f

@interface WLNavigationHead(){
    
    //背景
    UIImageView *_maskView;
    //view
    UIView *_titleView;
    UIView *_leftView;
    UIView *_rightView;
}

@end

@implementation WLNavigationHead

#pragma mark 根据view创建
-(instancetype)initWithTitleView:(UIView *)titleView leftView:(UIView *)leftView rightView:(UIView *)rightView{

    if (self=[super init]) {
        
        //背景遮罩
        _maskView=[[UIImageView alloc]init];
        //[_maskView setImage:[UIImage imageNamed:@"navigation_bj" ]];
        _maskView.backgroundColor=AppMainColor;
        _maskView.layer.masksToBounds=YES;
        [self addSubview:_maskView];
        
        //标题view
        if (titleView) {
            _titleView=titleView;
            [self addSubview:_titleView];
        }
        
        //左侧view
        if (leftView) {
            _leftView=leftView;
            [self addSubview:_leftView];
        }
        
        //右侧view
        if (rightView) {
            _rightView=rightView;
            [self addSubview:_rightView];
        }
    
    }
    return self;
}

#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_h=self.frame.size.height;
    CGFloat self_w=self.frame.size.width;
    
    //设置遮罩位置
    _maskView.frame=self.bounds;
    
    //设置左侧View
    if (_leftView) {
        CGRect temp=_leftView.frame;
        CGFloat leftView_w=temp.size.width;
        CGFloat leftView_h=temp.size.height;
        
        //如果有子视图
        CGFloat maxW=0.0f;
        NSArray *childs=_leftView.subviews;
        if(childs.count>0){
            for (UIView *child in childs) {
                UIView *lastChild=childs.lastObject;
                if([child isEqual:lastChild]){
                    maxW=CGRectGetMaxX(lastChild.frame);
                }
            }
        }
        if (leftView_w==0 && maxW==0) {
            leftView_w=NaviHeadButtonWidth;
            leftView_h=NaviHeadButtonHeight;
        }else if(maxW!=0){
            leftView_w=maxW;
            leftView_h=NaviHeadButtonHeight;
        }
        CGFloat leftView_y=(self_h-leftView_h)/2+NaviHeadTopPadding;
        CGFloat leftView_x=NaviHeadLeftPadding;
        _leftView.frame=CGRectMake(leftView_x, leftView_y, leftView_w,leftView_h);
    }
    
    //设置右按View
    if (_rightView) {
        CGRect temp=_rightView.frame;
        //设置宽度和高度
        CGFloat rightView_w=temp.size.width;
        CGFloat rightView_h=temp.size.height;
        if (rightView_w==0) {
            rightView_w=NaviHeadButtonWidth;
            rightView_h=NaviHeadButtonHeight;
        }
        CGFloat rightView_y=(self_h-rightView_h)/2+NaviHeadTopPadding;
        CGFloat rightView_x=self_w-rightView_w-NaviHeadLeftPadding;
        _rightView.frame=CGRectMake(rightView_x, rightView_y, rightView_w,rightView_h);
    }
    
    //标题位置
    if (_titleView) {
        
        //左侧和右侧距离
        CGFloat left_margin=0.0f;
        CGFloat right_margin=0.0f;
        if(_leftView) {
           left_margin=CGRectGetMaxX(_leftView.frame);
        }else if(_rightView) {
           right_margin=self_w-CGRectGetMaxX(_rightView.frame);
        }
        //哪个大用哪个margin
        CGFloat title_margin=left_margin>right_margin?left_margin:right_margin;
        
        //计算尺寸
        CGFloat title_w=self_w-(title_margin+NaviHeadLeftPadding)*2;
        CGFloat title_h=26;
        CGFloat title_y=(self_h-title_h)/2+NaviHeadTopPadding;
        CGFloat title_x=title_margin+NaviHeadLeftPadding;
        _titleView.frame=CGRectMake(title_x, title_y, title_w, title_h);
    }
}

#pragma mark 设置背景透明度
-(void)setMaskAlpah:(CGFloat)value{
    _maskView.alpha=value;
}

#pragma mark 设置背景
-(void)setMaskBj:(NSString *)bj{
    //_maskView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:bj]];
}


@end
