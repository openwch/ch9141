//
//  SerialConfigView.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "SerialConfigView.h"
#import "StringUtils.h"
#import "NSString+Tool.h"
#import "Constant.h"
#import "NSString+Regex.h"
#import "UIImage+Extension.h"
#import <CH9140/SerialBaudItem.h>
#import <CH9140/SerialModemItem.h>


@interface SerialConfigView()<
UITableViewDataSource,
UITableViewDelegate>{
    //串口参数
    UIView *_uptContains;
    UILabel *_uptTitle;
    UILabel *_uptBpsTitle;
    UIButton *_uptBpsFiled;
    UILabel *_uptBitTitle;
    UIButton *_uptBitFiled;
    UILabel *_uptStopTitle;
    UIButton *_uptStopFiled;
    UILabel *_uptCheckTitle;
    UIButton *_uptCheckFiled;
    UIButton *_surebtn;
    //流控
    UIView *_controlContains;
    UILabel *_controlAutoTitle;
    UISwitch *_switchControl;
    UIButton *_controlDtr;
    UIButton *_controlRts;
    UIButton *_closeBtn;
    //mask
    UIView *_contains;
    UIView *_mask;
}
//选项列表
@property(nonatomic,strong)UITableView *optionsView;
@property(nonatomic,strong)SerialBaudItem *cacheBaud;
@property(nonatomic,strong)SerialModemItem *cacheModem;

//串口配置的相关数据源
@property(nonatomic,strong)NSArray *bpsItems;
@property(nonatomic,strong)NSArray *bitItems;
@property(nonatomic,strong)NSArray *stopItems;
@property(nonatomic,strong)NSArray *checkItems;
//当前数据源列表
@property(nonatomic,strong)NSArray *currentItems;
//1=波特率  2=数据位 3=停止位 4=校验位
@property(nonatomic,assign)NSInteger currentFlag;

@end

@implementation SerialConfigView

#pragma mark 实例化
-(instancetype)init{
    if (self =[super init]) {
        _mask=[[UIView alloc]init];
        _mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];

        _contains=[[UIView alloc]init];
        _contains.backgroundColor=[UIColor whiteColor];
        _contains.layer.masksToBounds=YES;
        _contains.layer.cornerRadius=10;
        
        //点击关闭键盘
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                       action:@selector(tapCloseTableView:)];
        tapRecognizer.cancelsTouchesInView = NO;
        [_contains addGestureRecognizer:tapRecognizer];
        
