//
//  WLTabBar.h
//  项目-新浪微博
//
//  Created by wangchunlei on 14-11-10.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLTabBar;
@protocol WLTabBarDelegate <NSObject>

@optional

-(void)tabbar:(WLTabBar *)tabbar didSelectedButtonFrom:(NSInteger) from to:(NSInteger)to;

@end

@interface WLTabBar : UIView

@property(nonatomic,weak)id<WLTabBarDelegate>delegate;

-(void)addTabBarButtonWithItem:(UITabBarItem *)item;

@end
