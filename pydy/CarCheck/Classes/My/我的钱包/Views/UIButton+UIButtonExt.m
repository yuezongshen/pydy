//
//  UIButton+UIButtonExt.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/10.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "UIButton+UIButtonExt.h"

@implementation UIButton (UIButtonExt)

- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    if (__kWidth>320) {
        self.imageEdgeInsets = UIEdgeInsetsMake(
                                                - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    }
    else
    {
        self.imageEdgeInsets = UIEdgeInsetsMake(
                                                - (totalHeight - imageSize.height), 16.0, 0.0, - titleSize.width);
    }

    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                            0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

@end
