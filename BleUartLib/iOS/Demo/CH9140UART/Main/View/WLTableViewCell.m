//
//  WLTableViewCell.m
//
//  Created by wangchunlei on 15-1-18.
//  Copyright (c) 2015年 wangchunlei. All rights reserved.
//

#import "WLTableViewCell.h"
#import "WLItemData.h"
#import "WLSectionItem.h"

@implementation WLTableViewCell


+(instancetype) cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID=@"BaseCell";
    WLTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[WLTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    //取消选中样式
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellArrow" ]];
    cell.textLabel.font=[UIFont systemFontOfSize:15];
    cell.textLabel.textColor=[UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    return cell;
}

#pragma mark 重写创建方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cellInitCreateWithHook];
    }
    return self;
}

#pragma mark cell创建时调用,如果不想有点击事件则重写该方法
-(void)cellInitCreateWithHook{
  
}


@end
