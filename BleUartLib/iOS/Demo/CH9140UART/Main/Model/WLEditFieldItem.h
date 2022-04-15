//
//  WLFieldItem.h
//  children
//
//  Created by 娟华 胡 on 15/3/10.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLEditFieldItem : NSObject

@property(nonatomic,copy)NSString *titleValue;

@property(nonatomic,copy)NSString *fieldValue;

@property(nonatomic,copy)NSString *holderValue;
//标记
@property(nonatomic,copy)NSString *mark;

+(instancetype)dataWithTitle:(NSString *)titleValue value:(NSString *)fieldValue placeHolder:(NSString *)holderValue mark:(NSString *)mark;
+(instancetype)dataWithTitle:(NSString *)titleValue placeHolder:(NSString *)holderValue mark:(NSString *)mark;

@end
