//
//  WLEditFieldCell.h
//  children
//
//  Created by 娟华 胡 on 15/4/24.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//  编辑或者添加的时候cell的基类
//  基与模型 WLFieldItem

#import <UIKit/UIKit.h>

@class WLSectionItem;

@interface WLEditFieldCell : UITableViewCell

@property(nonatomic,strong)WLSectionItem *sectionItem;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

