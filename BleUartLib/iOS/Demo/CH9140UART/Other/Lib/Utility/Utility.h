//
//  Utility.h
//  children
//
//  Created by 娟华 胡 on 15/5/6.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key;
+(NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key;

@end
