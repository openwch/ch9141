//
//  WLTabBar.m
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-10.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "WLTabBar.h"
#import "UIImage+Extension.h"
#import "WLTabBarButton.h"

@interface WLTabBar()
@property(nonatomic,weak)WLTabBarButton *selectButton;
@property(nonatomic,strong)NSMutableArray *tabBarButtons;
@end

@implementation WLTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}

//懒加载获取数组
-(NSMutableArray *)tabBarButtons{
    if(_tabBarButtons==nil){
        _tabBarButtons=[NSMutableArray array];
    }
    return _tabBarButtons;
}

//调用一次在自定义的tabbar中添加一个按钮
//UITabBarItem 是UITabBar的模型
-(void)addTabBarButtonWithItem:(UITabBarItem *)item{

    WLTabBarButton *button=[[WLTabBarButton alloc]init];
    button.item=item;
    [self addSubview:button];
    
    //将按钮放入数组中用于处理
    [self.tabBarButtons addObject:button];
    
    //为按钮添加点击事件
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    
    //设置默认选中项
    if (self.tabBarButtons.count==1) {
        [self clickButton:button];
    }
}

//处理鼠标点击
-(void)clickButton:(WLTabBarButton *)button{
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(tabbar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabbar:self didSelectedButtonFrom:self.selectButton.tag to:button.tag];
    }
    
    //切换按钮
    self.selectButton.selected=NO;
    button.selected=YES;
    self.selectButton=button;

}

//设置button的frame
-(void)layoutSubviews{
    [super layoutSubviews];

    //设置按钮的frame
    NSInteger count=self.subviews.count;
    CGFloat button_w=self.frame.size.width/count;
    CGFloat button_h=self.frame.size.height;
    CGFloat button_y=0;
    for (int index=0; index<count; index++) {
        
        WLTabBarButton *button=[self.tabBarButtons objectAtIndex:index];
        button.tag=index;
        
        CGFloat button_x=index*button_w;
        
        button.frame=CGRectMake(button_x, button_y, button_w, button_h);
    }
}
@end
