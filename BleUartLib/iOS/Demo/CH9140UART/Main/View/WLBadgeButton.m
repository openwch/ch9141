//
//  WLBadgeButton.m
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-13.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "WLBadgeButton.h"
#import "UIImage+Extension.h"
#import "NSString+Tool.h"

#define BadgeFont [UIFont systemFontOfSize:12.0]

@implementation WLBadgeButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.userInteractionEnabled=NO;
        //设置背景图片
        [self setBackgroundImage:[UIImage resizableImage:@"main_badge"] forState:UIControlStateNormal];
        
    }
    return self;
}

//重写badgeValue的set方法
-(void)setBadgeValue:(NSString *)badgeValue{
    
    //如果属性用的是copy那么这里要用copy获取
    _badgeValue=[badgeValue copy];
    
    //根据badge值判断是否要显示提示按钮
    if (badgeValue) {
        self.hidden=NO;
        [self setTitle:badgeValue forState:UIControlStateNormal];
        
        CGFloat badge_h=self.currentBackgroundImage.size.height;
        //设置frame 计算拉伸背景
        CGFloat badge_w=self.currentBackgroundImage.size.width;
        
        //如果提醒的字数超过1个才做拉伸尺寸处理
        if(badgeValue.length>1){
            //每次item有变化都要重新计算frame
            CGSize contentSize=[badgeValue sizeWithFont:BadgeFont maxSize:CGSizeMake(MAXFLOAT,0)];
            badge_w=contentSize.width+10;
        }
        //只修改自己的宽和高
        CGRect frame=self.frame;
        frame.size.width=badge_w;
        frame.size.height=badge_h;
        self.frame=frame;
        
    }else{
        self.hidden=YES;
    }

}

@end
