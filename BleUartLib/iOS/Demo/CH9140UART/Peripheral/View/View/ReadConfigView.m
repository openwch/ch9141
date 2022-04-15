//
//  ReadConfigView.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "ReadConfigView.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"
#import "StringUtils.h"
#import "NSString+Regex.h"
#import "UIImage+Extension.h"
#import "TransferConfig.h"

@interface ReadConfigView(){
    //读取设置
    UILabel *_setReadTitle;
    UIButton *_realityShow;
    UIButton *_rsMoreClear;
    UIButton *_rsMoreStop;
    UIButton *_saveFile;
    //UITextField *_saveFileName;
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

@implementation ReadConfigView

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
        
        
#pragma mark 设置接受
        _setReadTitle=[[UILabel alloc]init];
        _setReadTitle.font=font18Bold;
        _setReadTitle.textColor=DarkGreyColor;
        _setReadTitle.text=@"接收设置";
        _setReadTitle.textAlignment=NSTextAlignmentCenter;
        
        _realityShow=[[UIButton alloc]init];
        _realityShow.titleLabel.font=font16Bold;
        [_realityShow setAdjustsImageWhenHighlighted:NO];
        [_realityShow setTitle:BTitle_Show forState:UIControlStateNormal];
        [_realityShow setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_realityShow setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_realityShow setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_realityShow addTarget:self action:@selector(clickRealityShow) forControlEvents:UIControlEventTouchUpInside];
        _realityShow.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        
        _rsMoreClear=[[UIButton alloc]init];
        _rsMoreClear.titleLabel.font=font16Bold;
        [_rsMoreClear setAdjustsImageWhenHighlighted:NO];
        [_rsMoreClear setTitle:BTitle_Show_Clear forState:UIControlStateNormal];
        [_rsMoreClear setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_rsMoreClear setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_rsMoreClear setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_rsMoreClear addTarget:self action:@selector(clickRealityMoreClear) forControlEvents:UIControlEventTouchUpInside];
        _rsMoreClear.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        
        _rsMoreStop=[[UIButton alloc]init];
        _rsMoreStop.titleLabel.font=font16Bold;
        [_rsMoreStop setAdjustsImageWhenHighlighted:NO];
        [_rsMoreStop setTitle:BTitle_Show_Stop forState:UIControlStateNormal];
        [_rsMoreStop setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_rsMoreStop setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_rsMoreStop setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_rsMoreStop addTarget:self action:@selector(clickRealityMoreStop) forControlEvents:UIControlEventTouchUpInside];
        _rsMoreStop.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        
        _saveFile=[[UIButton alloc]init];
        _saveFile.titleLabel.font=font16Bold;
        [_saveFile setAdjustsImageWhenHighlighted:NO];
        [_saveFile setTitle:[NSString stringWithFormat:@"%@(%@)",BTitle_Save_File,Save_File_Name]
                   forState:UIControlStateNormal];
        [_saveFile setTitleColor:DarkGreyColor forState:UIControlStateNormal];
        [_saveFile setImage:[UIImage imageNamed:@"check_normal"] forState:UIControlStateNormal];
        [_saveFile setImage:[UIImage imageNamed:@"check_selected"] forState:UIControlStateSelected];
        [_saveFile addTarget:self action:@selector(clickSaveFileBtn) forControlEvents:UIControlEventTouchUpInside];
        _saveFile.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        
//        _saveFileName=[[UITextField alloc]init];
//        _saveFileName.font=font16Bold;
//        _saveFileName.textColor=DarkGreyColor;
//        _saveFileName.placeholder=@"输入保存的文件名";
//        _saveFileName.text=DefaultSaveFile;
//        _saveFileName.hidden=false;
//        _saveFileName.layer.borderWidth=1.0f;
//        _saveFileName.layer.borderColor=LightGreyColor2.CGColor;
//        _saveFileName.keyboardType=UIKeyboardTypeASCIICapable;
        
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
        
        [_contains addSubview:_setReadTitle];
        [_contains addSubview:_realityShow];
        [_contains addSubview:_rsMoreClear];
        [_contains addSubview:_rsMoreStop];
        [_contains addSubview:_saveFile];
        //[_contains addSubview:_saveFileName];
        [_contains addSubview:_cancelbtn];
        [_contains addSubview:_surebtn];
    }
    return self;
}


#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin=10;
    CGFloat line_h=28;
    
    _mask.frame=self.bounds;
    
    CGFloat contains_x=margin*2;
    CGFloat contains_h=254;
    CGFloat contains_w=ScreenWidth-(contains_x*2);
    CGFloat contains_y=(ScreenHeight-contains_h)*0.5;
    _contains.frame=CGRectMake(contains_x, contains_y, contains_w, contains_h);
    