#pragma mark 设置波特率
        _uptTitle=[[UILabel alloc]init];
        _uptTitle.font=font16Bold;
        _uptTitle.textColor=DarkGreyColor;
        _uptTitle.text=@"串口参数配置";
        _uptTitle.textAlignment=NSTextAlignmentCenter;
        
        //upt容器
        _uptContains=[[UIView alloc]init];
        _uptContains.backgroundColor=[UIColor whiteColor];
        _uptContains.layer.masksToBounds=YES;
        _uptContains.layer.cornerRadius=10;
        _uptContains.layer.borderColor=DarkBlueColor.CGColor;
        _uptContains.layer.borderWidth=1.0f;
        
        _uptBpsTitle=[[UILabel alloc]init];
        _uptBpsTitle.font=font16Bold;
        _uptBpsTitle.textColor=DarkGreyColor;
        _uptBpsTitle.text=@"波特率:";
        _uptBpsTitle.textAlignment=NSTextAlignmentCenter;
        
        _uptBpsFiled=[[UIButton alloc]init];
        [_uptBpsFiled setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_uptBpsFiled setTitle:@"115200" forState:UIControlStateNormal];
        _uptBpsFiled.layer.borderColor=DarkBlueColor.CGColor;
        _uptBpsFiled.layer.borderWidth=1.0f;
        _uptBpsFiled.layer.cornerRadius=4;
        [_uptBpsFiled addTarget:self action:@selector(clickBpsBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _uptBitTitle=[[UILabel alloc]init];
        _uptBitTitle.font=font16Bold;
        _uptBitTitle.textColor=DarkGreyColor;
        _uptBitTitle.text=@"数据位:";
        _uptBitTitle.textAlignment=NSTextAlignmentCenter;
        
        _uptBitFiled=[[UIButton alloc]init];
        [_uptBitFiled setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_uptBitFiled setTitle:@"8" forState:UIControlStateNormal];
        _uptBitFiled.layer.borderColor=DarkBlueColor.CGColor;
        _uptBitFiled.layer.borderWidth=1.0f;
        _uptBitFiled.layer.cornerRadius=4;
        [_uptBitFiled addTarget:self action:@selector(clickBitBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _uptStopTitle=[[UILabel alloc]init];
        _uptStopTitle.font=font16Bold;
        _uptStopTitle.textColor=DarkGreyColor;
        _uptStopTitle.text=@"停止位:";
        _uptStopTitle.textAlignment=NSTextAlignmentCenter;
        
        _uptStopFiled=[[UIButton alloc]init];
        [_uptStopFiled setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_uptStopFiled setTitle:@"1" forState:UIControlStateNormal];
        _uptStopFiled.layer.borderColor=DarkBlueColor.CGColor;
        _uptStopFiled.layer.borderWidth=1.0f;
        _uptStopFiled.layer.cornerRadius=4;
        [_uptStopFiled addTarget:self action:@selector(clickStopBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _uptCheckTitle=[[UILabel alloc]init];
        _uptCheckTitle.font=font16Bold;
        _uptCheckTitle.textColor=DarkGreyColor;
        _uptCheckTitle.text=@"校验位:";
        _uptCheckTitle.textAlignment=NSTextAlignmentCenter;
        
        _uptCheckFiled=[[UIButton alloc]init];
        [_uptCheckFiled setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_uptCheckFiled setTitle:@"无" forState:UIControlStateNormal];
        _uptCheckFiled.layer.borderColor=DarkBlueColor.CGColor;
        _uptCheckFiled.layer.borderWidth=1.0f;
        _uptCheckFiled.layer.cornerRadius=4;
        [_uptCheckFiled addTarget:self action:@selector(clickCheckBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _surebtn=[[UIButton alloc]init];
        _surebtn.layer.masksToBounds=YES;
        _surebtn.layer.cornerRadius=4;
        _surebtn.titleLabel.font=StandFont;
        [_surebtn setBackgroundColor:LightBlueColor];
        [_surebtn setTitle:@"设置" forState:UIControlStateNormal];
        [_surebtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_surebtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [_uptContains addSubview:_uptBpsTitle];
        [_uptContains addSubview:_uptBpsFiled];
        [_uptContains addSubview:_uptBitTitle];
        [_uptContains addSubview:_uptBitFiled];
        [_uptContains addSubview:_uptStopTitle];
        [_uptContains addSubview:_uptStopFiled];
        [_uptContains addSubview:_uptCheckTitle];
        [_uptContains addSubview:_uptCheckFiled];
        [_uptContains addSubview:_surebtn];
        [_contains addSubview:_uptTitle];
        [_contains addSubview:_uptContains];
        [self addSubview:_uptContains];

#pragma mark 设置发送
        _controlContains=[[UIView alloc]init];
        _controlContains.backgroundColor=[UIColor whiteColor];
        _controlContains.layer.masksToBounds=YES;
        _controlContains.layer.cornerRadius=10;
        _controlContains.layer.borderColor=DarkBlueColor.CGColor;
        _controlContains.layer.borderWidth=1.0f;
        
        _controlAutoTitle=[[UILabel alloc]init];
        _controlAutoTitle.font=font16Bold;
        _controlAutoTitle.textColor=DarkGreyColor;
        _controlAutoTitle.text=@"硬件串口自动流控(CTS/RTS)";
        
        _switchControl=[[UISwitch alloc]init];
        _switchControl.on=true;
        [_switchControl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        _controlDtr=[[UIButton alloc]init];
        _controlDtr.titleLabel.font=font16Bold;
        [_controlDtr setAdjustsImageWhenHighlighted:NO];
        [_controlDtr setTitle:@"DTR" forState:UIControlStateNormal];
        [_controlDtr setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_controlDtr setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_controlDtr setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_controlDtr addTarget:self action:@selector(clickModemBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _controlRts=[[UIButton alloc]init];
        _controlRts.titleLabel.font=font16Bold;
        //[_controlRts setAdjustsImageWhenHighlighted:YES];
        [_controlRts setAdjustsImageWhenDisabled:YES];
        [_controlRts setTitle:@"RTS" forState:UIControlStateNormal];
        [_controlRts setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_controlRts setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_controlRts setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_controlRts addTarget:self action:@selector(clickModemBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_controlContains addSubview:_controlAutoTitle];
        [_controlContains addSubview:_switchControl];
        [_controlContains addSubview:_controlDtr];
        [_controlContains addSubview:_controlRts];
        
        _closeBtn=[[UIButton alloc]init];
        _closeBtn.layer.masksToBounds=YES;
        _closeBtn.layer.cornerRadius=4;
        _closeBtn.titleLabel.font=StandFont;
        [_closeBtn setBackgroundColor:LightBlueColor];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [_contains addSubview:_closeBtn];
        
        [_contains addSubview:_uptContains];
        [_contains addSubview:_controlContains];
        [_mask addSubview:_contains];
        [self addSubview:_mask];
        
    }
    return self;
}


#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin=10;
    CGFloat filed_w=120;
    CGFloat line_h=30;

    _mask.frame=self.bounds;

    CGFloat contains_x=margin*2;
    CGFloat contains_h=390;
    CGFloat contains_w=ScreenWidth-(contains_x*2);
    CGFloat contains_y=(ScreenHeight-contains_h)*0.5;
    _contains.frame=CGRectMake(contains_x, contains_y, contains_w, contains_h);
    
    CGFloat upttitle_x=margin;
    CGFloat upttitle_y=margin;
    CGFloat upttitle_w=contains_w-upttitle_x*2;
    _uptTitle.frame=CGRectMake(upttitle_x, upttitle_y, upttitle_w, line_h);
    
    CGFloat uptcontains_x=margin;
    CGFloat uptcontains_h=180;
    CGFloat uptcontains_w=contains_w-(uptcontains_x*2);
    CGFloat uptcontains_y=CGRectGetMaxY(_uptTitle.frame)+margin;
    _uptContains.frame=CGRectMake(uptcontains_x, uptcontains_y, uptcontains_w, uptcontains_h);
    
    CGFloat control_x=uptcontains_x;
    CGFloat control_y=CGRectGetMaxY(_uptContains.frame)+margin;
    CGFloat control_w=uptcontains_w;
    CGFloat control_h=90;
    _controlContains.frame=CGRectMake(control_x, control_y, control_w, control_h);

#pragma mark  设置串口尺寸
    CGSize bpsTitleSize=[_uptBpsTitle.text sizeWithFont:font16Bold maxSize:CGSizeMake(0, 0)];
    CGFloat title_w=bpsTitleSize.width;
    CGFloat bpstitle_x=margin;
    CGFloat bpstitle_y=margin;
    CGFloat bpstitle_w=title_w;
    _uptBpsTitle.frame=CGRectMake(bpstitle_x, bpstitle_y, bpstitle_w, line_h);

    CGFloat bpsFiled_x=CGRectGetMaxX(_uptBpsTitle.frame)+margin;
    CGFloat bpsFiled_y=bpstitle_y;
    CGFloat bpsFiled_w=filed_w;
    _uptBpsFiled.frame=CGRectMake(bpsFiled_x, bpsFiled_y, bpsFiled_w, line_h);
    
    CGFloat bittitle_x=bpstitle_x;
    CGFloat bittitle_y=CGRectGetMaxY(_uptBpsTitle.frame)+margin;
    CGFloat bittitle_w=title_w;
    _uptBitTitle.frame=CGRectMake(bittitle_x, bittitle_y, bittitle_w, line_h);
    
    CGFloat bitfiled_x=CGRectGetMaxX(_uptBitTitle.frame)+margin;
    CGFloat bitfiled_y=bittitle_y;
    CGFloat bitfiled_w=filed_w;
    _uptBitFiled.frame=CGRectMake(bitfiled_x, bitfiled_y, bitfiled_w, line_h);
    
    CGFloat stoptitle_x=bpstitle_x;
    CGFloat stoptitle_y=CGRectGetMaxY(_uptBitFiled.frame)+margin;
    CGFloat stoptitle_w=title_w;
    _uptStopTitle.frame=CGRectMake(stoptitle_x, stoptitle_y, stoptitle_w, line_h);
    
    CGFloat stopfiled_x=CGRectGetMaxX(_uptStopTitle.frame)+margin;
    CGFloat stopfiled_y=stoptitle_y;
    CGFloat stopfiled_w=filed_w;
    _uptStopFiled.frame=CGRectMake(stopfiled_x, stopfiled_y, stopfiled_w, line_h);
    
    CGFloat checktitle_x=bpstitle_x;
    CGFloat checktitle_y=CGRectGetMaxY(_uptStopFiled.frame)+margin;
    CGFloat checktitle_w=title_w;
    _uptCheckTitle.frame=CGRectMake(checktitle_x, checktitle_y, checktitle_w, line_h);
    
    CGFloat checkfiled_x=CGRectGetMaxX(_uptCheckTitle.frame)+margin;
    CGFloat checkfiled_y=checktitle_y;
    CGFloat checkfiled_w=filed_w;
    _uptCheckFiled.frame=CGRectMake(checkfiled_x, checkfiled_y, checkfiled_w, line_h);
    
    CGFloat sure_x=CGRectGetMaxX(_uptCheckFiled.frame)+margin;
    _surebtn.frame=CGRectMake(sure_x, checkfiled_y, 100, line_h);

#pragma mark 硬件自动流控
    CGSize autoTitleSize=[_controlAutoTitle.text sizeWithFont:font16Bold maxSize:CGSizeMake(0, 0)];
    CGFloat autotitle_x=margin;
    CGFloat autotitle_y=margin;
    CGFloat autotitle_w=autoTitleSize.width;
    _controlAutoTitle.frame=CGRectMake(autotitle_x, autotitle_y, autotitle_w, line_h);
    
    CGFloat able_x=CGRectGetMaxX(_controlAutoTitle.frame)+margin;
    CGFloat able_y=margin;
    CGFloat able_w=autoTitleSize.width;
    _switchControl.frame=CGRectMake(able_x, able_y, able_w, line_h);

    CGSize dtrSize=[_controlDtr.titleLabel.text sizeWithFont:font16Bold maxSize:CGSizeMake(0, 0)];
    CGFloat dtr_x=margin;
    CGFloat dtr_y=CGRectGetMaxY(_controlAutoTitle.frame)+margin;
    CGFloat dtr_w=dtrSize.width+20;
    _controlDtr.frame=CGRectMake(dtr_x, dtr_y, dtr_w, line_h);
    
    CGSize rtxSize=[_controlRts.titleLabel.text sizeWithFont:font16Bold maxSize:CGSizeMake(0, 0)];
    CGFloat rtx_x=CGRectGetMaxX(_controlDtr.frame)+margin*2;
    CGFloat rtx_y=dtr_y;
    CGFloat rtx_w=rtxSize.width+20;
    _controlRts.frame=CGRectMake(rtx_x, rtx_y, rtx_w, line_h);
    
    CGFloat close_y=CGRectGetMaxY(_controlContains.frame)+margin;
    _closeBtn.frame=CGRectMake(margin, close_y, uptcontains_w, line_h+2);
}

#pragma mark 点击波特率按钮
-(void)clickBpsBtn{
    _currentItems=self.bpsItems;
    _currentFlag=1;
    CGRect containsFrame=_uptContains.frame;
    CGRect bpsFrame=_uptBpsFiled.frame;
    CGFloat optionX=containsFrame.origin.x+bpsFrame.origin.x;
    CGFloat optionY=containsFrame.origin.y+CGRectGetMaxY(_uptBpsFiled.frame);
    CGFloat optionW=bpsFrame.size.width;
    self.optionsView.frame=CGRectMake(optionX, optionY, optionW, 200);
    [self.optionsView reloadData];
    [_contains addSubview:self.optionsView];
}

#pragma mark 数据位
-(void)clickBitBtn{
    _currentItems=self.bitItems;
    _currentFlag=2;
    CGRect containsFrame=_uptContains.frame;
    CGRect bitFrame=_uptBitFiled.frame;
    CGFloat optionX=containsFrame.origin.x+bitFrame.origin.x;
    CGFloat optionY=containsFrame.origin.y+CGRectGetMaxY(_uptBitFiled.frame);
    CGFloat optionW=bitFrame.size.width;
    self.optionsView.frame=CGRectMake(optionX, optionY, optionW, 130);
    [self.optionsView reloadData];
    [_contains addSubview:self.optionsView];
}
#pragma mark 停止位
-(void)clickStopBtn{
    _currentItems=self.stopItems;
    _currentFlag=3;
    CGRect containsFrame=_uptContains.frame;
    CGRect stopFrame=_uptStopFiled.frame;
    CGFloat optionX=containsFrame.origin.x+stopFrame.origin.x;
    CGFloat optionY=containsFrame.origin.y+CGRectGetMaxY(_uptStopFiled.frame);
    CGFloat optionW=stopFrame.size.width;
    self.optionsView.frame=CGRectMake(optionX, optionY, optionW, 60);
    [self.optionsView reloadData];
    [_contains addSubview:self.optionsView];
}

#pragma mark 停止位
-(void)clickCheckBtn{
    _currentItems=self.checkItems;
    _currentFlag=4;
    CGRect containsFrame=_uptContains.frame;
    CGRect bpsFrame=_uptCheckFiled.frame;
    CGFloat optionX=containsFrame.origin.x+bpsFrame.origin.x;
    CGFloat optionY=containsFrame.origin.y+CGRectGetMaxY(_uptCheckFiled.frame);
    CGFloat optionW=bpsFrame.size.width;
    self.optionsView.frame=CGRectMake(optionX, optionY, optionW, 160);
    [self.optionsView reloadData];
    [_contains addSubview:self.optionsView];
}



#pragma mark 点击确认和取消
-(void)clickModemBtn:(UIButton *)btn{
    btn.selected=!btn.selected;
    if(_controlDtr.selected==true){
        self.cacheModem.dtr=1;
    }else{
        self.cacheModem.dtr=0;
    }
    if(_controlRts.selected==true){
        self.cacheModem.rts=1;
    }else{
        self.cacheModem.rts=0;
    }
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(serialConfigViewDidModem:)]){
        [self.delegate serialConfigViewDidModem:self.cacheModem];
    }
}
-(void)switchAction:(UISwitch *)sui{
    if(sui.on==true){
        self.cacheModem.flow=1;
        //如果开启了留空则关闭RTS
        _controlRts.userInteractionEnabled=false;
        _controlRts.alpha=0.4;
    }else{
        self.cacheModem.flow=0;
        _controlRts.userInteractionEnabled=true;
        _controlRts.alpha=1;
    }
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(serialConfigViewDidModem:)]){
        [self.delegate serialConfigViewDidModem:self.cacheModem];
    }
}

#pragma mark 点击确认和取消
-(void)clickCancelBtn{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(serialConfigViewDidCancel)]){
        [self.delegate serialConfigViewDidCancel];
    }
}

-(void)clickSureBtn{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(serialConfigViewDidSure:)]){
        [self.delegate serialConfigViewDidSure:self.cacheBaud];
    }
}


#pragma mark 组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.currentItems count];
}

#pragma mark  获取cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"BaseCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSString *title=[self.currentItems objectAtIndex:indexPath.row];
    //取消选中样式
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellArrow" ]];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.text=title;
    return cell;
}

