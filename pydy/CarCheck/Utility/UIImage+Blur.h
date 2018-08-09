//
//  UIImage+Blur.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/30.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)

-(UIImage *)blurImageWithBlur:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath;
@end
