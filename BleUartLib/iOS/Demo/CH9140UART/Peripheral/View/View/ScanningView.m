//
//  ScanningView.m
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "ScanningView.h"
#import "Constant.h"
#import "WLSectionItem.h"
#import "NSString+Tool.h"
#import "CharacteristicUtil.h"
#import "StringUtils.h"
#import "NSString+Regex.h"
#import "UIImage+Extension.h"
#import "PeripheraItem.h"
#import "PeripheralListCell.h"


@interface ScanningView()<
UITableViewDataSource,
UITableViewDelegate>{
    UIButton *_closeBtn;
    UIView *_contains;
    UIView *_mask;
}
//选项列表
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation ScanningView

#pragma mark 实例化
-(instancetype)init{
    if (self =[super init]) {
        _mask=[[UIView alloc]init];
        _mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];

        _contains=[[UIView alloc]init];
        _contains.backgroundColor=[UIColor whiteColor];
        _contains.layer.masksToBounds=YES;
        _contains.layer.cornerRadius=10;
            
        _closeBtn=[[UIButton alloc]init];
        _closeBtn.layer.masksToBounds=YES;
        _closeBtn.layer.cornerRadius=4;
        _closeBtn.titleLabel.font=StandFont;
        [_closeBtn setBackgroundColor:LightBlueColor];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setBackgroundImage:[UIImage resizableImage:@"btn_normal"]  forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [_contains addSubview:_closeBtn];
        
        [_contains addSubview:self.tableView];
        [_contains addSubview:_closeBtn];
        [_mask addSubview:_contains];
        [self addSubview:_mask];
        
    }
    return self;
}


#pragma mark 自动布局
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin=10;
    CGFloat line_h=30;

    _mask.frame=self.bounds;

    CGFloat contains_x=margin*2;
    CGFloat contains_h=320;
    CGFloat contains_w=ScreenWidth-(contains_x*2);
    CGFloat contains_y=(ScreenHeight-contains_h)*0.5;
    _contains.frame=CGRectMake(contains_x, contains_y, contains_w, contains_h);
    
    CGFloat tv_h=contains_h-line_h-margin*2;
    self.tableView.frame=CGRectMake(0, 0, contains_w, tv_h);
    
    CGFloat close_x=margin;
    CGFloat close_y=CGRectGetMaxY(_tableView.frame)+margin;
    CGFloat close_w=contains_w-margin*2;
    _closeBtn.frame=CGRectMake(close_x, close_y, close_w, line_h+2);
}

#pragma mark 组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.scanningItems count];
}

#pragma mark  获取cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeripheraItem *peripheraItem=self.scanningItems[indexPath.row];
    PeripheralListCell *cell=[[PeripheralListCell alloc]init];
    cell.peripheraItem=peripheraItem;
    return cell;
}

#pragma mark 点击连接外设
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(scanningViewDidConnent:)]){
        [self.delegate scanningViewDidConnent:indexPath];
    }
}

//设置列表
-(void)setScanningItems:(NSMutableArray *)scanningItems{
    _scanningItems=scanningItems;
    [_tableView reloadData];
}

#pragma mark 点击确认和取消
-(void)clickCancelBtn{
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(scanningViewDidCancel)]){
        [self.delegate scanningViewDidCancel];
    }
}

-(UITableView *)tableView{
    if(_tableView==nil){
        _tableView=[[UITableView alloc]init];
        _tableView.rowHeight=60.0f;
        _tableView.sectionHeaderHeight=0;
        _tableView.sectionFooterHeight=0;
        _tableView.showsVerticalScrollIndicator=NO;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    }
    return _tableView;
}

@end