#pragma mark  设置读取尺寸
    CGFloat readTitle_x=margin;
    CGFloat readTitle_y=margin;
    CGFloat readTitle_w=contains_w-readTitle_x*2;
    _setReadTitle.frame=CGRectMake(readTitle_x, readTitle_y, readTitle_w, line_h);
            
    CGFloat rsmoreclear_x=readTitle_x;
    CGFloat rsmoreclear_y=CGRectGetMaxY(_setReadTitle.frame)+margin;
    CGFloat rsmoreclear_w=contains_w-rsmoreclear_x;
    _rsMoreClear.frame=CGRectMake(rsmoreclear_x, rsmoreclear_y, rsmoreclear_w, line_h);
    
    CGFloat rsmorestop_x=readTitle_x;
    CGFloat rsmorestop_y=CGRectGetMaxY(_rsMoreClear.frame)+margin;
    CGFloat rsmorestop_w=rsmoreclear_w;
    _rsMoreStop.frame=CGRectMake(rsmorestop_x, rsmorestop_y, rsmorestop_w, line_h);
    
    CGFloat reality_x=readTitle_x;
    CGFloat reality_y=CGRectGetMaxY(_rsMoreStop.frame)+margin;
    CGFloat reality_w=rsmoreclear_w;
    _realityShow.frame=CGRectMake(reality_x, reality_y, reality_w, line_h);
    
    CGFloat savefile_x=readTitle_x;
    CGFloat savefile_y=CGRectGetMaxY(_realityShow.frame)+margin;
    CGFloat savefile_w=reality_w;
    _saveFile.frame=CGRectMake(savefile_x, savefile_y, savefile_w, line_h);
    
//    CGFloat filename_x=reality_x+10;
//    CGFloat filename_y=CGRectGetMaxY(_saveFile.frame);
//    CGFloat filename_w=contains_w-filename_x-30;
//    _saveFileName.frame=CGRectMake(filename_x, filename_y, filename_w, line_h);
#pragma mark 按钮
    CGFloat cancel_x=10;
    CGFloat cancel_y=CGRectGetMaxY(_saveFile.frame)+margin;
    CGFloat cancel_w=(contains_w-30)*0.5;
    _cancelbtn.frame=CGRectMake(cancel_x, cancel_y, cancel_w, 40);
    
    CGFloat sure_x=CGRectGetMaxX(_cancelbtn.frame)+10;
    CGFloat sure_y=cancel_y;
    CGFloat sure_w=cancel_w;
    _surebtn.frame=CGRectMake(sure_x, sure_y, sure_w, 40);
}

#pragma mark 设置模型
-(void)setTransferConfig:(TransferConfig *)transferConfig{
    _transferConfig=transferConfig;
    _cacheConfig=transferConfig;
    //设置试图状态
    [self setViewState];
}

-(void)setViewState{
    _realityShow.selected=_cacheConfig.showWay==1?true:false;
    _rsMoreClear.selected=_cacheConfig.showWay==3?true:false;
    _rsMoreStop.selected=_cacheConfig.showWay==4?true:false;
    _saveFile.selected=_cacheConfig.showWay==2?true:false;
//    if(_saveFile.selected==true){
//        _saveFileName.hidden=false;
//        _saveFileName.text=_cacheConfig.saveName;
//    }else{
//        _saveFileName.hidden=true;
//    }
}

#pragma mark 点击确认和取消
-(void)clickCancelBtn{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(readConfigViewDidCancel)]){
        [self.delegate readConfigViewDidCancel];
    }
}

-(void)clickSureBtn{
    if(_realityShow.selected==true){
        _cacheConfig.showWay=1;
    }else if(_rsMoreClear.selected==true){
        _cacheConfig.showWay=3;
    }else if(_rsMoreStop.selected==true){
        _cacheConfig.showWay=4;
    }else if(_saveFile.selected==true){
        _cacheConfig.showWay=2;
        _cacheConfig.saveName=Save_File_Name;//_saveFileName.text;
    }
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(readConfigViewDidSure:)]){
        [self.delegate readConfigViewDidSure:self.cacheConfig];
    }
}

#pragma mark 实时显示
-(void)clickRealityShow{
    if(_realityShow.selected==true) return;
    _realityShow.selected=true;
    _rsMoreClear.selected=false;
    _rsMoreStop.selected=false;
    _saveFile.selected=false;
    //_saveFileName.hidden=true;
}
-(void)clickRealityMoreClear{
    if(_rsMoreClear.selected==true) return;
    _realityShow.selected=false;
    _rsMoreClear.selected=true;
    _rsMoreStop.selected=false;
    _saveFile.selected=false;
    //_saveFileName.hidden=true;
}
-(void)clickRealityMoreStop{
    if(_rsMoreStop.selected==true) return;
    _realityShow.selected=false;
    _rsMoreClear.selected=false;
    _rsMoreStop.selected=true;
    _saveFile.selected=false;
    //_//saveFileName.hidden=true;
}
-(void)clickSaveFileBtn{
    if(_saveFile.selected==true) return;
    _realityShow.selected=false;
    _rsMoreClear.selected=false;
    _rsMoreStop.selected=false;
    _saveFile.selected=true;
   // _saveFileName.hidden=false;
}


@end



