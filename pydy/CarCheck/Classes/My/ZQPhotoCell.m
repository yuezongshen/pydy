//
//  ZQPhotoCell.m
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/5.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQPhotoCell.h"

@implementation ZQPhotoCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = MainBgColor;
        self.backgroundColor = [UIColor clearColor];
        CGFloat space = 10;
        UIImageView *bottomV = [[UIImageView alloc] initWithFrame:CGRectMake(space, space,CGRectGetWidth(frame)-space*2, CGRectGetHeight(frame)-space*2)];
        bottomV.contentMode = UIViewContentModeScaleAspectFill;
        bottomV.clipsToBounds = YES;
        [self.contentView addSubview:bottomV];
        
        self.photoImage = bottomV;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 30, 30)];
        button.center = CGPointMake(CGRectGetWidth(bottomV.frame)+space, 10);
        [button setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        self.deleteBtn = button;
    }
    return self;
}

@end


