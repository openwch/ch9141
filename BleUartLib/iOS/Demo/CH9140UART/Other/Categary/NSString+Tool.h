//
//  NSString+Tool.h
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-12.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString(Tool)

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
-(CGSize)sizeWithAttributes:(NSDictionary *)attributes maxSize:(CGSize)maxSize;

+(NSString *)filterLocationCity:(NSString *)locationCity;
+(NSString *)filterLocationCountry:(NSString *)country;

@end




