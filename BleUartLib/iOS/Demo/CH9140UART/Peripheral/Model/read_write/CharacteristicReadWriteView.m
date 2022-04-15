//
//  CharacteristicReadWriteView
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "CharacteristicReadWriteView.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"
#import "StringUtils.h"
#import "NSString+Regex.h"


@interface CharacteristicReadWriteView(){
    //属性
    UILabel *_propertiesLabel;
    UILabel *_uuidLabel;
    //读取操作
    UILabel *_readTitle;
    UIButton *_readBtn;
    //分割线
    UIView *_readBottomLine;
    //发送内容
    UILabel *_sendTitleLabel;
    UILabel *_sendStatisLabel;
    
    //发送操作按钮
    UIButton *_repeatSendBtn;
    UIButton *_sendRandomBtn;
}

//接收数据
@property(nonatomic,strong)NSMutableArray *receiveData;
@property(nonatomic,strong)UITextView *receiveView;
@property(nonatomic,strong)NSTimer *mytimer;
@property(nonatomic,strong)NSTimer *writeSpeedTimer;
@property(nonatomic,strong)NSTimer *readSpeedTimer;

@end

@implementation CharacteristicReadWriteView

#pragma mark 实例化
-(instancetype)init{
    if (self =[super init]) {
        //属性
        _propertiesLabel=[[UILabel alloc]init];
        _propertiesLabel.font=StandFont;
        _propertiesLabel.textColor=LightGreyColor;
        [self addSubview:_propertiesLabel];
        
        _uuidLabel=[[UILabel alloc]init];
        _uuidLabel.font=StandFont;
        _uuidLabel.textColor=LightGreyColor;
       // [self addSubview:_uuidLabel];
    
        //读标题
        _readTitle=[[UILabel alloc]init];
        _readTitle.font=BlodBigFont;
        _readTitle.textColor=RGB(56, 215, 232);
        _readTitle.text=@"接收数据";
        [self addSubview:_readTitle];
        
        //分割线
        _readBottomLine=[[UIView alloc]init];
        _readBottomLine.backgroundColor=LightGreyColor4;
        
        //接收操控区
        _readBtn=[[UIButton alloc]init];
        _readBtn.layer.masksToBounds=YES;
        _readBtn.layer.masksToBounds=YES;
        _readBtn.layer.cornerRadius=4;
        _readBtn.titleLabel.font=StandFont;
        [_readBtn setBackgroundColor:LightBlueColor];
        [_readBtn setTitle:@"读取" forState:UIControlStateNormal];
        [_readBtn addTarget:self action:@selector(clickReadBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_readTitle];
        [self addSubview:_readBtn];
        [self addSubview:_readBottomLine];
        
        //发送区
        _sendTitleLabel=[[UILabel alloc]init];
        _sendTitleLabel.font=BlodBigFont;
        _sendTitleLabel.textColor=RGB(56, 215, 232);
        _sendTitleLabel.text=@"发送数据";
        [self addSubview:_sendTitleLabel];
        
        _sendStatisLabel=[[UILabel alloc]init];
        _sendStatisLabel.font=StandFont;
        _sendStatisLabel.textColor=LightGreyColor;
        _sendStatisLabel.text=@"已发送0字节 平均速度:0字节/秒";
        [self addSubview:_sendStatisLabel];
        
        //发送操作区
        _repeatSendBtn=[[UIButton alloc]init];
        _repeatSendBtn.titleLabel.font=StandFont;
        [_repeatSendBtn setAdjustsImageWhenHighlighted:NO];
        [_repeatSendBtn setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_repeatSendBtn setTitle:@"连续发送" forState:UIControlStateNormal];
        [_repeatSendBtn setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_repeatSendBtn setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_repeatSendBtn addTarget:self
                         action:@selector(clickIntervalTimeBtn:)
               forControlEvents:UIControlEventTouchUpInside];
        _repeatSendBtn.selected=true;
        _repeatSendBtn.userInteractionEnabled=false;
        
        _sendRandomBtn=[[UIButton alloc]init];
        _sendRandomBtn.layer.masksToBounds=YES;
        _sendRandomBtn.layer.cornerRadius=4;
        _sendRandomBtn.titleLabel.font=StandFont;
        [_sendRandomBtn setBackgroundColor:LightBlueColor];
        [_sendRandomBtn setTitle:@"随机数" forState:UIControlStateNormal];
        
    
        _sendDataBtn=[[UIButton alloc]init];
        _sendDataBtn.layer.masksToBounds=YES;
        _sendDataBtn.layer.cornerRadius=4;
        _sendDataBtn.titleLabel.font=StandFont;
        [_sendDataBtn setBackgroundColor:LightBlueColor];
        [_sendDataBtn setTitle:@"点击发送" forState:UIControlStateNormal];
        [_sendDataBtn setTitle:@"开始发送" forState:UIControlStateDisabled];
        [_sendDataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendDataBtn addTarget:self
                         action:@selector(clickSendBtn:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_repeatSendBtn];
        [self addSubview:_sendRandomBtn];
        [self addSubview:_sendDataBtn];
        
    }
    return self;
}


#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat self_w=self.frame.size.width;
    CGFloat padding_left=10;
    
    //属性
    CGSize propertiesSize=[_propertiesLabel.text sizeWithFont:StandFont maxSize:CGSizeMake(0, 0)];
    CGFloat properties_x=padding_left;
    CGFloat properties_y=10;
    CGFloat properties_w=propertiesSize.width;
    CGFloat properties_h=20;
    _propertiesLabel.frame=CGRectMake(properties_x, properties_y, properties_w, properties_h);
    
    CGFloat uuid_x=CGRectGetMaxX(_propertiesLabel.frame)+10;
    CGFloat uuid_h=properties_h;
    CGFloat uuid_y=properties_y;
    CGFloat uuid_w=self_w-CGRectGetMaxX(_propertiesLabel.frame);
    _uuidLabel.frame=CGRectMake(uuid_x, uuid_y, uuid_w, uuid_h);
    
    //标题
    CGFloat read_title_x=padding_left;
    CGFloat read_title_y=5;
    CGFloat read_title_w=self_w;
    CGFloat read_title_h=24;
    _readTitle.frame=CGRectMake(read_title_x, read_title_y, read_title_w, read_title_h);
    
    //读操作按钮
    CGFloat readBtn_x=read_title_x;
    CGFloat readBtn_y=CGRectGetMaxY(_readTitle.frame)+5;
    CGFloat readBtn_w=80;
    CGFloat readBtn_h=30;
    _readBtn.frame=CGRectMake(readBtn_x, readBtn_y, readBtn_w, readBtn_h);
    
    //分割线
    CGFloat readline_x=0;
    CGFloat readline_y=CGRectGetMaxY(_readBtn.frame)+20;
    CGFloat readline_w=self_w;
    CGFloat readline_h=1;
    _readBottomLine.frame=CGRectMake(readline_x, readline_y, readline_w, readline_h);
    
    
    //发送区
    CGFloat sendtitle_x=padding_left;
    CGFloat sendtitle_y=CGRectGetMaxY(_readBottomLine.frame)+10;
    CGFloat sendtitle_w=self_w;
    CGFloat sendtitle_h=24;
    _sendTitleLabel.frame=CGRectMake(sendtitle_x, sendtitle_y, sendtitle_w, sendtitle_h);
    
    CGFloat sendStatis_x=padding_left;
    CGFloat sendStatis_y=CGRectGetMaxY(_sendTitleLabel.frame);
    CGFloat sendStatis_w=self_w-padding_left;
    CGFloat sendStatis_h=sendtitle_h;
    _sendStatisLabel.frame=CGRectMake(sendStatis_x, sendStatis_y, sendStatis_w, sendStatis_h);

    //发送操作
    CGFloat repeatsend_x=padding_left;
    CGFloat repeatsend_y=CGRectGetMaxY(_sendStatisLabel.frame)+15;
    CGFloat repeatsend_w=80;
    CGFloat repeatsend_h=30;
    _repeatSendBtn.frame=CGRectMake(repeatsend_x, repeatsend_y, repeatsend_w, repeatsend_h);

    CGFloat send_x=CGRectGetMaxX(_repeatSendBtn.frame)+5;
    CGFloat send_y=repeatsend_y;
    CGFloat send_w=repeatsend_w;
    CGFloat send_h=repeatsend_h;
    _sendDataBtn.frame=CGRectMake(send_x, send_y, send_w, send_h);
    
}

#pragma mark 设置模型
-(void)setReadCharacteristic:(CBCharacteristic *)readCharacteristic{
    _readCharacteristic=readCharacteristic;
    //属性
    NSMutableArray<NSString *> * properties=[CharacteristicUtil convertPropertiesList:readCharacteristic.properties];
    NSString *propertieStr=[properties componentsJoinedByString:@" "];
    _propertiesLabel.text=[NSString stringWithFormat:@"Properties: %@",propertieStr];
    //UUID
    _uuidLabel.text=[NSString stringWithFormat:@"UUID: %@",readCharacteristic.UUID.UUIDString];
}

#pragma mark 点击停止显示
-(void)clickReadBtn:(UIButton *)button{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(characteristicDidRead:)]){
        [self.delegate characteristicDidRead:self];
    }
}


