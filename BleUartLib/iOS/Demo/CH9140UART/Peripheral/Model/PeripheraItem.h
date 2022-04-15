//
//  PeripheraItem.h
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class PeripheraItem;

@interface PeripheraItem : NSObject

@property (strong,nonatomic)CBPeripheral* peripheral;

@property (strong,nonatomic)NSString* uuid;
@property (strong,nonatomic)NSString* name;
@property (strong,nonatomic)NSString* state;
@property (strong,nonatomic)NSNumber *RSSI;


@end
