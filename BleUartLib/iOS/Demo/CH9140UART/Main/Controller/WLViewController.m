//
//  WLViewController.h.h
//  封装底层UIViewController
//

#import "WLViewController.h"
#import "Reachability.h"
#import "WLTabBarController.h"
#import "MainTabBar.h"

@interface WLViewController ()<WLNoticeViewDelegate>

//网络连接
@property (nonatomic,strong) Reachability *hostReachability;

@end

@implementation WLViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //判断子控制器个数
    NSArray *childVCs=self.navigationController.childViewControllers;
    WLTabBarController *tabBarController=(WLTabBarController *)self.navigationController.parentViewController;
    if(childVCs.count==1){
        tabBarController.mainTabBar.hidden=NO;
    }else{
        tabBarController.mainTabBar.hidden=YES;
    }
 
}

#pragma mark 会自动调用
-(void)viewDidLoad{
    
    //初始化监听
    [self initNotification];
    //设置样式
    [self setViewStyle];
    //创建事件
    [self setViewEvent];
}

#pragma mark 设置样式:子类可以覆盖该方法重新定义
-(void)setViewStyle{
    self.navigationController.navigationBar.hidden=YES;
}

#pragma mark 创建监听
-(void)initNotification{
    //监听网络改变
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChangedNotification:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    _hostReachability = [Reachability reachabilityWithHostName:RemoteHostName];
    [_hostReachability startNotifier];
}



#pragma mark 创建事件
-(void)setViewEvent{
    
    //点击关闭键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCloseKeyBoard:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

#pragma mark 显示错误视图
-(void)showNoticeView:(UIView *)view icon:(NSString *)icon info:(NSString *)info title:(NSString *)title type:(WLNoticeType)type{
    
    if (view == nil) return;
    if (self.noticeView==nil) {
        self.noticeView = [WLNoticeView noticeView];
        self.noticeView.frame=view.bounds;
        self.noticeView.delegate=self;
        [view addSubview:self.noticeView];
    }
    //设置数据
    self.noticeView.icon=icon;
    self.noticeView.info=info;
    self.noticeView.title=title;
    self.noticeView.noticeType=type;
}

#pragma mark 隐藏错误视图
-(void)hidenNoticeView{
    if (self.noticeView) {
        [self.noticeView removeFromSuperview];
        self.noticeView=nil;
    }
}

#pragma mark 点击关闭键盘
-(void)tapCloseKeyBoard:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark 将要消失时去掉键盘
-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}

#pragma mark 显示提示消息
-(void)showHUDByView:(UIView *)view type:(MBProgressHUDMode)type info:(NSString *)info hidenTime:(double)time{
    
    //默认放在window上
    if (view == nil){
        view = [UIApplication sharedApplication].delegate.window;
    }
    
    //创建指示器
    if (self.HUD==nil) {
        self.HUD = [[MBProgressHUD alloc] initWithView:view];
        self.HUD.color = HUDColor;
    }
    [view addSubview:self.HUD];
    
    //指示器类型
    self.HUD.mode=type;
    //设置提示消息
    if (info) {
        self.HUD.labelText=info;
    }
    //设置隐藏时间
    if (time>0) {
        [self.HUD hide:YES afterDelay:time];
    }
    //显示指示器
    [self.HUD show:YES];
}

#pragma mark 隐藏指示器
-(void)hidenHUDByTime:(double)time{
    if (time>0) {
        [self.HUD hide:YES afterDelay:time];
    }else{
        [self.HUD hide:YES];
    }
    
}

#pragma mark 
-(void)noticeViewDidClickButton:(WLNoticeView *)noticeView{
   // NSLog(@"noticeType:%ld",noticeView.noticeType);
}

#pragma mark 网络状态发生改变
-(void)reachabilityChangedNotification:(NSNotification *)notification{
    Reachability* reachability = [notification object];
    if ([reachability isKindOfClass:[Reachability class]]) {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
    }

}

#pragma mark 清除
-(void)dealloc{
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
    //移除通知视图
    if (self.noticeView) {
        [self.noticeView removeFromSuperview];
        self.noticeView=nil;
    }
    //移除提示视图
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD=nil;
    }
}

@end
