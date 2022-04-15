//
//  CharacteristicInfoCell.h
//  teacher
//
//  Created by 娟华 胡 on 2017/5/18.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import "WLTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

@class CharacteristicInfoCell;

@protocol CharacteristicInfoCellDelegate <NSObject>

-(void)characteristicInfoCellDidClickWrite:(CharacteristicInfoCell *)characteristicInfoCell;

@end

@interface CharacteristicInfoCell : WLTableViewCell

@property(nonatomic,assign)id<CharacteristicInfoCellDelegate>delegate;
@property(nonatomic,strong)CBCharacteristic *characteristic;


@end
