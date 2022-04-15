//
//  StringUtils.h
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/19.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

//测速
+(NSData *)testSpeedRandom;
//格式化字节尺寸
+(NSString *) formatByteSize:(NSInteger)size;
//判断是否位hex字符串
+(Boolean) isHex:(NSString *)info;
@end
