//
//  CharacteristicPropertiesCell.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "CharacteristicPropertiesCell.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"

@interface CharacteristicPropertiesCell(){
    UILabel *_valueLabel;
    UIView *_bottomLine;
}

@end

@implementation CharacteristicPropertiesCell


+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"CharacteristicPropertiesCell";
    CharacteristicPropertiesCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil) {
        cell=[[CharacteristicPropertiesCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:ID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark 初始化方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        //1.1设置样式
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
        //1.2创建子控件
        _valueLabel=[[UILabel alloc]init];
        _valueLabel.font=BigFont;
        _valueLabel.textColor=LightGreyColor2;
        
        _bottomLine=[[UIView alloc]init];
        _bottomLine.backgroundColor=LightGreyColor4;
        
        [self.contentView addSubview:_valueLabel];
        [self.contentView addSubview:_bottomLine];
    }
    return self;
}


#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_w=self.frame.size.width;
    CGFloat self_h=self.frame.size.height;
    
    //值
    CGSize valueSize=[_valueLabel.text sizeWithFont:BigFont maxSize:CGSizeZero];
    CGFloat value_x=10;
    CGFloat value_y=10;
    CGFloat value_w=self_w-value_x*2;
    CGFloat value_h=valueSize.height;
    _valueLabel.frame=CGRectMake(value_x, value_y, value_w, value_h);

    CGFloat bottom_y=self_h-1;
    _bottomLine.frame=CGRectMake(0, bottom_y, self_w, 1.0f);
    
}

#pragma mark 设置模型
-(void)setCellValue:(NSString *)cellValue{
    _cellValue=cellValue;
    _valueLabel.text=[cellValue uppercaseString];
}





@end
