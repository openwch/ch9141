//
//  WLSettingItem.h
//  00-ItcastLottery
//
//  该数据模型的基类
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WLSectionItem : NSObject

/** target-action */
@property(nonatomic,assign)id target;
@property(nonatomic,assign)SEL action;

/** view */
@property(nonatomic,assign)Class viewClass;

/** height */
@property (nonatomic, assign) CGFloat height;

/** data */
@property (nonatomic, strong) id data;

+(instancetype)itemWithViewClass:(Class)viewClass;
+(instancetype)itemWithViewClass:(Class)viewClass height:(CGFloat)height;
+(instancetype)itemWithViewClass:(Class)viewClass target:(id)target action:(SEL)action;
+(instancetype)itemWithViewClass:(Class)viewClass target:(id)target action:(SEL)action height:(CGFloat)height;

@end
