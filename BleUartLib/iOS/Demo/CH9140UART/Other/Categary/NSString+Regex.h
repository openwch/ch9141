//
//  NSString+Regex.h
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-12.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Regex)

+ (BOOL) isMobileNumber:(NSString *)string;
+ (BOOL) isPhoneNumber:(NSString *)string;
+ (BOOL) isEmail:(NSString *)string;
+ (BOOL) isBlankString:(NSString *)string;
+(NSString *)getValueByKey:(NSString *)params withUrlParams:(NSString *)urlStr;
@end




