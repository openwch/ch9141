//
//  PeripheralViewCell.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "PeripheralListCell.h"
#import "PeripheraItem.h"
#import "Constant.h"
#import "NSString+Tool.h"

@interface PeripheralListCell(){

    UILabel *_nameLabel;
    UILabel *_rssiLabel;
    UILabel *_uuidLabel;
    UIImageView *_signGray;
    UIImageView *_signBlue;
    UIView *_bottomLine;
}

@end

@implementation PeripheralListCell

+(instancetype) cellWithTableView:(UITableView *)tableView{
    static NSString *ID=@"PeripheralListCell";
    PeripheralListCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil) {
        cell=[[PeripheralListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.font=font18Bold;
        _nameLabel.textColor=DarkGreyColor;
        
        _uuidLabel=[[UILabel alloc]init];
        _uuidLabel.font=font14Bold;
        _uuidLabel.textColor=DarkGreyColor;
        
        _rssiLabel=[[UILabel alloc]init];
        _rssiLabel.font=font18Bold;
        _rssiLabel.textColor=LightGreyColor;
        _rssiLabel.textAlignment=NSTextAlignmentRight;
        _rssiLabel.textColor = LightBlueColor;
        
        _signGray=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sign_gray"]];
        _signGray.contentMode=UIViewContentModeLeft;
        
        _signBlue=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sign_blue"]];
        _signBlue.contentMode=UIViewContentModeLeft;
        _signBlue.layer.masksToBounds=YES;
        
        _bottomLine=[[UIView alloc]init];
        _bottomLine.backgroundColor=LightGreyColor4;
        
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_uuidLabel];
        [self.contentView addSubview:_rssiLabel];
        [self.contentView addSubview:_signGray];
        [self.contentView addSubview:_signBlue];
        [self.contentView addSubview:_bottomLine];
    }
    return self;
}

#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_w=self.frame.size.width;
    CGFloat self_h=self.frame.size.height;
    CGFloat line_h=20;
    CGFloat margin=10;
    
    //名称
    CGSize nameSize=[_nameLabel.text sizeWithFont:font18Bold maxSize:CGSizeZero];
    CGFloat name_x=margin;
    CGFloat name_y=margin;
    CGFloat name_w=nameSize.width;
    _nameLabel.frame=CGRectMake(name_x, name_y, name_w, line_h);
    
    //信号
    CGSize rssiSize=[@"-100" sizeWithFont:font18Bold maxSize:CGSizeZero];
    CGFloat rssi_w=rssiSize.width;
    CGFloat rssi_x=self_w-margin-rssi_w;
    CGFloat rssi_y=10;
    CGFloat rssi_h=self_h-rssi_y;
    _rssiLabel.frame=CGRectMake(rssi_x, rssi_y, rssi_w, rssi_h);
    //信号
    CGFloat gray_w=25;
    CGFloat gray_x=rssi_x-gray_w;
    CGFloat gray_y=10;
    CGFloat gray_h=self_h-gray_y;
    _signGray.frame=CGRectMake(gray_x, gray_y, gray_w, gray_h);
    _signBlue.frame=CGRectMake(gray_x, gray_y, 0, gray_h);
    //状态
    CGSize uuidSize=[_uuidLabel.text sizeWithFont:font14Bold maxSize:CGSizeZero];
    CGFloat uuid_x=margin;
    CGFloat uuid_y=CGRectGetMaxY(_nameLabel.frame)+10;
    CGFloat uuid_w=gray_x-margin;
    _uuidLabel.frame=CGRectMake(uuid_x, uuid_y, uuid_w, uuidSize.height);
    
    CGFloat bottom_y=self_h-1;
    _bottomLine.frame=CGRectMake(0, bottom_y, self_w, 1.0f);
    
}

#pragma mark 设置模型
-(void)setPeripheraItem:(PeripheraItem *)peripheraItem{
    _peripheraItem=peripheraItem;
    //名称
    NSString *peripheralName=peripheraItem.name;
    if(peripheralName==nil){
        peripheralName=@"N/A";
    }
    _nameLabel.text=peripheralName;
    _uuidLabel.text=peripheraItem.uuid;
    //rssi 监听
    [self.peripheraItem addObserver:self forKeyPath:@"RSSI" options:NSKeyValueObservingOptionNew context:nil];
}

//当key路径对应的属性值发生改变时，监听器就会回调自身的监听方法，如下
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)contex{
    NSInteger rssi = [self.peripheraItem.RSSI integerValue];
    //信号值
    _rssiLabel.text=[NSString stringWithFormat:@"%ld",rssi];
    //信号量
    NSInteger rssiValue=rssi+100;
    NSInteger sw=0;
    if (rssiValue<=20) {
        sw=5;
    }else if (rssiValue>20 && rssiValue<=40) {
        sw=10;
    }else if (rssiValue>40 && rssiValue<=60) {
        sw=15;
    }else if (rssiValue>60 && rssiValue<80) {
        sw=20;
    }else if (rssiValue>80) {
        sw=25;
    }
    _signBlue.frame=CGRectMake(_signBlue.frame.origin.x, _signBlue.frame.origin.y, sw, _signBlue.frame.size.height);
    
}

#pragma mark 移除监听
-(void)dealloc{
    [self.peripheraItem removeObserver:self forKeyPath:@"RSSI"];
}


@end
