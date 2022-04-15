//
//  UIBarButtonItem+Extension.h
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-15.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+(instancetype)itemWithImage:(NSString *)normalImage target:(id)target action:(SEL)action;
+(instancetype)itemWithImage:(NSString *)normalImage highlightImage:(NSString *)highlightImage target:(id)target action:(SEL)action;

@end