#pragma mark 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_optionsView removeFromSuperview];
    NSString *title=[self.currentItems objectAtIndex:indexPath.row];
    switch (_currentFlag) {
        case 1: //波特率
            [_uptBpsFiled setTitle:title forState:UIControlStateNormal];
            _cacheBaud.baudRate=[title integerValue];
            break;
        case 2: //数据位
            [_uptBitFiled setTitle:title forState:UIControlStateNormal];
            _cacheBaud.dataBit=[title integerValue];
            break;
        case 3://停止位
            [_uptStopFiled setTitle:title forState:UIControlStateNormal];
            _cacheBaud.stopBit=[title integerValue];
            break;
        case 4://校验位
            [_uptCheckFiled setTitle:title forState:UIControlStateNormal];
            _cacheBaud.parity=[self setupParity:title];
            break;
        default:
            break;
    }
}

//转换校验位
-(NSInteger)setupParity:(NSString *)info{
    NSInteger index=[self.checkItems indexOfObject:info];
    return  index;
}

-(NSArray*)bpsItems{
    if(_bpsItems==nil){
        _bpsItems=@[@"1200",@"2400",@"4800",@"9600",@"19200",@"38400",@"57600",@"115200",@"230400",@"1000000"];
    }
    return _bpsItems;
}
-(NSArray*)bitItems{
    if(_bitItems==nil){
        _bitItems=@[@"5",@"6",@"7",@"8"];
    }
    return _bitItems;
}
-(NSArray*)stopItems{
    if(_stopItems==nil){
        _stopItems=@[@"1",@"2"];
    }
    return _stopItems;
}
-(NSArray*)checkItems{
    if(_checkItems==nil){
        _checkItems=@[@"无校验",@"奇校验",@"偶校验",@"标志位",@"空白位"];
    }
    return _checkItems;
}

