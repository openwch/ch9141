//
//  WLViewController.h
//  封装底层UIViewController
//

#import <UIKit/UIKit.h>
#import "UIImage+Extension.h"
#import "MBProgressHUD.h"
#import "NSString+Regex.h"
#import "WLNoticeView.h"
#import "WLNavigationBackButton.h"
#import "WLNavigationHead.h"
#import "Constant.h"

@interface WLViewController : UIViewController

/** 提示信息*/
@property(nonatomic,strong)MBProgressHUD *HUD;
/** 通知视图*/
@property(nonatomic,strong)WLNoticeView *noticeView;

//指示器
-(void)showHUDByView:(UIView *)view type:(MBProgressHUDMode)type info:(NSString *)info hidenTime:(double)time;
-(void)hidenHUDByTime:(double)time;

//错误视图
-(void)showNoticeView:(UIView *)view icon:(NSString *)icon info:(NSString *)info title:(NSString *)title type:(WLNoticeType)type;
-(void)hidenNoticeView;

//点击按钮
-(void)noticeViewDidClickButton:(WLNoticeView *)noticeView;

//点击view
-(void)tapCloseKeyBoard:(UITapGestureRecognizer *)tap;

@end
