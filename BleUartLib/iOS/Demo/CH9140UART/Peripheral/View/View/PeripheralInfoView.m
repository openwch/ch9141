//
//  PeripheralInfoView.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "PeripheralInfoView.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"
#import "StringUtils.h"
#import "NSString+Regex.h"
#import "UIImage+Extension.h"
#import <CH9140/ModemNotifyItem.h>
#import "TransferConfig.h"
#import <CH9140/SerialBaudItem.h>


@interface PeripheralInfoView()<UITextViewDelegate>{
    //串口参数
    UILabel *_uptTitle;
    UILabel *_uptInfo;
    UIButton *_uptBtn;
    UIView *_uptBottomLine;
    //模式
    UILabel *_modelTitle;
    UIButton *_dcdModel;
    UIButton *_dsrModel;
    UIButton *_ctsModel;
    UIButton *_ringModel;
    UIView *_modelBottomLine;
    
    //读取内容
    UILabel *_rtitle;
    UILabel *_rlength;
    UILabel *_rspeed;
    UIButton *_rhex;
    UILabel *_rsetValue;
    UIButton *_rsetbtn;
    UITextView *_rdataView;
    UIButton *_rclear;
    UIButton *_rsharebtn;
    UIView *_rbottomLine;
    
    //发送内容
    UILabel *_stitle;
    UILabel *_slength;
    UILabel *_sspeed;
    UIButton *_shex;
    UILabel *_ssetValue;
    UIButton *_ssetbtn;
    UITextView *_sinput;
    UIButton *_sclear;
    UIButton *_sstart;
    
}

@end

@implementation PeripheralInfoView

