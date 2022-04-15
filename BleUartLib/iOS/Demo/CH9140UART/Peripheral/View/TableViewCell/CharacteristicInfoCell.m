//
//  CharacteristicInfoCell.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "CharacteristicInfoCell.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"

@interface CharacteristicInfoCell(){

    UILabel *_valueLabel;
    UIButton *_writeBtn;
    UIView *_bottomLine;
}

@end

@implementation CharacteristicInfoCell


+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"CharacteristicInfoCell";
    CharacteristicInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil) {
        cell=[[CharacteristicInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
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
        _valueLabel.textColor=DarkGreyColor;
        
        _writeBtn=[[UIButton alloc]init];
        _writeBtn.titleLabel.font=StandFont;
        _writeBtn.layer.masksToBounds=YES;
        _writeBtn.layer.cornerRadius=3.0f;
        [_writeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_writeBtn setTitle:@"重新写入值" forState:UIControlStateNormal];
        _writeBtn.backgroundColor=LightGreenColor;
        [_writeBtn addTarget:self action:@selector(rewriteValueHandler) forControlEvents:UIControlEventTouchUpInside];
        
        _bottomLine=[[UIView alloc]init];
        _bottomLine.backgroundColor=LightGreyColor4;
        
        [self.contentView addSubview:_valueLabel];
        [self.contentView addSubview:_writeBtn];
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
    
    //写按钮
    CGFloat write_x=value_x;
    CGFloat write_h=30;
    CGFloat write_y=CGRectGetMaxY(_valueLabel.frame)+5;
    CGFloat write_w=value_w;
    _writeBtn.frame=CGRectMake(write_x, write_y, write_w, write_h);
    
    CGFloat bottom_y=self_h-1;
    _bottomLine.frame=CGRectMake(0, bottom_y, self_w, 1.0f);
    
}

#pragma mark 设置模型
-(void)setCharacteristic:(CBCharacteristic *)characteristic{
    _characteristic=characteristic;
    NSString *valueStr=[CharacteristicUtil convertDataToHexStr:characteristic.value];
    if(![valueStr isEqualToString:@""]){
        valueStr=[NSString stringWithFormat:@"0x%@",valueStr];
    }else{
        valueStr=@"暂无";
    }
    _valueLabel.text=valueStr;
    
    //如果有写的权限则显示重写按钮
    NSMutableArray<NSString *> *properties= [CharacteristicUtil convertPropertiesList:characteristic.properties];
    //如果有写的权限
    if([properties containsObject:@"Write"]){
        
    }
}


#pragma mark 重新写入值
-(void)rewriteValueHandler{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(characteristicInfoCellDidClickWrite:)]){
        [self.delegate characteristicInfoCellDidClickWrite:self];
    }
}




@end
