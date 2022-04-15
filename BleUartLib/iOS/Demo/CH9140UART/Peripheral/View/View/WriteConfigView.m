//
//  WriteConfigView.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "WriteConfigView.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"
#import "StringUtils.h"
#import "NSString+Regex.h"
#import "UIImage+Extension.h"
#import "TransferConfig.h"

@interface WriteConfigView(){

    UILabel *_setSendTitle;
    UIButton *_onceSend;
    UIButton *_timeSend;
    UITextField *_timeValue;
    UILabel *_timeUnit;
    UIButton *_continSend;
    UIButton *_sendFile;
    UITextField *_sendFileName;
    UIView *_sendBottomLine;
    //mask
    UIView *_contains;
    UIView *_mask;
    //操作按钮
    UIButton *_cancelbtn;
    UIButton *_surebtn;
}

//配置参数
@property(nonatomic,strong)TransferConfig *cacheConfig;

@end

@implementation WriteConfigView

#pragma mark 实例化
-(instancetype)init{
    if (self =[super init]) {
        _mask=[[UIView alloc]init];
        _mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [self addSubview:_mask];
        
        _contains=[[UIView alloc]init];
        _contains.backgroundColor=[UIColor whiteColor];
        _contains.layer.masksToBounds=YES;
        _contains.layer.cornerRadius=10;
        [_mask addSubview:_contains];
        
#pragma mark 设置发送
        _setSendTitle=[[UILabel alloc]init];
        _setSendTitle.font=font18Bold;
        _setSendTitle.textColor=DarkGreyColor;
        _setSendTitle.text=@"发送设置";
        _setSendTitle.textAlignment=NSTextAlignmentCenter;
        
        _onceSend=[[UIButton alloc]init];
        _onceSend.titleLabel.font=font16Bold;
        [_onceSend setAdjustsImageWhenHighlighted:NO];
        [_onceSend setTitle:@"单次发送" forState:UIControlStateNormal];
        [_onceSend setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_onceSend setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_onceSend setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_onceSend addTarget:self action:@selector(clickOnceBtn) forControlEvents:UIControlEventTouchUpInside];
                
        _continSend=[[UIButton alloc]init];
        _continSend.titleLabel.font=font16Bold;
        [_continSend setAdjustsImageWhenHighlighted:NO];
        [_continSend setTitle:@"连续发送" forState:UIControlStateNormal];
        [_continSend setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_continSend setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_continSend setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_continSend addTarget:self action:@selector(clickContinBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _timeSend=[[UIButton alloc]init];
        _timeSend.titleLabel.font=font16Bold;
        [_timeSend setAdjustsImageWhenHighlighted:NO];
        [_timeSend setTitle:@"定时发送" forState:UIControlStateNormal];
        [_timeSend setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_timeSend setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_timeSend setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_timeSend addTarget:self action:@selector(clickTimeBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _sendFile=[[UIButton alloc]init];
        _sendFile.titleLabel.font=font16Bold;
        [_sendFile setAdjustsImageWhenHighlighted:NO];
        [_sendFile setTitle:@"发送文件" forState:UIControlStateNormal];
        [_sendFile setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_sendFile setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_sendFile setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_sendFile addTarget:self action:@selector(clickSendFileBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _sendFileName=[[UITextField alloc]init];
        _sendFileName.font=font16Bold;
        _sendFileName.textColor=DarkGreyColor;
        _sendFileName.text=@"writef.txt";
        _sendFileName.hidden=true;
        _sendFileName.layer.borderWidth=1.0f;
        _sendFileName.layer.borderColor=LightGreyColor2.CGColor;
        _sendFileName.keyboardType=UIKeyboardTypeASCIICapable;
        
        _timeValue=[[UITextField alloc]init];
        _timeValue.font=font16Bold;
        _timeValue.textColor=DarkGreyColor;
        _timeValue.text=@"10";
        _timeValue.hidden=false;
        _timeValue.layer.borderWidth=1.0f;
        _timeValue.layer.borderColor=LightGreyColor2.CGColor;
        _timeValue.textAlignment=NSTextAlignmentCenter;
        _timeValue.keyboardType=UIKeyboardTypeNumberPad;
        
        _timeUnit=[[UILabel alloc]init];
        _timeUnit.font=font16Bold;
        _timeUnit.textColor=DarkGreyColor;
        _timeUnit.text=@"毫秒";
        _timeUnit.hidden=false;
        
        _cancelbtn=[[UIButton alloc]init];
        _cancelbtn.layer.masksToBounds=YES;
        _cancelbtn.layer.cornerRadius=4;
        _cancelbtn.titleLabel.font=StandFont;
        [_cancelbtn setBackgroundColor:LightBlueColor];
        [_cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelbtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_cancelbtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _surebtn=[[UIButton alloc]init];
        _surebtn.layer.masksToBounds=YES;
        _surebtn.layer.cornerRadius=4;
        _surebtn.titleLabel.font=StandFont;
        [_surebtn setBackgroundColor:LightBlueColor];
        [_surebtn setTitle:@"保存" forState:UIControlStateNormal];
        [_surebtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_surebtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];

        [_contains addSubview:_setSendTitle];
        [_contains addSubview:_onceSend];
        [_contains addSubview:_timeSend];
        [_contains addSubview:_timeUnit];
        [_contains addSubview:_timeValue];
        [_contains addSubview:_continSend];
        [_contains addSubview:_sendFile];
        [_contains addSubview:_sendFileName];
        [_contains addSubview:_cancelbtn];
        [_contains addSubview:_surebtn];
    }
    return self;
}


#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin=10;
    CGFloat btn_w=120;
    CGFloat line_h=28;
    
    _mask.frame=self.bounds;
    
    CGFloat contains_x=margin*2;
    CGFloat contains_h=200;
    CGFloat contains_w=ScreenWidth-(contains_x*2);
    CGFloat contains_y=(ScreenHeight-contains_h)*0.5;
    _contains.frame=CGRectMake(contains_x, contains_y, contains_w, contains_h);
    
    #pragma mark  设置写尺寸
    CGFloat sendtitle_x=margin;
    CGFloat sendtitle_y=margin;
    CGFloat sendtitle_w=contains_w-sendtitle_x*2;
    _setSendTitle.frame=CGRectMake(sendtitle_x, sendtitle_y, sendtitle_w, line_h);
    
    CGFloat onceSend_x=sendtitle_x;
    CGFloat onceSend_y=CGRectGetMaxY(_setSendTitle.frame)+margin;
    CGFloat onceSend_w=btn_w;
    _onceSend.frame=CGRectMake(onceSend_x, onceSend_y, onceSend_w, line_h);
    
    CGFloat continSend_x=CGRectGetMaxX(_onceSend.frame)+margin;
    CGFloat continSend_y=onceSend_y;
    CGFloat continSend_w=btn_w;
    _continSend.frame=CGRectMake(continSend_x, continSend_y, continSend_w, line_h);
    
    CGFloat timeSend_x=sendtitle_x;
    CGFloat timeSend_y=CGRectGetMaxY(_continSend.frame)+margin;
    CGFloat timeSend_w=btn_w;
    _timeSend.frame=CGRectMake(timeSend_x, timeSend_y, timeSend_w, line_h);
    
    CGFloat sendfile_x=CGRectGetMaxX(_timeSend.frame)+margin;
    CGFloat sendfile_y=timeSend_y;
    CGFloat sendfile_w=btn_w;
    _sendFile.frame=CGRectMake(sendfile_x, sendfile_y, sendfile_w, line_h);
    
    CGFloat sendfrom_x=sendtitle_x+20;
    CGFloat sendfrom_y=CGRectGetMaxY(_sendFile.frame);
    CGFloat sendfrom_w=contains_w-sendfrom_x-30;
    _sendFileName.frame=CGRectMake(sendfrom_x, sendfrom_y, sendfrom_w, line_h);
    
    CGFloat timevalue_x=sendfrom_x;
    CGFloat timevalue_y=CGRectGetMaxY(_sendFile.frame);
    CGFloat timevalue_w=100;
    _timeValue.frame=CGRectMake(timevalue_x, timevalue_y, timevalue_w, line_h);
    
    CGFloat timeunit_x=CGRectGetMaxX(_timeValue.frame)+margin;
    CGFloat timeunit_y=timevalue_y;
    CGFloat timeunit_w=sendtitle_w;
    _timeUnit.frame=CGRectMake(timeunit_x, timeunit_y, timeunit_w, line_h);
        
#pragma mark 按钮
    CGFloat cancel_x=10;
    CGFloat cancel_y=CGRectGetMaxY(_sendFileName.frame)+margin;
    CGFloat cancel_w=(contains_w-30)*0.5;
    _cancelbtn.frame=CGRectMake(cancel_x, cancel_y, cancel_w, 32);
    
    CGFloat sure_x=CGRectGetMaxX(_cancelbtn.frame)+10;
    CGFloat sure_y=cancel_y;
    CGFloat sure_w=cancel_w;
    _surebtn.frame=CGRectMake(sure_x, sure_y, sure_w, 32);
}

#pragma mark 设置模型
-(void)setTransferConfig:(TransferConfig *)transferConfig{
    _transferConfig=transferConfig;
    _cacheConfig=transferConfig;
    //设置试图状态
    [self setViewState];
}

-(void)setViewState{
    _onceSend.selected=_cacheConfig.sendWay==1?true:false;
    _continSend.selected=_cacheConfig.sendWay==2?true:false;
    _timeSend.selected=_cacheConfig.sendWay==3?true:false;
    _sendFile.selected=_cacheConfig.sendWay==4?true:false;
    if(_timeSend.selected==true){
        _sendFileName.hidden=true;
        _timeValue.hidden=false;
        _timeUnit.hidden=false;
        _timeValue.text=[NSString stringWithFormat:@"%ld",_cacheConfig.timer];
    }else if(_sendFile.selected==true){
        _sendFileName.hidden=false;
        _sendFileName.text=_cacheConfig.fileName;
        _timeValue.hidden=true;
        _timeUnit.hidden=true;
    }else{
        _sendFileName.hidden=true;
        _timeValue.hidden=true;
        _timeUnit.hidden=true;
    }
}

#pragma mark 点击确认和取消
-(void)clickCancelBtn{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(writeConfigViewDidCancel)]){
        [self.delegate writeConfigViewDidCancel];
    }
}

-(void)clickSureBtn{
    if(_onceSend.selected==true){
        _cacheConfig.sendWay=1;
    }else if(_continSend.selected==true){
        _cacheConfig.sendWay=2;
    }else if(_timeSend.selected==true){
        _cacheConfig.sendWay=3;
        _cacheConfig.timer=  [_timeValue.text integerValue];
    }else if(_sendFile.selected==true){
        _cacheConfig.sendWay=4;
        _cacheConfig.fileName=_sendFileName.text;
    }
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(writeConfigViewDidSure:)]){
        [self.delegate writeConfigViewDidSure:self.cacheConfig];
    }
}

#pragma mark 实时显示
-(void)clickOnceBtn{
    _sendFileName.hidden=true;
    _timeValue.hidden=true;
    _timeUnit.hidden=true;
    if(_onceSend.selected==true) return;
    _onceSend.selected=true;
    _timeSend.selected=false;
    _continSend.selected=false;
    _sendFile.selected=false;
}
//定时发送
-(void)clickTimeBtn{
    _sendFileName.hidden=true;
    _timeValue.hidden=false;
    _timeUnit.hidden=false;
    if(_timeSend.selected==true){
        return;
    }else{
        _timeSend.selected=true;
        _onceSend.selected=false;
        _continSend.selected=false;
        _sendFile.selected=false;
    }
}
//连续发送
-(void)clickContinBtn{
    _sendFileName.hidden=true;
    _timeValue.hidden=true;
    _timeUnit.hidden=true;
    if(_continSend.selected==true){
        return;
    }else{
        _continSend.selected=true;
        _onceSend.selected=false;
        _timeSend.selected=false;
        _sendFile.selected=false;
    }
}
//发送文件
-(void)clickSendFileBtn{
    _sendFileName.hidden=false;
    _timeValue.hidden=true;
    _timeUnit.hidden=true;
    if(_sendFile.selected==true) return;
    _sendFile.selected=true;
    _onceSend.selected=false;
    _timeSend.selected=false;
    _continSend.selected=false;
}
@end



