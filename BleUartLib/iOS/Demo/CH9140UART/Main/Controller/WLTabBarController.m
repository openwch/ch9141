//
//  WLTabBarController.m
//  项目-新浪微博
//  自定义的 TabBarController
//

#import "WLTabBarController.h"
#import "UIImage+Extension.h"
#import "WLTabBar.h"
#import "WLNavigationController.h"
#import "MainTabBar.h"
#import "Constant.h"

#define MainTableBarHeight 50

@interface WLTabBarController()<MainTabBarDelegate>

@property(nonatomic,strong)NSMutableArray *childControllers;

@end

@implementation WLTabBarController

-(instancetype)init{
    if(self=[super init]){
        //隐藏tabbar
        self.tabBar.hidden=YES;
    }
    return self;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    //1.设置子控制器
    [self setViewControllers:self.childControllers];
    
    //2.创建自定义tabBar
    [self.view addSubview:self.mainTabBar];
    
}

#pragma mark 添加tabBar
-(MainTabBar *)mainTabBar{
    if (_mainTabBar==nil) {
        _mainTabBar=[[MainTabBar alloc]init];
        CGFloat bar_x=0;
        CGFloat bar_w=ScreenWidth;
        CGFloat bar_h=MainTableBarHeight;
        CGFloat bar_y=ScreenHeight-bar_h;
        _mainTabBar.delegate=self;
        _mainTabBar.frame=CGRectMake(bar_x,bar_y, bar_w, bar_h);
        _mainTabBar.backgroundColor=BottomToolBjColor;
    }
    return _mainTabBar;
}


#pragma mark 子控制器模型
-(NSArray *)childControllers{
    if (_childControllers==nil) {
        _childControllers=[NSMutableArray array];
        //工作
//        PeripheralListViewController *peripheralListVV=[[PeripheralListViewController alloc]init];
//        WLNavigationController *peripheralListNavi=[[WLNavigationController alloc]initWithRootViewController:peripheralListVV];
//    
//        
//        [_childControllers addObject:peripheralListNavi];

    }
    return _childControllers;
}

#pragma mark 代理:点击tabbar按钮的时候调用
-(void)tabbar:(MainTabBar *)tabbar didClickSwitch:(NSInteger)tag{
    switch ((long)tag) {
        case 1://工作
            self.selectedIndex=0;
            break;
        case 2://消息
            self.selectedIndex=1;
            break;
        case 3://我的
            self.selectedIndex=2;
            break;
        default:
            break;
    }
}




@end
