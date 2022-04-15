//
//  WLHomeCate.h
//
//  cell的基本数据模型对象
//

#import <Foundation/Foundation.h>

@interface WLItemData : NSObject

@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *value;
/*选择状态*/
@property(nonatomic,assign)BOOL selected;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)dataWithDict:(NSDictionary *)dict;

+(instancetype)dataWithTitle:(NSString *)title;
+(instancetype)dataWithTitle:(NSString *)title value:(NSString *)value;
+(instancetype)dataWithTitle:(NSString *)title icon:(NSString *)icon;
+(instancetype)dataWithTitle:(NSString *)title icon:(NSString *)icon value:(NSString *)value;

@end
