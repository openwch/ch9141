//
//  NSString+Regex.m
//  正则处理
//
//  Created by wangchunlei on 14-11-12.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

/**
 * 是否为手机号码 是＝YES
 */
+(BOOL)isMobileNumber:(NSString *)string {
    NSString * regexMobile = @"(1[3|5|7|8|][0-9]{9})";
    NSPredicate * predicate= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexMobile];
    return [predicate evaluateWithObject:string];
}

/**
 * 是否为邮箱 是＝YES
 */
+(BOOL)isEmail:(NSString *)string {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

/**
 * 是否为固定电话 是＝YES
 */
+(BOOL)isPhoneNumber:(NSString *)string {
    NSString * regexPhone = @"[0-9]{8}|[0-9]{9}|[0-9]{10}|[0-9]{11}|[0-9]{12}";
    NSPredicate * predicate= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPhone];
    return [predicate evaluateWithObject:string];
}

/**
 * 判断某个字符串是否为空字符串
 */
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL || [string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
    
}

/**
 * 根据url中参数获取url中的值
 */
+(NSString *)getValueByKey:(NSString *)params withUrlParams:(NSString *)urlStr{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",params];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:urlStr options:0 range:NSMakeRange(0, [urlStr length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [urlStr substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"";
}




@end