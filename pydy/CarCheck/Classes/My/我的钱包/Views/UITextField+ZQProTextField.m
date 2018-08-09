//
//  UITextField+ZQProTextField.m
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/5.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "UITextField+ZQProTextField.h"

static const void *tFSectionKey = &tFSectionKey;

@implementation UITextField (ZQProTextField)

- (NSInteger)tFSecion
{
    return [objc_getAssociatedObject(self, tFSectionKey) integerValue];
}
- (void)setTFSecion:(NSInteger)tFSecion
{
    objc_setAssociatedObject(self, tFSectionKey, @(tFSecion), OBJC_ASSOCIATION_ASSIGN);
}
@end
