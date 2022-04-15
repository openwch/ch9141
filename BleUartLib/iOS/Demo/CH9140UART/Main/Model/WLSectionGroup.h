//
//  WLSettingGroup.h
//  00-ItcastLottery
//
//  Created by wangchunlei on 14-12-21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLSectionGroup : NSObject

/** 组头*/
@property(nonatomic,copy)NSString *header;
/** 组头高*/
@property (nonatomic, assign) float headHeight;
/** 组行*/
@property(nonatomic,strong)NSArray *items;
/** 组底*/
@property(nonatomic,copy)NSString *footer;
/** 组底高*/
@property (nonatomic, assign) float footHeight;


@end
