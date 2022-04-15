//
//  CharacteristicInfoCell.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "CharacteristicDescCell.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"

@interface CharacteristicDescCell(){

    UILabel *_descLabel;
    UIView *_bottomLine;
}

@end

@implementation CharacteristicDescCell


+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"CharacteristicDescCell";
    CharacteristicDescCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil) {
        cell=[[CharacteristicDescCell alloc]initWithStyle:UITableViewCellStyleDefault
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
        _descLabel=[[UILabel alloc]init];
        _descLabel.font=BigFont;
        _descLabel.textColor=DarkGreyColor;
        
        _bottomLine=[[UIView alloc]init];
        _bottomLine.backgroundColor=LightGreyColor4;
        
        [self.contentView addSubview:_descLabel];
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
    CGSize descSize=[_descLabel.text sizeWithFont:BigFont maxSize:CGSizeZero];
    CGFloat desc_x=10;
    CGFloat desc_y=10;
    CGFloat desc_w=self_w-desc_x*2;
    CGFloat desc_h=descSize.height;
    _descLabel.frame=CGRectMake(desc_x, desc_y, desc_w, desc_h);
    
    CGFloat bottom_y=self_h-1;
    _bottomLine.frame=CGRectMake(0, bottom_y, self_w, 1.0f);
    
}

#pragma mark 设置模型
-(void)setCharacteristic:(CBCharacteristic *)characteristic{
    _characteristic=characteristic;
    _descLabel.text=characteristic.service.debugDescription;
    NSLog(@"debugDescription:%@",characteristic.service.debugDescription);
    NSLog(@"Description:%@",characteristic.debugDescription);
}





@end
