//
//  WLNavigationFoot.h
//  自定义NavigationController
//
//  Created by 娟华 胡 on 15/6/1.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLNavigationFoot;

@protocol WLNavigationFootDelegate <NSObject>
-(void)navigationFoot:(WLNavigationFoot *)navigationFoot didClickButton:(UIButton *)button;

@end

@interface WLNavigationFoot : UIView

@property(nonatomic,assign)id<WLNavigationFootDelegate>delegate;


@end