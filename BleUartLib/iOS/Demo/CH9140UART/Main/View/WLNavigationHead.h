//
//  WLNavigationHead.h
//  自定义NavigationController
//
//  Created by 娟华 胡 on 15/6/1.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NaviHeadButtonWidth 60.0f
#define NaviHeadButtonHeight 36.0f

@interface WLNavigationHead : UIView

/** 设置背景alpha
 */
-(void)setMaskAlpah:(CGFloat)value;

/** 设置背景
 */
-(void)setMaskBj:(NSString *)bj;

/** 根据view来创建
 */
-(instancetype)initWithTitleView:(UIView *)titleView leftView:(UIView *)leftView rightView:(UIView *)rightView;

@end