#pragma mark 清空
-(void)clickReadClearBtn:(UIButton *)button{
    [self.receiveData removeAllObjects];
}

#pragma mark 点击发送
-(void)clickSendBtn:(UIButton *)button{
    //随机20个字节
    NSData *randData=[StringUtils testSpeedRandom];
    NSString *writeData=[CharacteristicUtil convertDataToHexStr:randData];
    //设置不可用，等待10秒后自动恢复
    if(button.enabled==false) return ; button.enabled=false;
    [self processWriteData:writeData];
}

#pragma mark 处理发送数据
-(void)processWriteData:(NSString *)writeDataStr{
    NSLog(@"writeDataStr=%@",writeDataStr);
    Boolean repeatSend=true;//是否勾选了定时发送
    if(![NSString isBlankString:writeDataStr]){
        NSData * writeData=[CharacteristicUtil convertHexStrToData:writeDataStr];
        //writeData=[writeDataStr dataUsingEncoding:NSUTF8StringEncoding];
        if([self.delegate respondsToSelector:@selector(characteristic:didWriteData:withTime:)]){
            if(repeatSend==true){
                [self.delegate characteristic:self didWriteData:writeData withTime:1000];
            }else{
                [self.delegate characteristic:self didWriteData:writeData withTime:0];
            }
            
        }
    }
}


