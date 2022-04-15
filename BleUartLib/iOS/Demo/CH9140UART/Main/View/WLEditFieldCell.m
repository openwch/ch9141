//
//  WLEditFieldCell.m
//  children
//
//  Created by 娟华 胡 on 15/4/24.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLEditFieldCell.h"
#import "WLSectionItem.h"
#import "WLEditFieldItem.h"
#import "Constant.h"
#import "NSString+Tool.h"

#define CellMargingSpace 20

@interface WLEditFieldCell()<UITextFieldDelegate>

//字段名
@property(nonatomic,strong)UILabel *titleLabel;
//文本框
@property(nonatomic,strong)UITextField *inputField;

@end

@implementation WLEditFieldCell

#pragma mark 类创建方法
+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString * const ID=@"EditFieldCell";
    WLEditFieldCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil){
        cell=[[WLEditFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 重写父类方法 创建cell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubView];
    }
    return self;
}

#pragma mark 创建子控件
-(void)setupSubView{
    //标题
    self.titleLabel=[[UILabel alloc]init];
    self.titleLabel.font=MiddleFont;
    self.titleLabel.textAlignment=NSTextAlignmentRight;
    self.titleLabel.textColor=LightGreyColor;
    //输入框
    self.inputField=[[UITextField alloc]init];
    self.inputField.font=MiddleFont;
    self.inputField.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.inputField.delegate=self;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.inputField];
    
}

#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_w=self.frame.size.width;
    CGFloat self_h=self.frame.size.height;
    //字段名
    CGFloat label_w=61;
    CGFloat label_h=21;
    CGFloat label_x=20;
    CGFloat label_y=(self_h-label_h)/2;
    self.titleLabel.frame=CGRectMake(label_x, label_y, label_w, label_h);
    //字段
    CGFloat field_x=CGRectGetMaxX(self.titleLabel.frame)+10;
    CGFloat field_h=30;
    CGFloat field_y=(self_h-field_h)/2;
    CGFloat field_w=self_w-field_x-10;
    self.inputField.frame=CGRectMake(field_x, field_y, field_w, field_h);
    
}

#pragma mark 设置模型
-(void)setSectionItem:(WLSectionItem *)sectionItem{
    _sectionItem=sectionItem;
    [self setupCellData];
}

#pragma mark 设置cell数据
-(void)setupCellData{
    WLEditFieldItem *fieldItem=self.sectionItem.data;
    self.titleLabel.text=fieldItem.titleValue;
    self.inputField.placeholder=fieldItem.holderValue;
    
    //设置placehold
    if (fieldItem.holderValue) {
        self.inputField.placeholder=fieldItem.holderValue;
    }
    
    //如果有值则设置文本框
    if (fieldItem.fieldValue) {
        self.inputField.text=fieldItem.fieldValue;
    }
}
#pragma mark 代理:编辑完成奖值设为模型
-(void)textFieldDidEndEditing:(UITextField *)textField{
    WLEditFieldItem *fieldItem=self.sectionItem.data;
    fieldItem.fieldValue=textField.text;
}

@end