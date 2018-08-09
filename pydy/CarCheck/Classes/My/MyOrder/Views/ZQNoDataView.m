//
//  ZQNoDataView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNoDataView.h"

@interface ZQNoDataView ()
@end

@implementation ZQNoDataView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.noOrderImgV];
        [self addSubview:self.noOrderLabel];
    }
    return self;
}
- (UIImageView *)noOrderImgV
{
    if (!_noOrderImgV) {
        _noOrderImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_noOrderImgV setCenter: self.center];
        _noOrderImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _noOrderImgV;
}
- (UILabel *)noOrderLabel
{
    if (!_noOrderLabel) {
        _noOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_noOrderImgV.frame), CGRectGetWidth(self.frame), 20)];
        _noOrderLabel.textColor = __TextColor;
        _noOrderLabel.font = [UIFont systemFontOfSize:12];
        _noOrderLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noOrderLabel;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.reloadPageAction) {
        self.reloadPageAction();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
