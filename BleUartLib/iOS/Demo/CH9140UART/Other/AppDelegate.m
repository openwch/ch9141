//
//  AppDelegate.m
//  CH9140UART
//
//  Created by 娟华 胡 on 2020/10/13.
//  Copyright © 2020 娟华 胡. All rights reserved.
//

#import "AppDelegate.h"
#import "WLNavigationController.h"
#import "WLNewfeatureViewController.h"
#import "PeripheralInfoViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置状态栏
    application.statusBarStyle = UIStatusBarStyleLightContent;
    application.statusBarHidden=NO;
    
    //初始化窗口
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [self isShowNewfeature];
        

    
    return YES;
}

#pragma mark 判断是否显示新特性
-(void)isShowNewfeature{
    
    //获取归档的版本号
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *lastVersion=[defaults stringForKey:@"CFBundleVersion"];
    
    //获取系统plist数据中的版本号
    NSString *currentVersion=[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    //显示tabBar
    if ([lastVersion isEqualToString:currentVersion]) {
            PeripheralInfoViewController *peripheralVC=[[PeripheralInfoViewController alloc]init];
            WLNavigationController *peripheralNavi=[[WLNavigationController alloc]initWithRootViewController:peripheralVC];
            self.window.rootViewController=peripheralNavi;
    }else{
        //显示版本新特性
        self.window.rootViewController=[[WLNewfeatureViewController alloc]init];;
        //将版本号归档
        [defaults setObject:currentVersion forKey:@"CFBundleVersion"];
        [defaults synchronize];
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