#pragma mark 组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.receiveData count];
}

#pragma mark  获取cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"UITableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.textLabel.textColor=LightGreyColor;
        cell.textLabel.font=StandFont;
    }
    NSString *history=(NSString *)[self.receiveData objectAtIndex:indexPath.row];
    cell.textLabel.text=history;
    return cell;
}

#pragma mark 接收数据
-(NSMutableArray *)receiveData{
    if(_receiveData==nil){
        _receiveData=[[NSMutableArray<NSString *> alloc]init];
    }
    return _receiveData;
}

#pragma mark 统计结果
-(void)staticWriteLength:(NSInteger)wirteLength withTime:(NSInteger)statisSecond{
    NSString *staticeResult=@"";
    if(statisSecond<=0){
       staticeResult=[NSString stringWithFormat:@"已发送%ld字节 平均速度:%ld字节/秒",wirteLength,wirteLength];
    }else{
        staticeResult=[NSString stringWithFormat:@"已发送%ld字节 平均速度:%.0f字节/秒",wirteLength,(float)(wirteLength)/statisSecond];
    }
    _sendStatisLabel.text=staticeResult;
}

#pragma mark 设置读取统计结果
-(void)resetReadStatisLabel:(NSString *)info{
    NSLog(@"info:%@",info);
}

#pragma mark 设置读取的值
-(void)appendReadData:(NSData *)value{
    NSLog(@"-----------读取数据");
}


#pragma mark 点击定时发送
-(void)clickIntervalTimeBtn:(UIButton *)button{
    button.selected=!button.selected;
}

@end



