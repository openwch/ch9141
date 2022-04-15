//
//  CharacteristicItem.h
//  teacher
//
//  Created by 娟华 胡 on 2017/6/12.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CharacteristicItem : NSObject

@property (strong,nonatomic)CBCharacteristic* characteristic;
@property (strong,nonatomic)NSString* uuid;
@property (strong,nonatomic)NSString* name;


@end
