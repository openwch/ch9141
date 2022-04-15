//
//  WLNewfeatureViewController.m
//
//  Created by wangchunlei on 14-11-17.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import "WLNewfeatureViewController.h"
#import "UIImage+Extension.h"
#import "WLTabBarController.h"
#import "UIColor+Extension.h"
#import "UIColor+Extension.h"
#import "Constant.h"
#import "WLNavigationController.h"
#import "PeripheralInfoViewController.h"

#define SliderImageCount 3

@interface WLNewfeatureViewController()<UIScrollViewDelegate>{

    //滚动
    UIScrollView *_scrollView;
    //点击是否有效
    NSInteger currentIndex;
    
}

@end

@implementation WLNewfeatureViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    //创建子控件
    [self setupSubView];
}

#pragma mark 创建子控件
-(void)setupSubView{
    
    //设置frame
    _scrollView=[[UIScrollView alloc]init];
    _scrollView.frame=self.view.bounds;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.bounces=NO;
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    
    //添加点击事件
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change2TabBar:)];
    [_scrollView addGestureRecognizer:tap];
    
    //创建图
    for (NSInteger index=0; index<SliderImageCount; index++) {
        UIImageView *picture=[[UIImageView alloc]init];
        //picture.contentMode=UIViewContentModeScaleAspectFit;
        CGFloat picture_x=ScreenWidth*index;
        picture.frame=CGRectMake(picture_x, 0, ScreenWidth, ScreenHeight);
        NSString *imageName=[NSString stringWithFormat:@"page%ld.png",index+1];
        picture.image=[UIImage imageNamed:imageName];
        picture.layer.masksToBounds=YES;
        [_scrollView addSubview:picture];
    }
    _scrollView.contentSize=CGSizeMake(ScreenWidth*SliderImageCount, ScreenHeight);
}

#pragma mark 点击图片 切换到根控制器
-(void)change2TabBar:(UIGestureRecognizer *)gesture{
    
    if (currentIndex==SliderImageCount-1) {
        PeripheralInfoViewController *peripheralVC=[[PeripheralInfoViewController alloc]init];
        WLNavigationController *peripheralNavi=[[WLNavigationController alloc]initWithRootViewController:peripheralVC];
        self.view.window.rootViewController=peripheralNavi;
    }
}

#pragma mark 滚动的时候调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset_x=scrollView.contentOffset.x;
    currentIndex=offset_x/ScreenWidth;
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
