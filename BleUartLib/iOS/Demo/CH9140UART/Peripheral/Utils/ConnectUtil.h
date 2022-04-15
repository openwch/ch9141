//
//  ConnectUtil.h
//  WchBlue
//
//  Created by 娟华 胡 on 2018/10/19.
//  Copyright © 2018年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectUtil : NSObject

+(void)saveConnect:(NSSet *)uuids;
+(BOOL)deleteConnect;
+(NSSet *)getConnect;

@end
