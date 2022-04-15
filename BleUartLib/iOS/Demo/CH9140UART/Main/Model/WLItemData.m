//
//  WLHomeCate.m
//
//  cell的基本数据模型对象
//

#import "WLItemData.h"

@implementation WLItemData

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        
        if (dict[@"icon"]) {
            [self setValue:dict[@"icon"] forKey:@"icon"];
        }
        if (dict[@"title"]) {
           [self setValue:dict[@"title"] forKey:@"title"];
        }
    }
    return self;
}

+(instancetype)dataWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

+(instancetype)dataWithTitle:(NSString *)title{
    WLItemData *itemData=[[WLItemData alloc]init];
    itemData.title=title;
    return itemData;
}

+(instancetype)dataWithTitle:(NSString *)title icon:(NSString *)icon{
    WLItemData *itemData=[[WLItemData alloc]init];
    itemData.title=title;
    itemData.icon=icon;
    return itemData;
}

+(instancetype)dataWithTitle:(NSString *)title value:(NSString *)value{
    WLItemData *itemData=[[WLItemData alloc]init];
    itemData.title=title;
    itemData.value=value;
    return itemData;
}

+(instancetype)dataWithTitle:(NSString *)title icon:(NSString *)icon value:(NSString *)value{
    WLItemData *itemData=[self dataWithTitle:title icon:icon];
    itemData.value=value;
    return itemData;
}



@end
