//
//  ContentSearchBar.h
//  teacher
//
//  Created by 娟华 胡 on 2017/10/25.
//  Copyright © 2017年 娟华 胡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentSearchBar;

@protocol ContentSearchBarDelegate <NSObject>

//点击搜索
-(void)contentSearchBar:(ContentSearchBar *)contentSearchBar didClickSearch:(NSString *)button;

@end


@interface ContentSearchBar : UIView

@property(nonatomic,assign)id<ContentSearchBarDelegate>delegate;


@end
