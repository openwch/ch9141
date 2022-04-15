//
//  WLFieldItem.m
//  children
//
//  Created by 娟华 胡 on 15/3/10.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLEditFieldItem.h"

@implementation WLEditFieldItem

+(instancetype)dataWithTitle:(NSString *)titleValue placeHolder:(NSString *)holderValue mark:(NSString *)mark{
    WLEditFieldItem *editFieldItem=[[WLEditFieldItem alloc]init] ;
    editFieldItem.titleValue=titleValue;
    editFieldItem.holderValue=holderValue;
    editFieldItem.mark=mark;
    return editFieldItem;
}

+(instancetype)dataWithTitle:(NSString *)titleValue value:(NSString *)fieldValue placeHolder:(NSString *)holderValue mark:(NSString *)mark{
    WLEditFieldItem *editFieldItem=[self dataWithTitle:titleValue placeHolder:holderValue mark:mark];
    editFieldItem.fieldValue=fieldValue;
    return editFieldItem;
}

@end
