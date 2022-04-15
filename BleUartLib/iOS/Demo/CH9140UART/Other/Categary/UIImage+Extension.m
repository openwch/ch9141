//
//  UIImage+Extension.m
//  QQ界面－01
//
//  Created by wangchunlei on 14-9-17.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/**
 *返回一个可以拉伸的图片
 * @name 图片名称
 */
+(UIImage *)resizableImage:(NSString *)name{
    return [self resizableImage:name left:0.5 top:0.5];
}

/**
 *返回一个可以拉伸的图片
 * 自定义拉伸位置
 */
+(UIImage *)resizableImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * left;
    CGFloat h = normal.size.height * top;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}


@end
