//
//  WLInputToolBarView.h
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/24.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLInputAccessoryView;

@protocol WLInputAccessoryViewDelegate <NSObject>
//点击确定
-(void)inputAccessoryView:(WLInputAccessoryView *)inputAccessoryView didClickSure:(UIButton *)button;
//点击取消
-(void)inputAccessoryView:(WLInputAccessoryView *)inputAccessoryView didClickCancel:(UIButton *)button;
@end

@interface WLInputAccessoryView : UIView
@property(nonatomic,assign)id<WLInputAccessoryViewDelegate>delegate;

@end
