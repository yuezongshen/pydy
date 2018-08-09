//
//  UITextField+ZQTextField.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "UITextField+ZQTextField.h"

@implementation UITextField (ZQTextField)
-(CGRect)rightViewRectForBounds:(CGRect)bounds {
    
    CGRect rightRect =CGRectZero;
    rightRect.origin.x = bounds.size.width - 30;
    rightRect.size.height =25;
    rightRect.origin.y = (bounds.size.height - rightRect.size.height)/2;
    rightRect.size.width =30;
    return rightRect;
    
}
@end
