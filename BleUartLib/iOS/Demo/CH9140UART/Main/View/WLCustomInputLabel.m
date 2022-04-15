//
//  WLCustomInputLabel.m
//  children
//
//  Created by 娟华 胡 on 15/3/30.
//  Copyright (c) 2015年 娟华 胡. All rights reserved.
//

#import "WLCustomInputLabel.h"

@implementation WLCustomInputLabel

@synthesize inputView, inputAccessoryView;

//必须在使用该自定义button的地方加一句[mCustomBtn  becomeFirstResponder];
- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)dealloc {
    self.inputView=nil;
    self.inputAccessoryView=nil;
}
@end