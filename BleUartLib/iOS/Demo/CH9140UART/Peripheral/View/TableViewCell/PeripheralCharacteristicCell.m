//
//  PeripheralCharacteristicCell.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "PeripheralCharacteristicCell.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"
#import "CharacteristicItem.h"

@interface PeripheralCharacteristicCell(){

    UILabel *_uuidLabel;
    UILabel *_permissionLabel;
    UIView *_bottomLine;
}

@end

@implementation PeripheralCharacteristicCell


+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"PeripheralCharacteristicCell";
    PeripheralCharacteristicCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil) {
        cell=[[PeripheralCharacteristicCell alloc]initWithStyle:UITableViewCellStyleDefault
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
        _uuidLabel=[[UILabel alloc]init];
        _uuidLabel.font=BigFont;
        _uuidLabel.textColor=DarkGreyColor;
        
        _permissionLabel=[[UILabel alloc]init];
        _permissionLabel.font=StandFont;
        _permissionLabel.textColor=LightGreyColor;
        
        _bottomLine=[[UIView alloc]init];
        _bottomLine.backgroundColor=LightGreyColor4;
        
        [self.contentView addSubview:_uuidLabel];
        [self.contentView addSubview:_permissionLabel];
        [self.contentView addSubview:_bottomLine];
    }
    return self;
}


#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_w=self.frame.size.width;
    CGFloat self_h=self.frame.size.height;
    
    //名称
    CGSize nameSize=[_uuidLabel.text sizeWithFont:BigFont maxSize:CGSizeZero];
    CGFloat uuid_x=10;
    CGFloat uuid_y=10;
    CGFloat uuid_w=self_w-uuid_x;
    CGFloat uuid_h=nameSize.height;
    _uuidLabel.frame=CGRectMake(uuid_x, uuid_y, uuid_w, uuid_h);
    
    //信号
    CGFloat permission_x=uuid_x;
    CGFloat permission_h=20;
    CGFloat permission_y=CGRectGetMaxY(_uuidLabel.frame);
    CGFloat permission_w=uuid_w;
    _permissionLabel.frame=CGRectMake(permission_x, permission_y, permission_w, permission_h);
    
    CGFloat bottom_y=self_h-1;
    _bottomLine.frame=CGRectMake(0, bottom_y, self_w, 1.0f);
    
}

#pragma mark 设置模型
-(void)setCharacteristicItem:(CharacteristicItem *)characteristicItem{
    _characteristicItem=characteristicItem;
    //UUID
    _uuidLabel.text=characteristicItem.uuid;
    //属性
    NSMutableArray<NSString *> *properties= [CharacteristicUtil convertPropertiesList:characteristicItem.characteristic.properties];
    NSString *propertiesStr=[properties componentsJoinedByString:@" "];
    _permissionLabel.text=[NSString stringWithFormat:@"Properties:%@",propertiesStr];
    
}





@end
