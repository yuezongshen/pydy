//
//  PBClerkView.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/19.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBClerkView.h"
#import "UIImageView+WebCache.h"

@interface PBClerkView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *desLabel;

@end


@implementation PBClerkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgV];
        [self addSubview:self.titleLabel];
        [self addSubview:self.desLabel];
        
        UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 6) - 10, (CGRectGetHeight(frame)-23/2)/2, 6, 23/2)];
        imageRight.image = [UIImage imageNamed:@"shouyejiantou"];
        [self addSubview:imageRight];
    }
    return self;
}
- (void)setcontentData:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseAPI,dic[@"imgurl"]]] placeholderImage:[UIImage imageNamed:@"user_head"]];
        
        self.titleLabel.text = [Utility verifyActionWithString:dic[@"MemberName"]];
        self.desLabel.text = [Utility verifyActionWithString:dic[@"dangneizhiwu"]];
        return;
    }
    [self.imgV setImage:[UIImage imageNamed:@"user_head"]];
    self.titleLabel.text = @"请先登录";
    self.desLabel.text = @"党内职务";
}
- (UIImageView *)imgV
{
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.cornerRadius = 25;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+10, 15, 100, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+10, CGRectGetWidth(_titleLabel.frame), 15)];
        _desLabel.font = [UIFont systemFontOfSize:15];
        _desLabel.textColor = [UIColor lightGrayColor];
    }
    return _desLabel;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.clerkViewAction) {
        self.clerkViewAction();
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
