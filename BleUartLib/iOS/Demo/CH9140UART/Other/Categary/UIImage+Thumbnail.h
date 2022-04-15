//
//  UIImage+Extension.h
//
//  Created by wangchunlei on 14-9-17.
//  Copyright (c) 2014年 wangchunlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumbnail)

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
    
@end
