//
//  PBHomeHeadView.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/15.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBHomeHeadView.h"

@interface PBHomeHeadView ()

@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UIButton *detailBtn;

@end
@implementation PBHomeHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView *redV = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 3, 20)];
    redV.backgroundColor = __DefaultColor;
    [self addSubview:redV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(redV.frame)+5, 10, 90, 20)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = @"工作动态";
    [self addSubview:_titleLabel];
    
    _detailBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-105, 10, 95, 20)];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_detailBtn setTitleColor:[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_detailBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [_detailBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    [_detailBtn setTitle:@"更多" forState:UIControlStateNormal];
    [_detailBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    _detailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 17);
    _detailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 75, 0, 0);
    [self addSubview:_detailBtn];
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 39, __kWidth, 1)];
    footV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:footV];
}
- (void)detailAction
{
    if (self.headerClick) {
        self.headerClick();
    }
}
-(void)setTitle:(NSString *)title{
    if ([title isKindOfClass:[NSString class]]) {
        if (title.length) {
         [self.titleLabel setText:title];
        }
    }
}

//-(void)setDetail:(NSString *)detail{
//    [_detailBtn setTitle:detail forState:UIControlStateNormal];
//}
@end
