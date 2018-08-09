//
//  ZQAppointmentHeaderView.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQAppointmentHeaderView.h"

@interface ZQAppointmentHeaderView(){
    
    CGRect _frame;
}
@property (strong,nonatomic) UILabel *titleLabel;
@end

@implementation ZQAppointmentHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    UIView *redV = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 3, 20)];
    redV.backgroundColor = __DefaultColor;
    [self addSubview:redV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(redV.frame)+5, 10, 90, 20)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"工作动态";
    [self addSubview:_titleLabel];
    
    UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake((_frame.size.width - 6) - 10, (CGRectGetHeight(_frame)-23/2)/2, 6, 23/2)];
    imageRight.image = [UIImage imageNamed:@"shouyejiantou"];
    [self addSubview:imageRight];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageRight.frame)-112, CGRectGetMinY(imageRight.frame), 100, 12)];
    detailLabel.text = @"更多";
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:detailLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_frame)- 0.7, CGRectGetWidth(_frame), 0.7)];
    lineView.backgroundColor = HEXCOLOR(0xcccccc);
    [self addSubview:lineView];
}

-(void)tapAction:(UIGestureRecognizer *)gesture {
    if (self.headerClick) {
        self.headerClick();
    }
}

@end
