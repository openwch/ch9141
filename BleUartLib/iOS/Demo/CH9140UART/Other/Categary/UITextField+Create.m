//
//  UITextField+Create.m
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/25.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "UITextField+Create.h"
#import "Constant.h"

@implementation UITextField (Create)

+(instancetype)textFieldWithPlaceholder:(NSString *)placeholder withSecure:(BOOL)secure{
    
    UITextField *textField=[[UITextField alloc]init];
    
    textField.leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    textField.leftViewMode=UITextFieldViewModeAlways;
    
    textField.clipsToBounds=YES;
    textField.layer.borderWidth=1.0f;
    textField.layer.cornerRadius=4.0f;
    //设置颜色
    textField.layer.borderColor=InputFieldBorderColor;
    textField.textColor=LightGreyColor;
    
    textField.secureTextEntry=secure;
    
    if (placeholder) {
        textField.placeholder=placeholder;
    }
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField.backgroundColor=[UIColor whiteColor];
    return textField;
}
@end