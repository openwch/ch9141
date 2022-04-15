//
//  Base64.h
//  children
//
//  Created by 娟华 胡 on 15/5/6.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBase64 : NSObject

+(NSData *)decode:(NSString *)data;
+(NSString *)encode:(NSData *)data;

@end
