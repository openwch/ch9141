//
//  MainTabBar.h
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabBar;

@protocol MainTabBarDelegate <NSObject>

@optional

-(void)tabbar:(MainTabBar *)tabbar didClickSwitch:(NSInteger) tag;

@end

@interface MainTabBar : UIView

@property(nonatomic,weak)id<MainTabBarDelegate>delegate;

@end

