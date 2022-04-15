//
//  UITextField+Create.h
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/25.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Create)
/**
 *表单输入框
 */
+(instancetype)textFieldWithPlaceholder:(NSString *)placeholder withSecure:(BOOL)secure;

@end
