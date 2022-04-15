//
//  WLTabBarButton.m
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-10.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "WLTabBarButton.h"
#import "UIImage+Extension.h"
#import "WLBadgeButton.h"
#define TabBarButtonRatio 0.6
#define TabBarTitleColor  (WLColor(0,0,0))
#define TabBarSelectedTitleColor   (WLColor(234,103,7))
#define BadgeFont [UIFont systemFontOfSize:12.0]

@interface WLTabBarButton()
@property(nonatomic,weak)WLBadgeButton *badgeButton;
@end

@implementation WLTabBarButton

#pragma mark 系统自动调用
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        //设置属性
        self.imageView.contentMode=UIViewContentModeCenter;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:234 green:103 blue:7 alpha:1] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_slider" ] forState:UIControlStateSelected];
        self.backgroundColor=[UIColor whiteColor];
        
        //添加提示按钮
        WLBadgeButton *badgeButton=[[WLBadgeButton alloc]init];
        badgeButton.hidden=YES;
        badgeButton.userInteractionEnabled=NO;
        badgeButton.titleLabel.font=BadgeFont;
        
        //固定badge距离左右的距离
        //badgeButton.autoresizingMask=UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleBottomMargin;
        

       
        [self addSubview:badgeButton];
        self.badgeButton=badgeButton;
    }
    return self;
}

//设置badgeButton的frame
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //调用设置初始值
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];

}

//将按钮的数据封装到模型中
-(void)setItem:(UITabBarItem *)item{
    
     _item=item;
    
    //调用设置初始值
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
    //添加属性侦听
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    
}

/**
 *  侦听值发生改变的时候自动调用该方法
 *  @param keyPath  值改变的属性名称
 *  @param object   哪个对象的属性改变
 *  @param change   改变前后值分别是多少
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    //[self setTitle:self.item.title forState:UIControlStateNormal];
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
     //设置badgeValue
     self.badgeButton.badgeValue=self.item.badgeValue;
    CGFloat badge_x=self.frame.size.width/2;
    CGFloat badge_y=0;
    
    CGRect frame=self.badgeButton.frame;
    frame.origin.x=badge_x;
    frame.origin.y=badge_y;
    self.badgeButton.frame=frame;
    
}


#pragma mark 屏蔽系统的highlighted
-(void)setHighlighted:(BOOL)highlighted{

}

#pragma mark 重写父类方法 重新定义image的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat image_w=contentRect.size.width;
    CGFloat image_h=contentRect.size.height;
    return CGRectMake(0, 0, image_w, image_h);
}

//当前对象销毁的时候 移除当前对象的监听事件
-(void)dealloc{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
}

#pragma mark 重写父类方法 重新定义title的frame
//-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//    CGFloat title_w=contentRect.size.width;
//    CGFloat title_h=(1-TabBarButtonRatio)*contentRect.size.height;
//    CGFloat title_y=TabBarButtonRatio*contentRect.size.height;
//    return CGRectMake(0, title_y, title_w, title_h);
//}


@end