#pragma mark 实例化
-(instancetype)init{
    if (self =[super init]) {
#pragma mark 串口
        _uptTitle=[[UILabel alloc]init];
        _uptTitle.font=StandFont;
        _uptTitle.textColor=LightGreyColor;
        _uptTitle.text=@"串口:";
        
        _uptInfo=[[UILabel alloc]init];
        _uptInfo.font=font14Bold;
        _uptInfo.textColor=LightGreyColor;
        _uptInfo.text=COM_UNSYN;
        [self addSubview:_uptTitle];
                
        _uptBtn=[[UIButton alloc]init];
        _uptBtn.layer.masksToBounds=YES;
        _uptBtn.layer.masksToBounds=YES;
        _uptBtn.layer.cornerRadius=4;
        _uptBtn.titleLabel.font=StandFont;
        [_uptBtn setBackgroundColor:LightBlueColor];
        [_uptBtn setTitle:@"设置串口" forState:UIControlStateNormal];
        [_uptBtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_uptBtn setBackgroundImage:[UIImage resizableImage:@"btn_disable"]  forState:UIControlStateDisabled];
        [_uptBtn addTarget:self action:@selector(clickSetUptBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _uptBottomLine=[[UIView alloc]init];
        _uptBottomLine.backgroundColor=LightGreyColor4;
        
        [self addSubview:_uptTitle];
        [self addSubview:_uptInfo];
        [self addSubview:_uptBtn];
        [self addSubview:_uptBottomLine];
        
        
#pragma mark 模式
        _modelTitle=[[UILabel alloc]init];
        _modelTitle.font=StandFont;
        _modelTitle.textColor=LightGreyColor;
        _modelTitle.text=@"Modem状态:";
            
        _dcdModel=[[UIButton alloc]init];
        _dcdModel.titleLabel.font=StandFont;
        _dcdModel.userInteractionEnabled=false;
        [_dcdModel setAdjustsImageWhenHighlighted:NO];
        [_dcdModel setTitle:@"DCD" forState:UIControlStateNormal];
        [_dcdModel setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_dcdModel setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_dcdModel setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        
        _dsrModel=[[UIButton alloc]init];
        _dsrModel.titleLabel.font=StandFont;
        _dsrModel.userInteractionEnabled=false;
        [_dsrModel setAdjustsImageWhenHighlighted:NO];
        [_dsrModel setTitle:@"DSR" forState:UIControlStateNormal];
        [_dsrModel setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_dsrModel setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_dsrModel setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        
        _ctsModel=[[UIButton alloc]init];
        _ctsModel.titleLabel.font=StandFont;
        _ctsModel.userInteractionEnabled=false;
        [_ctsModel setAdjustsImageWhenHighlighted:NO];
        [_ctsModel setTitle:@"CTS" forState:UIControlStateNormal];
        [_ctsModel setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_ctsModel setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_ctsModel setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        
        _ringModel=[[UIButton alloc]init];
        _ringModel.titleLabel.font=StandFont;
        _ringModel.userInteractionEnabled=false;
        [_ringModel setAdjustsImageWhenHighlighted:NO];
        [_ringModel setTitle:@"RING" forState:UIControlStateNormal];
        [_ringModel setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_ringModel setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_ringModel setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        
        _modelBottomLine=[[UIView alloc]init];
        _modelBottomLine.backgroundColor=LightGreyColor4;
        
        [self addSubview:_modelTitle];
        [self addSubview:_dcdModel];
        [self addSubview:_dsrModel];
        [self addSubview:_ctsModel];
        [self addSubview:_ringModel];
        [self addSubview:_modelBottomLine];
        
#pragma mark 接收
        
        _rtitle=[[UILabel alloc]init];
        _rtitle.font=font14;
        _rtitle.textColor=LightGreyColor;
        _rtitle.text=@"接收:";
        
        _rlength=[[UILabel alloc]init];
        _rlength.font=font14Bold;
        _rlength.textColor=LightGreyColor;
        _rlength.text=@"0字节";

        _rspeed=[[UILabel alloc]init];
        _rspeed.font=font14Bold;
        _rspeed.textColor=LightGreyColor;
        _rspeed.text=@"0字节/秒";

        _rhex=[[UIButton alloc]init];
        _rhex.titleLabel.font=StandFont;
        [_rhex setAdjustsImageWhenHighlighted:NO];
        [_rhex setTitle:@"HEX显示" forState:UIControlStateNormal];
        [_rhex setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_rhex setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_rhex setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_rhex addTarget:self action:@selector(clickRHexShowBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _rsetValue=[[UILabel alloc]init];
        _rsetValue.font=font16Bold;
        _rsetValue.textColor=DarkGreyColor;
        _rsetValue.text=@"实时显示";
        
        _rsetbtn=[[UIButton alloc]init];
        _rsetbtn.layer.masksToBounds=YES;
        _rsetbtn.layer.masksToBounds=YES;
        _rsetbtn.layer.cornerRadius=4;
        _rsetbtn.titleLabel.font=StandFont;
        [_rsetbtn setBackgroundColor:LightBlueColor];
        [_rsetbtn setTitle:@"设置接收" forState:UIControlStateNormal];
        [_rsetbtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_rsetbtn setBackgroundImage:[UIImage resizableImage:@"btn_disable"]  forState:UIControlStateDisabled];
        [_rsetbtn addTarget:self action:@selector(clickReadSetBtn) forControlEvents:UIControlEventTouchUpInside];
    
        _rdataView=[[UITextView alloc]init];
        _rdataView.font=StandFont;
        _rdataView.textColor=LightGreyColor;
        _rdataView.layoutManager.allowsNonContiguousLayout = NO;
        _rdataView.layer.borderColor=RGB(56, 215, 232).CGColor;
        _rdataView.layer.borderWidth=1.0f;
        _rdataView.layer.masksToBounds=YES;
        _rdataView.layer.cornerRadius=10;
        _rdataView.delegate=self;
        _rdataView.editable=false;
        
        _rclear=[[UIButton alloc]init];
        _rclear.layer.masksToBounds=YES;
        _rclear.layer.cornerRadius=4;
        _rclear.titleLabel.font=StandFont;
        _rclear.layer.borderColor=RGB(56, 215, 232).CGColor;
        _rclear.layer.borderWidth=1.0f;
        [_rclear setTitle:@"清空" forState:UIControlStateNormal];
        [_rclear setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_rclear addTarget:self
                    action:@selector(clickClearReadBtn)
          forControlEvents:UIControlEventTouchUpInside];
      
        _rsharebtn=[[UIButton alloc]init];
        _rsharebtn.layer.masksToBounds=YES;
        _rsharebtn.layer.masksToBounds=YES;
        _rsharebtn.layer.cornerRadius=4;
        _rsharebtn.titleLabel.font=StandFont;
        [_rsharebtn setBackgroundColor:LightBlueColor];
        [_rsharebtn setTitle:@"分享数据" forState:UIControlStateNormal];
        [_rsharebtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_rsharebtn setBackgroundImage:[UIImage resizableImage:@"btn_disable"]  forState:UIControlStateDisabled];
        [_rsharebtn addTarget:self action:@selector(clickReadShareBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _rbottomLine=[[UIView alloc]init];
        _rbottomLine.backgroundColor=LightGreyColor4;
        
        [self addSubview:_rtitle];
        [self addSubview:_rlength];
        [self addSubview:_rspeed];
        [self addSubview:_rhex];
        [self addSubview:_rsetValue];
        [self addSubview:_rsetbtn];
        [self addSubview:_rdataView];
       // [self addSubview:self.tableView];
        [self addSubview:_rclear];
        [self addSubview:_rsharebtn];
        [self addSubview:_rbottomLine];
        
#pragma mark 发送
        
        _stitle=[[UILabel alloc]init];
        _stitle.font=StandFont;
        _stitle.textColor=LightGreyColor;
        _stitle.text=@"写入:";
        
        _slength=[[UILabel alloc]init];
        _slength.font=font14Bold;
        _slength.textColor=LightGreyColor;
        _slength.text=@"0字节";
        
        _sspeed=[[UILabel alloc]init];
        _sspeed.font=font14Bold;
        _sspeed.textColor=LightGreyColor;
        _sspeed.text=@"0字节/秒";
        
        _shex=[[UIButton alloc]init];
        _shex.titleLabel.font=StandFont;
        [_shex setTitle:@"HEX显示" forState:UIControlStateNormal];
        [_shex setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_shex setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_shex setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_shex addTarget:self
                  action:@selector(clickSHexShowBtn:)
        forControlEvents:UIControlEventTouchUpInside];
        
        _ssetValue=[[UILabel alloc]init];
        _ssetValue.font=font16Bold;
        _ssetValue.textColor=DarkGreyColor;
        _ssetValue.text=@"单次发送";
        
        _ssetbtn=[[UIButton alloc]init];
        _ssetbtn.layer.masksToBounds=YES;
        _ssetbtn.layer.masksToBounds=YES;
        _ssetbtn.layer.cornerRadius=4;
        _ssetbtn.titleLabel.font=StandFont;
        [_ssetbtn setBackgroundColor:LightBlueColor];
        [_ssetbtn setTitle:@"设置发送" forState:UIControlStateNormal];
        [_ssetbtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_ssetbtn setBackgroundImage:[UIImage resizableImage:@"btn_disable"]  forState:UIControlStateDisabled];
        [_ssetbtn addTarget:self action:@selector(clickWriteSetBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _sinput=[[UITextView alloc]init];
        _sinput.font=StandFont;
        _sinput.textColor=LightGreyColor;
        _sinput.layer.borderColor=RGB(56, 215, 232).CGColor;
        _sinput.layer.borderWidth=1.0f;
        _sinput.layer.masksToBounds=YES;
        _sinput.layer.cornerRadius=10;
        _sinput.layoutManager.allowsNonContiguousLayout = NO;
        _sinput.delegate=self;
        _sinput.keyboardType=UIKeyboardTypeASCIICapable;
        //@"123456789A123456789B123456789C123456789D123456789E123456789F123456789G123456789H123456789I123456789J123456789K123456789L123456789M123456789N123456789O123456789P123456789Q123456789R123456789S123456789T123456789U123456789V123456789W";
        
        _sclear=[[UIButton alloc]init];
        _sclear.layer.masksToBounds=YES;
        _sclear.layer.cornerRadius=4;
        _sclear.titleLabel.font=StandFont;
        _sclear.layer.borderColor=RGB(56, 215, 232).CGColor;
        _sclear.layer.borderWidth=1.0f;
        [_sclear setTitle:@"清空" forState:UIControlStateNormal];
        [_sclear setTitleColor:LightGreyColor forState:UIControlStateNormal];
        [_sclear addTarget:self
                    action:@selector(clickClearWriteBtn)
          forControlEvents:UIControlEventTouchUpInside];
        
        _sstart=[[UIButton alloc]init];
        _sstart.layer.masksToBounds=YES;
        _sstart.layer.masksToBounds=YES;
        _sstart.layer.cornerRadius=4;
        _sstart.titleLabel.font=StandFont;
        [_sstart setBackgroundColor:LightBlueColor];
        [_sstart setTitle:@"发送" forState:UIControlStateNormal];
        [_sstart setTitle:@"停止" forState:UIControlStateSelected];
        [_sstart setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_sstart setBackgroundImage:[UIImage resizableImage:@"btn_disable"]  forState:UIControlStateDisabled];
        [_sstart addTarget:self action:@selector(clickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_stitle];
        [self addSubview:_slength];
        [self addSubview:_sspeed];
        [self addSubview:_shex];
        [self addSubview:_ssetValue];
        [self addSubview:_ssetbtn];
        [self addSubview:_sinput];
        [self addSubview:_sclear];
        [self addSubview:_sstart];
    }
    return self;
}


#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin=6;
    CGFloat self_w=self.frame.size.width;
    CGFloat btn_w=80;
    CGFloat btn_h=30;
    CGFloat line_h=28;
    
#pragma mark  串口尺寸
    CGSize uptTitleSize=[_uptTitle.text sizeWithFont:StandFont maxSize:CGSizeMake(0, 0)];
    CGFloat uptTitle_x=margin;
    CGFloat uptTitle_y=margin;
    CGFloat uptTitle_w=uptTitleSize.width;
    _uptTitle.frame=CGRectMake(uptTitle_x, uptTitle_y, uptTitle_w, line_h);
    
    CGFloat uptBtn_w=btn_w;
    CGFloat uptBtn_x=self_w-uptBtn_w-margin;
    _uptBtn.frame=CGRectMake(uptBtn_x, uptTitle_y, uptBtn_w, btn_h);
    
    CGFloat uptInfo_x=CGRectGetMaxX(_uptTitle.frame);
    CGFloat uptInfo_w=uptBtn_x-uptInfo_x-margin;//font14Bold
    _uptInfo.frame=CGRectMake(uptInfo_x, uptTitle_y, uptInfo_w, line_h);

    CGFloat readline_y=CGRectGetMaxY(_uptTitle.frame)+margin;
    _uptBottomLine.frame=CGRectMake(0, readline_y, self_w, 1);
    
#pragma 模式尺寸
    CGSize modelTitleSize=[_modelTitle.text sizeWithFont:StandFont maxSize:CGSizeMake(0, 0)];
    CGFloat modelTitle_x=margin;
    CGFloat modelTitle_y=CGRectGetMaxY(_uptBottomLine.frame)+margin;
    CGFloat modelTitle_w=modelTitleSize.width;
    CGFloat modelTitle_h=30;
    _modelTitle.frame=CGRectMake(modelTitle_x, modelTitle_y, modelTitle_w, modelTitle_h);
    CGFloat dcd_x=CGRectGetMaxX(_modelTitle.frame)+margin;
    CGFloat dcd_w=50;
    _dcdModel.frame=CGRectMake(dcd_x, modelTitle_y, dcd_w, modelTitle_h);
    CGFloat dsr_x=CGRectGetMaxX(_dcdModel.frame)+margin;
    _dsrModel.frame=CGRectMake(dsr_x, modelTitle_y, dcd_w, modelTitle_h);
    CGFloat cts_x=CGRectGetMaxX(_dsrModel.frame)+margin;
    _ctsModel.frame=CGRectMake(cts_x, modelTitle_y, dcd_w, modelTitle_h);
    CGFloat ring_x=CGRectGetMaxX(_ctsModel.frame)+margin;
    _ringModel.frame=CGRectMake(ring_x, modelTitle_y, 70, modelTitle_h);
    CGFloat modelline_y=CGRectGetMaxY(_dcdModel.frame)+margin;
    _modelBottomLine.frame=CGRectMake(0, modelline_y, self_w, 1);
    
#pragma mark 接收尺寸定义

    CGSize rtitleSize=[_rtitle.text sizeWithFont:font14 maxSize:CGSizeMake(0, 0)];
    CGFloat rtitle_x=margin;
    CGFloat rtitle_y=CGRectGetMaxY(_modelBottomLine.frame);
    CGFloat rtitle_w=rtitleSize.width;
    _rtitle.frame=CGRectMake(rtitle_x, rtitle_y, rtitle_w, line_h);

    CGFloat rlength_x=CGRectGetMaxX(_rtitle.frame);
    CGFloat rlength_y=rtitle_y;
    CGFloat rlength_w=100;
    _rlength.frame=CGRectMake(rlength_x, rlength_y, rlength_w, line_h);
    
    CGFloat rspeed_x=CGRectGetMaxX(_rlength.frame);
    CGFloat rspeed_y=rtitle_y;
    CGFloat rspeed_w=100;
    _rspeed.frame=CGRectMake(rspeed_x, rspeed_y, rspeed_w, line_h);
    
    CGFloat rhex_w=100;
    CGFloat rhex_x=self_w-margin-rhex_w;
    _rhex.frame=CGRectMake(rhex_x, rspeed_y, rhex_w, line_h);
    
    CGFloat rsetvalue_x=margin;
    CGFloat rsetvalue_w=self_w-margin-margin-btn_w;
    CGFloat rsetvalue_y=CGRectGetMaxY(_rhex.frame);
    _rsetValue.frame=CGRectMake(rsetvalue_x, rsetvalue_y, rsetvalue_w, line_h);
    
    CGFloat setbtn_x=CGRectGetMaxX(_rsetValue.frame);
    CGFloat setbtn_y=rsetvalue_y;
    CGFloat setbtn_w=btn_w;
    _rsetbtn.frame=CGRectMake(setbtn_x, setbtn_y, setbtn_w, line_h);
        
    CGFloat rdata_x=rtitle_x;
    CGFloat rdata_y=CGRectGetMaxY(_rsetbtn.frame)+margin;
    CGFloat rdata_w=self_w-margin*2;
    CGFloat rdata_h=200;
    _rdataView.frame=CGRectMake(rdata_x, rdata_y, rdata_w, rdata_h);
    
    CGFloat rclear_x=rtitle_x;
    CGFloat rclear_y=CGRectGetMaxY(_rdataView.frame)+margin;
    CGFloat rclear_w=btn_w;
    _rclear.frame=CGRectMake(rclear_x, rclear_y, rclear_w, line_h);
    
    CGFloat rshare_w=btn_w;
    CGFloat rshare_y=rclear_y;
    CGFloat rshare_x=self_w-rshare_w-margin;
    _rsharebtn.frame=CGRectMake(rshare_x, rshare_y, rshare_w, line_h);

    CGFloat _rbottomLine_x=CGRectGetMaxY(_rclear.frame)+margin;
    _rbottomLine.frame=CGRectMake(0, _rbottomLine_x, self_w, 1);

#pragma mark 发送尺寸定义

    CGSize stitleSize=[_stitle.text sizeWithFont:StandFont maxSize:CGSizeMake(0, 0)];
    CGFloat stitle_x=margin;
    CGFloat stitle_y=CGRectGetMaxY(_rbottomLine.frame)+margin;
    CGFloat stitle_w=stitleSize.width;
    _stitle.frame=CGRectMake(stitle_x, stitle_y, stitle_w, line_h);

    CGFloat slength_x=CGRectGetMaxX(_stitle.frame);
    CGFloat slength_y=stitle_y;
    CGFloat slength_w=rlength_w;
    _slength.frame=CGRectMake(slength_x, slength_y, slength_w, line_h);
    
    CGFloat sspeed_x=CGRectGetMaxX(_slength.frame);
    CGFloat sspeed_y=stitle_y;
    CGFloat sspeed_w=rspeed_w;
    _sspeed.frame=CGRectMake(sspeed_x, sspeed_y, sspeed_w, line_h);

    CGFloat shex_x=rhex_x;
    CGFloat shex_y=stitle_y;
    CGFloat shex_w=rhex_w;
    _shex.frame=CGRectMake(shex_x, shex_y, shex_w, line_h);
    
    CGFloat ssetvalue_x=margin;
    CGFloat ssetvalue_w=self_w-margin-margin-btn_w;
    CGFloat ssetvalue_y=CGRectGetMaxY(_shex.frame);
    _ssetValue.frame=CGRectMake(ssetvalue_x, ssetvalue_y, ssetvalue_w, line_h);
    
    CGFloat sset_x=CGRectGetMaxX(_ssetValue.frame);
    CGFloat sset_y=ssetvalue_y;
    CGFloat sset_w=btn_w;
    _ssetbtn.frame=CGRectMake(sset_x, sset_y, sset_w, line_h);
    
    CGFloat sinput_x=stitle_x;
    CGFloat sinput_y=CGRectGetMaxY(_ssetbtn.frame)+margin;
    CGFloat sinput_w=self_w-margin*2;
    CGFloat sinput_h=80;
    _sinput.frame=CGRectMake(sinput_x, sinput_y, sinput_w, sinput_h);
    
    CGFloat sclear_x=margin;
    CGFloat sclear_y=CGRectGetMaxY(_sinput.frame)+margin;
    CGFloat sclear_w=btn_w;
    _sclear.frame=CGRectMake(sclear_x, sclear_y, sclear_w, line_h);
    
    CGFloat sstart_w=btn_w;
    CGFloat sstart_x=self_w-sstart_w-margin;
    CGFloat sstart_y=sclear_y;
    _sstart.frame=CGRectMake(sstart_x, sstart_y, sstart_w, line_h);
}

#pragma mark 点击HEX显示
-(void)clickSHexShowBtn:(UIButton *)button{
   if(_sstart.selected==true)return; //如果在发送中
    button.selected=!button.selected;
    _sinput.text=@"";
}
-(void)clickRHexShowBtn:(UIButton *)button{
    button.selected=!button.selected;
    _rdataView.text=@"";
}

#pragma mark 清空读
-(void)clickClearReadBtn{
    _rdataView.text=@"";
    _rlength.text=@"0字节 ";
    _rspeed.text=@"0字节/秒";
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidClearRead)]){
        [self.delegate peripheralInfoViewDidClearRead];
    }
}

#pragma mark 清空写
-(void)clickClearWriteBtn{
    _sinput.text=@"";
    _slength.text=@"0字节";
    _sspeed.text=@"0字节/秒";
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidClearWrite)]){
        [self.delegate peripheralInfoViewDidClearWrite];
    }
}

#pragma mark 点击发送
-(void)clickSendBtn:(UIButton *)sbtn{
    //发送配置 1=单次发送 2=连续发送 3= 定时发送 4=发送文件
    if(_transferConfig.sendWay==1){ //单次写入
        NSData *writeData=[self processWriteData:_transferConfig.sendWay];
        if(writeData==nil){
            return;
        }
        if([self.delegate respondsToSelector:@selector(peripheralInfoViewDidOnceWrite:)]){
            [self.delegate peripheralInfoViewDidOnceWrite:writeData];
        }
    }else if(_transferConfig.sendWay==2){//连续发送
        if(sbtn.selected ==false){
            NSData *writeData=[self processWriteData:_transferConfig.sendWay];
            if(writeData==nil){
                return;
            }
            _sstart.selected=true;
            _sinput.editable=false;
            _sclear.enabled=false;
            _ssetbtn.enabled=false;
            _uptBtn.enabled=false;
            _rsetbtn.enabled=false;
            _rsharebtn.enabled=false;
            _shex.enabled=false;
            _rhex.enabled=false;
            if(writeData!=nil){
                if([self.delegate respondsToSelector:@selector(peripheralInfoViewDidRepeatWrite:)]){
                    [self.delegate peripheralInfoViewDidRepeatWrite:writeData];
                }
            }
        }else{
            _sstart.selected=false;
            _sinput.editable=true;
            _sclear.enabled=true;
            _ssetbtn.enabled=true;
            _uptBtn.enabled=true;
            _rsetbtn.enabled=true;
            _rsharebtn.enabled=true;
            _shex.enabled=true;
            _rhex.enabled=true;
            //停止发送
            if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidCancelWrite)]){
                [self.delegate peripheralInfoViewDidCancelWrite];
            }
        }
    }else if(_transferConfig.sendWay==3){//定时发送
        if(sbtn.selected ==false){
            NSData *writeData=[self processWriteData:_transferConfig.sendWay];
            if(writeData==nil){
                return;
            }
            _sstart.selected=true;
            _sinput.editable=false;
            _sclear.enabled=false;
            _ssetbtn.enabled=false;
            _uptBtn.enabled=false;
            _rsetbtn.enabled=false;
            _rsharebtn.enabled=false;
            _shex.enabled=false;
            _rhex.enabled=false;
            if(writeData!=nil){
                if([self.delegate respondsToSelector:@selector(peripheralInfoViewDidRepeatWrite:)]){
                    [self.delegate peripheralInfoViewDidRepeatWrite:writeData];
                }
            }
            
        }else{
            _sstart.selected=false;
            _sinput.editable=true;
            _sclear.enabled=true;
            _ssetbtn.enabled=true;
            _uptBtn.enabled=true;
            _rsetbtn.enabled=true;
            _rsharebtn.enabled=true;
            _shex.enabled=true;
            _rhex.enabled=true;
            if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidCancelWrite)]){
                [self.delegate peripheralInfoViewDidCancelWrite];
            }
        }
    }else if(_transferConfig.sendWay==4){//发送文件
        if(sbtn.selected ==false){
            _sstart.selected=true;
            _sinput.editable=false;
            _sclear.enabled=false;
            _ssetbtn.enabled=false;
            _uptBtn.enabled=false;
            _rsetbtn.enabled=false;
            _rsharebtn.enabled=false;
            _shex.enabled=false;
            _rhex.enabled=false;
            if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidWriteFile)]){
                [self.delegate peripheralInfoViewDidWriteFile];
            }
        }else{
            _sstart.selected=false;
            _sinput.editable=true;
            _sclear.enabled=true;
            _ssetbtn.enabled=true;
            _uptBtn.enabled=true;
            _rsetbtn.enabled=true;
            _rsharebtn.enabled=true;
            _shex.enabled=true;
            _rhex.enabled=true;
            //停止发送
            if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidCancelWrite)]){
                [self.delegate peripheralInfoViewDidCancelWrite];
            }
        }
    }

}

