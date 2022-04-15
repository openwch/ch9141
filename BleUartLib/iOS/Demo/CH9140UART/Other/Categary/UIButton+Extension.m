//
//  UIButton+Extension.m
//  mypolygon
//
//  Created by 娟华 胡 on 15/6/23.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

-(void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state{
    
    self.backgroundColor=color;
    
    switch (state) {
        case UIControlStateDisabled:
            [self setEnabled:NO];
            break;
        case UIControlStateHighlighted:
            [self setEnabled:YES];
            [self setHighlighted:NO];
            break;
        case UIControlStateSelected:
            [self setEnabled:YES];
            [self setSelected:YES];
            break;
        default:
            [self setEnabled:YES];
            break;
    }
}


@end
