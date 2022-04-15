//
//  WLSettingItem.m
//  00-ItcastLottery
//
//  Created by wangchunlei on 14-12-21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "WLSectionItem.h"

@implementation WLSectionItem

+(instancetype)itemWithViewClass:(Class)viewClass{
    
    WLSectionItem *item=[[self alloc]init];
    item.viewClass=viewClass;
    return item;
}

+(instancetype)itemWithViewClass:(Class)viewClass
                          height:(CGFloat)height{
    
    WLSectionItem *item=[[self alloc]init];
    item.viewClass=viewClass;
    item.height=height;
    return item;
}

+(instancetype)itemWithViewClass:(Class)viewClass
                          target:(id)target
                          action:(SEL)action{
    
    WLSectionItem *item=[[self alloc]init];
    item.viewClass=viewClass;
    item.action=action;
    item.target=target;
    
    return item;
}

+(instancetype)itemWithViewClass:(Class)viewClass
                          target:(id)target
                          action:(SEL)action
                          height:(CGFloat)height{
    
    WLSectionItem *item=[self itemWithViewClass:viewClass target:target action:action];
    item.height=height;
    return item;
}


@end
