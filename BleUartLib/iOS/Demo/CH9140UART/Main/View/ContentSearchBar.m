//
//  ContentSearchBar.m
//  teacher
//
//  Created by 娟华 胡 on 2017/10/25.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "ContentSearchBar.h"
#import "NSString+Regex.h"
#import "Constant.h"

@interface ContentSearchBar()<UITextFieldDelegate>{
    
    //搜索图标
    UIButton *_searchBtn;
    //输入框
    UITextField *_inputField;
    //搜索按钮
    UIButton *_searchButton;
}

@end

@implementation ContentSearchBar

#pragma mark 根据view创建
-(instancetype)init{
    
    if (self=[super init]) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        //搜索图标
        _searchBtn=[[UIButton alloc]init];
        [_searchBtn setImage:[UIImage imageNamed:@"search_icon" ] forState:UIControlStateNormal];
        //输入框
        _inputField=[[UITextField alloc]init];
        _inputField.layer.borderColor=LightGreyColor3.CGColor;
        _inputField.font=StandFont;
        _inputField.textColor=LightGreyColor;
        _inputField.leftView=_searchBtn;
        _inputField.placeholder=@"输入学员姓名";
        _inputField.leftViewMode=UITextFieldViewModeAlways;
        _inputField.borderStyle=UITextBorderStyleRoundedRect;
        _inputField.returnKeyType=UIReturnKeySearch;
        _inputField.delegate=self;
        _inputField.rightViewMode=UITextFieldViewModeAlways;
        //search_icon
        [self addSubview:_inputField];
        [self addSubview:_searchButton];
    }
    return self;
}

#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_h=self.frame.size.height;
    CGFloat self_w=self.frame.size.width;
    
    CGFloat input_x=5;
    CGFloat input_w=self_w-input_x*2;
    CGFloat input_y=5;
    CGFloat input_h=self_h-input_y*2;
    _inputField.frame=CGRectMake(input_x,input_y, input_w, input_h);
    
    CGFloat icon_x=0;
    CGFloat icon_y=0;
    CGFloat icon_h=input_h;
    CGFloat icon_w=icon_h;
    _searchBtn.frame=CGRectMake(icon_x,icon_y, icon_w, icon_h);

}

#pragma mark 点击键盘确认按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *searchStr=_inputField.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentSearchBar:didClickSearch:)]) {
        [self.delegate contentSearchBar:self didClickSearch:searchStr];
    }
    [textField resignFirstResponder];
    return NO;
}

@end