-(UITableView *)optionsView{
    if(_optionsView==nil){
        _optionsView=[[UITableView alloc]init];
        _optionsView.rowHeight=30.0f;
        _optionsView.sectionHeaderHeight=0;
        _optionsView.sectionFooterHeight=0;
        _optionsView.showsVerticalScrollIndicator=NO;
        _optionsView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _optionsView.delegate=self;
        _optionsView.dataSource=self;
        _optionsView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        _optionsView.layer.cornerRadius=10;
        _optionsView.layer.borderColor=DarkBlueColor.CGColor;
        _optionsView.layer.borderWidth=1.0f;
    }
    return _optionsView;
}
#pragma mark 波特率
-(void)setSerialBaudItem:(SerialBaudItem *)serialBaudItem{
    _serialBaudItem=serialBaudItem;
    //缓存
    self.cacheBaud.baudRate=serialBaudItem.baudRate;
    self.cacheBaud.dataBit=serialBaudItem.dataBit;
    self.cacheBaud.stopBit=serialBaudItem.stopBit;
    self.cacheBaud.parity=serialBaudItem.parity;
    //创建视图
    [self initViewBaud];
}

-(void)initViewBaud{
    //波特率
    NSString *baudRate=[NSString stringWithFormat:@"%ld",self.cacheBaud.baudRate];
    [_uptBpsFiled setTitle:baudRate forState:UIControlStateNormal];
    //数据位
    NSString *dataBit=[NSString stringWithFormat:@"%ld",self.cacheBaud.dataBit];
    [_uptBitFiled setTitle:dataBit forState:UIControlStateNormal];
    //停止位
    NSString *stopBit=[NSString stringWithFormat:@"%ld",self.cacheBaud.stopBit];
    [_uptStopFiled setTitle:stopBit forState:UIControlStateNormal];
    //校验位
    NSString *parity=[self.checkItems objectAtIndex:self.cacheBaud.parity];
    [_uptCheckFiled setTitle:parity forState:UIControlStateNormal];

}
#pragma mark 流控
-(void)setSerialModemItem:(SerialModemItem *)serialModemItem{
    _serialModemItem=serialModemItem;
    //创建视图
    self.cacheModem.flow=serialModemItem.flow;
    self.cacheModem.dtr=serialModemItem.dtr;
    self.cacheModem.rts=serialModemItem.rts;
    [self initViewModem];
}
-(void)initViewModem{
    //数据位
    _switchControl.on=self.cacheModem.flow;
    if(_switchControl.on){
        _controlRts.userInteractionEnabled=false;
        _controlRts.alpha=0.4;
    }else{
        _controlRts.userInteractionEnabled=true;
        _controlRts.alpha=1;
    }
    //dtr
    if(self.cacheModem.dtr==1){
        _controlDtr.selected=true;
    }else{
        _controlDtr.selected=false;
    }
    //dtr
    if(self.cacheModem.rts==1){
        _controlRts.selected=true;
    }else{
        _controlRts.selected=false;
    }
}

-(SerialBaudItem *)cacheBaud{
    if(_cacheBaud==nil){
        _cacheBaud=[[SerialBaudItem alloc]init];
    }
    return _cacheBaud;
}
-(SerialModemItem *)cacheModem{
    if(_cacheModem==nil){
        _cacheModem=[[SerialModemItem alloc]init];
    }
    return _cacheModem;
}

#pragma mark 点击关闭键盘
-(void)tapCloseTableView:(UITapGestureRecognizer *)tap{
    NSLog(@"tap:%@",tap.view);
}


@end



