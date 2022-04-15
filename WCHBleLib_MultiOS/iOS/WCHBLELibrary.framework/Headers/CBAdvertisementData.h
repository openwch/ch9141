//
//  CBAdvertisementData.h
//  WCHBLELibrary
//
//  Created by 娟华 胡 on 2021/3/15.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
NS_ASSUME_NONNULL_BEGIN

@interface CBAdvertisementData : NSObject
+(NSString *)getAdvertisementDataName:(NSString *)key;
+(NSString *)getAdvertisementDataStringValue:(NSDictionary *)datas  Key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
