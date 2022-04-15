//
//  UIImage+Extension.h
//  QQ界面－01
//
//  Created by wangchunlei on 14-9-17.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+(UIImage *)resizableImage:(NSString *)name;
+(UIImage *)resizableImage:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
    
@end
