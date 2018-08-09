//
//  ZQMsgFootView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMsgFootView.h"

@interface ZQMsgFootView ()

@property (strong,nonatomic) UILabel *titleLb;

@end

@implementation ZQMsgFootView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, __kWidth-30, CGRectGetHeight(frame)-10)];
        [self addSubview:_titleLb];
        _titleLb.textAlignment =NSTextAlignmentLeft;
        _titleLb.numberOfLines = 0;
        _titleLb.font = MFont(15);
        _titleLb.textColor = LH_RGBCOLOR(151, 151, 151);
    }
    return self;
}

-(void)initView{
    
    
}

-(void)setTitle:(NSString *)title{
    _titleLb.text = title;
}

@end