#pragma mark 处理发送数据
-(NSData*)processWriteData:(NSInteger)sendWay{
    //发送数据
    NSString *writeDataStr=_sinput.text;
    if([NSString isBlankString:writeDataStr]){
        if([self.delegate respondsToSelector:@selector(peripheralInfoViewDidTipInfo:)]){
            [self.delegate peripheralInfoViewDidTipInfo:@"发送内容不能为空"];
            return nil;
        }
    }
    //hex发送
    Boolean hexSend=_shex.selected;
    if(hexSend==true){
        if([StringUtils isHex:writeDataStr]==false){
            if([self.delegate respondsToSelector:@selector(peripheralInfoViewDidTipInfo:)]){
                [self.delegate peripheralInfoViewDidTipInfo:@"输入合法的HEX串"];
                return nil;
            }
        }
    }
    NSData * writeData=nil;
    if(hexSend){
        writeData=[CharacteristicUtil convertHexStrToData:writeDataStr];
    }else{
        writeData=[writeDataStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    return writeData;
}

#pragma mark 统计结果
-(void)staticWriteLength:(NSInteger)wirteLength withTime:(NSTimeInterval)statisSecond{
    if(statisSecond==0){
        _slength.text=[NSString stringWithFormat:@"%ld字节",wirteLength];
        _sspeed.text=[NSString stringWithFormat:@"%ld字节/秒",wirteLength];
    }else{
        float rate=(float)(wirteLength)/statisSecond;
        if(statisSecond<1){
            rate=wirteLength;
        }
        _slength.text=[NSString stringWithFormat:@"%ld字节",wirteLength];
        _sspeed.text=[NSString stringWithFormat:@"%.0f字节/秒",rate];
    }
}

#pragma mark 统计读取的结果
-(void)staticReadLength:(NSInteger)readLength withTime:(NSTimeInterval)statisSecond{
    if(statisSecond==0){
        _rlength.text=[NSString stringWithFormat:@"%ld字节",readLength];
        _rspeed.text=[NSString stringWithFormat:@"%ld字节/秒",readLength];
    }else{
        float rate=(float)(readLength)/statisSecond;
        if(statisSecond<1){
            rate=readLength;
        }
        _rlength.text=[NSString stringWithFormat:@"%ld字节",readLength];
        _rspeed.text=[NSString stringWithFormat:@"%.0f字节/秒",rate];
    }
}

-(void)appendReadData:(NSData *)data{
    //格式化显示
    NSString *stringValue=nil;
    if(_rhex.selected){
        //16进制显示
        stringValue=[CharacteristicUtil convertDataToHexStr:data];
        if(![NSString isBlankString:stringValue]){
            stringValue=[CharacteristicUtil formatHexStr:stringValue withZero:false];
        }
    }else{
        //字符串显示
        stringValue=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    //超出阀值
    NSString *tempBuf=_rdataView.text;
    if(tempBuf.length+stringValue.length>1500){
        if(_transferConfig.showWay==3){
            tempBuf=@"";
        }else if(_transferConfig.showWay==4){
            return;
        }
    }
    _rdataView.text=[NSString stringWithFormat:@"%@%@",tempBuf,stringValue];
    //滚动到最后一行
   [_rdataView scrollRangeToVisible:NSMakeRange(_rdataView.text.length, 1)];
}


#pragma mark 点击定时发送
-(void)clickIntervalTimeBtn:(UIButton *)button{
    button.selected=!button.selected;
}

#pragma 开启定时发送
-(void)clickStartTimerBtn:(UIButton *)button{
    if(_sstart.selected==true)return; //如果点击了发送
    button.selected=!button.selected;
}

#pragma mark 点击配置串口
-(void)clickSetUptBtn:(UIButton *)button{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidClickUptBtn)]){
        [self.delegate peripheralInfoViewDidClickUptBtn];
    }
}

