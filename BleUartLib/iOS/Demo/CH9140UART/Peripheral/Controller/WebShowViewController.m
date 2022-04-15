//
//  WebShowViewController.m
//  children
//
//  Created by 娟华 胡 on 15/3/25.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WebShowViewController.h"
#import "Constant.h"
#import <WebKit/WebKit.h>
#import "WLNavigationHead.h"

@interface WebShowViewController ()<WKUIDelegate>{
    WKWebView *_webView;
}

@end

@implementation WebShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
    [self setupNaviHead];

}

- (void)setupWebView {
    self.navigationItem.title=@"关于我们";
    //添加一个WebView
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _webView.UIDelegate=self;
    NSURL *url = [NSURL URLWithString:Aboutus_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}


#pragma mark 创建导航头
-(void)setupNaviHead{
    UILabel *naviTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    naviTitle.textAlignment=NSTextAlignmentCenter;
    naviTitle.textColor=[UIColor whiteColor];
    naviTitle.font=font18Bold;
    naviTitle.text=@"关于我们";
    
    //左侧按钮
    UIButton *leftBtn=[[UIButton alloc]init];
    [leftBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(dismissCurrentVc) forControlEvents:UIControlEventTouchUpInside];

    //创建导航
    WLNavigationHead *naviHead=[[WLNavigationHead alloc]initWithTitleView:naviTitle
                                                                 leftView:leftBtn
                                                                rightView:nil];
    naviHead.frame=CGRectMake(0,0,ScreenWidth, NavigationTopHeight);
    [self.view addSubview:naviHead];
    
}


#pragma mark 设置模型
-(void)setLinkStr:(NSString *)linkStr{
    _linkStr=linkStr;
}

#pragma mark 点击推出
-(void)dismissCurrentVc{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
