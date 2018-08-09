//
//  ZQVIPFootView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/19.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQVIPFootView.h"

@implementation ZQVIPFootView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
                self.backgroundColor = LH_RGBCOLOR(241,239,235);
        UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0,  8,CGRectGetWidth(frame), 40)];
        bottomV.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomV];
        
//        CGFloat width = CGRectGetWidth(self.view.bounds)/2;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(12, 0, 40, 40)];
        [button setImage:[UIImage imageNamed:@"unAgree"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateSelected];
        [bottomV addSubview:button];
        self.agreenBtn = button;
        
        UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 30, 20)];
        agreeLabel.text = @"同意";
        agreeLabel.textColor = [UIColor lightGrayColor];
        agreeLabel.font = [UIFont systemFontOfSize:13.0];
        [bottomV addSubview:agreeLabel];
        
        self.aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_aButton setFrame:CGRectMake(CGRectGetMaxX(agreeLabel.frame),10,140, 20)];
        _aButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_aButton setTitleColor:LH_RGBCOLOR(17,149,232) forState:UIControlStateNormal];
        [_aButton setTitle:@"《VIP用户服务须知》" forState:UIControlStateNormal];
        [bottomV addSubview:_aButton];
        
    }
    return self;
}
@end