#pragma mark开启监听
-(void)clickSaveToFileBtn:(UIButton *)button{
    button.selected=!button.selected;
}

#pragma mark 设置配置参数
-(void)setModemNotifyItem:(ModemNotifyItem *)modemNotifyItem{
    _modemNotifyItem=modemNotifyItem;
    if(_modemNotifyItem!=nil){
        if(_modemNotifyItem.modemDcd==1){
            _dcdModel.selected=true;
        }else{
            _dcdModel.selected=false;
        }
        
        if(_modemNotifyItem.modemDsr==1){
            _dsrModel.selected=true;
        }else{
            _dsrModel.selected=false;
        }
        
        if(_modemNotifyItem.modemCts==1){
            _ctsModel.selected=true;
        }else{
            _ctsModel.selected=false;
        }
        
        if(_modemNotifyItem.modemRi==1){
            _ringModel.selected=true;
        }else{
            _ringModel.selected=false;
        }
    }
}

//设置传输配置
-(void)setTransferConfig:(TransferConfig *)transferConfig{
    _transferConfig=transferConfig;
    if(_transferConfig!=nil){
        //显示方式
        if(_transferConfig.showWay==1){
            _rsetValue.text=BTitle_Show;
        }else if(_transferConfig.showWay==2){
            _rsetValue.text=[NSString stringWithFormat:@"%@(%@)",BTitle_Save_File,Save_File_Name];
        }else if(_transferConfig.showWay==3){
            _rsetValue.text=BTitle_Show_Clear;
        }else if(_transferConfig.showWay==4){
            _rsetValue.text=BTitle_Show_Stop;
        }
        //发送方式
        if(_transferConfig.sendWay==1){
            _ssetValue.text=BTitle_Send_Once;
        }else if(_transferConfig.sendWay==2){
            _ssetValue.text=BTitle_Send_Repeat;
        }else if(_transferConfig.sendWay==3){
            _ssetValue.text=BTitle_Send_Time;
        }else if(_transferConfig.sendWay==4){
            _ssetValue.text=BTitle_Send_File;
        }else{
            _ssetValue.text=@"";
        }
    }
    
}

