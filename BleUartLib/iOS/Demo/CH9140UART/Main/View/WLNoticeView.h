//
//  WLNoLoginView.h
//  children
//
//  Created by 娟华 胡 on 15/4/14.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义通知枚举
typedef enum {
    /** 购物车里没产品 */
    WLNoticeTypeCartNoProduct,
    /** 没登录 */
    WLNoticeTypeNoLogin,
    /** 没数据*/
    WLNoticeTypeNoData,
    /** 请求出错 */
    WLNoticeTypeRequestError,
    /** 返回数据*/
    WLNoticeTypeDataError
    
} WLNoticeType;

@class WLNoticeView;

@protocol WLNoticeViewDelegate <NSObject>

@optional
//点击按钮通知
-(void)noticeViewDidClickButton:(WLNoticeView *)noticeView;
@end

@interface WLNoticeView : UIView

/*代理*/
@property(nonatomic,assign)id<WLNoticeViewDelegate>delegate;
//提示信息
@property(nonatomic,copy) NSString *info;
/* 标题*/
@property(nonatomic,copy) NSString *title;
/* 图标*/
@property(nonatomic,copy) NSString *icon;
/* 消息类型*/
@property(nonatomic,assign)WLNoticeType noticeType;

+(instancetype)noticeView;

@end
