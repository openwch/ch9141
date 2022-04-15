//
//  WLRightImageButton.m
//  mypolygon
//
//  Created by 娟华 胡 on 15/7/2.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLRightImageButton.h"
#import "UIImage+Extension.h"
#import "NSString+Tool.h"
#import  "Constant.h"

#define RightIconWidth 15.0f

@implementation WLRightImageButton

+(instancetype)rightImageButton{
    return [[self alloc]init];
}

-(instancetype)init{
    if (self=[super init]) {
        
    }
    return self;
}

#pragma mark 设置image的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat imageW = RightIconWidth;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageY = 0;
    CGFloat imageX = contentRect.size.width-imageW;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

#pragma mark 设置titleLabel的Frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleX = 0;
    CGFloat titleW = contentRect.size.width-RightIconWidth;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

-(void)setHighlighted:(BOOL)highlighted{
    
}


@end