//读取配置
-(void)clickReadSetBtn{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidReadConfig)]){
        [self.delegate peripheralInfoViewDidReadConfig];
    }
}
//写取配置
-(void)clickWriteSetBtn{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidWriteConfig)]){
        [self.delegate peripheralInfoViewDidWriteConfig];
    }
}

//设置可用状态
-(void)setEnableState:(Boolean)enableState{
    if(enableState==true){
        _uptBtn.enabled=true;
        _rsetbtn.enabled=true;
        _rsharebtn.enabled=true;
        _ssetbtn.enabled=true;
        _sstart.enabled=true;
        _shex.enabled=true;
        _rhex.enabled=true;
    }else{
        _uptBtn.enabled=false;
        _rsetbtn.enabled=false;
        _rsharebtn.enabled=false;
        _ssetbtn.enabled=false;
        _sstart.enabled=false;
        _shex.enabled=false;
        _rhex.enabled=false;
    }
}

#pragma mark 波特率
-(void)setSerialBaudItem:(SerialBaudItem *)serialBaudItem{
    _serialBaudItem=serialBaudItem;
    
    //波特率
    NSString *baudRate=[NSString stringWithFormat:@"%ld",self.serialBaudItem.baudRate];
    //数据位
    NSString *dataBit=[NSString stringWithFormat:@"%ld",self.serialBaudItem.dataBit];
    //停止位
    NSString *stopBit=[NSString stringWithFormat:@"%ld",self.serialBaudItem.stopBit];
    //校验位
    NSString *parity=@"";
    switch (self.serialBaudItem.parity) {
        case 0:
            parity=@"无校验";
            break;
        case 1:
            parity=@"奇校验";
            break;
        case 2:
            parity=@"偶校验";
            break;
        case 3:
            parity=@"标志位";
            break;
        case 4:
            parity=@"空白位";
            break;
        default:
            break;
    }
    _uptInfo.text=[NSString stringWithFormat:@"%@/%@/%@/%@",baudRate,dataBit,stopBit,parity];
    
}

#pragma mark 点击分享
-(void)clickReadShareBtn{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(peripheralInfoViewDidReadShare)]){
        [self.delegate peripheralInfoViewDidReadShare];
    }
}

#pragma mark 获取读取的数据
-(NSString*)getReadData{
    return _rdataView.text;
}

-(void)setWindowDebug:(Boolean)windowDebug{
    _windowDebug=windowDebug;
    [self setNeedsLayout];
}

@end



