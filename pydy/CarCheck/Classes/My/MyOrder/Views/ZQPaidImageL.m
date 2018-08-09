//
//  ZQPaidImageL.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/7/4.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQPaidImageL.h"

@implementation ZQPaidImageL

- (instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"paid_icon"];
        frame.size = self.image.size;
        self.frame = frame;
        [self addSubview:self.desLabel];
    }
    return self;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-5)];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.font = [UIFont systemFontOfSize:11];
    }
    return _desLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
