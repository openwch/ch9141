//
//  WLNavigationController.m
//
//  Created by wangchunlei on 14-11-14.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "WLNavigationController.h"
#import "UIImage+Extension.h"
#import "Constant.h"
#import "WLTabBarController.h"

@interface WLNavigationController()
@property(nonatomic,strong)UIView *navieBarBorder;
@end

@implementation WLNavigationController

-(instancetype)init{
    if(self=[super init]){
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=LightGreyColor4;
    self.toolbarHidden=YES;
    self.hidesBottomBarWhenPushed=YES;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    WLTabBarController *tabBarVC=(WLTabBarController *)self.parentViewController;
    tabBarVC.hidesBottomBarWhenPushed=YES;
}


@end
