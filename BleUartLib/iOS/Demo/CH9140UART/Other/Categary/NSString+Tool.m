//
//  NSString+Tool.m
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-12.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

/**
 * 返回一个字符串在屏幕上尺寸的
 * @content  文字内容
 * @maxSize 允许的最大尺寸
 * @font 文字的尺寸
 */
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    if(maxSize.width==0 && maxSize.height==0 ){
      maxSize=CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    CGRect rect= [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
    return rect.size;
}

/**
 * 通过属性获取size
 */
-(CGSize)sizeWithAttributes:(NSDictionary *)attributes maxSize:(CGSize)maxSize{
    if(maxSize.width==0 && maxSize.height==0 ){
        maxSize=CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    CGRect rect= [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return rect.size;
}

/** 去掉字符串左右连续空格 */
-(NSString *)trimWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/** 过滤城市名字 */
+(NSString *)filterLocationCity:(NSString *)locationCity{
    
    //过滤直辖市
    NSArray *firstCitys=@[@"北京",@"天津",@"上海",@"重庆"];
    for (NSString *city in firstCitys) {
        NSRange range = [locationCity rangeOfString:city];
        if(range.length > 0){
            return city;
        }
    }
    //过滤其他城市
    NSRange range = [locationCity rangeOfString:@"市"];
    if(range.length > 0){
        return [locationCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    
    //直接返回
    return locationCity;
    
}

/** 过滤城市名字 */
+(NSString *)filterLocationCountry:(NSString *)country{
    
    //过滤中国
    NSRange rangeCountry = [country rangeOfString:@"中国"];
    if(rangeCountry.length > 0){
        country=[country stringByReplacingOccurrencesOfString:@"中国" withString:@""];
    }
    
    //过滤省
     NSRange cityRange = [country rangeOfString:@"省"];
    if(rangeCountry.length > 0){
        cityRange=NSMakeRange(0,cityRange.location+1);
        country=[country stringByReplacingCharactersInRange:cityRange withString:@""];
    }
    //直接返回
    return country;
    
}


@end