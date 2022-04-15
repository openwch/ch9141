//
//  WLTitleButton.m
//  children
//
//  Created by 娟华 胡 on 15/3/26.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLTitleButton.h"
#import "UIImage+Extension.h"
#import "NSString+Tool.h"

@implementation WLTitleButton

+(instancetype)titleButton{
    return [[self alloc]init];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.imageView.contentMode=UIViewContentModeCenter;
        self.titleLabel.font=[UIFont systemFontOfSize:12.0f];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        [self setTitleColor:[UIColor colorWithRed:80/225.0f green:80/255.f blue:80/255.f alpha:1.0f]
                   forState:UIControlStateNormal];
        
    }
    return self;
}

#pragma mark 设置image的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 5;
    CGFloat imageX = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height/2;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

#pragma mark 设置titleLabel的Frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height/2+5;
    CGFloat titleX = 0;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = 14;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(void)setHighlighted:(BOOL)highlighted{

}

@end
