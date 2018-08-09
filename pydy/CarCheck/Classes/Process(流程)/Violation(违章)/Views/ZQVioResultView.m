//
//  ZQVioResultView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQVioResultView.h"

@interface ZQVioResultView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *vTitleL;
@property (nonatomic, strong) UILabel *vContentL;
@property (nonatomic, strong) UILabel *vFenL;
@property (nonatomic, strong) UILabel *vDateL;

@property (nonatomic, strong) UIButton *confirmBtn;
@end
@implementation ZQVioResultView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.vTitleL];
        [self.alertView addSubview:self.vContentL];
        [self.alertView addSubview:self.vFenL];
        [self.alertView addSubview:self.vDateL];
    }
    return self;
}

- (void)setContentDic:(NSDictionary *)contentDic
{
    if ([_contentDic isEqual:contentDic]) {
        return;
    }
    NSString *act = contentDic[@"act"];
    CGFloat maginX = 10;
    CGFloat vWidth = CGRectGetWidth(self.alertView.frame)-2*maginX;
    CGSize size = [act boundingRectWithSize:CGSizeMake(vWidth, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if (size.height >(CGRectGetHeight(self.alertView.frame)-140)) {
        CGRect rect = self.alertView.frame;
        rect.size.height = size.height+180;
        [self.alertView setFrame:rect];
        self.alertView.center = self.center;
    }
    [self.vContentL setFrame:CGRectMake(maginX, CGRectGetMaxY(_vTitleL.frame), vWidth, size.height+20)];
    [self.vFenL setFrame:CGRectMake(maginX, CGRectGetMaxY(_vContentL.frame), vWidth, 30)];
    [self.vDateL setFrame:CGRectMake(maginX, CGRectGetMaxY(_vFenL.frame), vWidth, 30)];
    [self.vTitleL setText:contentDic[@"area"]];
    [self.vContentL setText:act];
    [self.vFenL setText:[NSString stringWithFormat:@"罚款%@元,记%@分",contentDic[@"money"],contentDic[@"fen"]]];
    [self.vDateL setText:contentDic[@"date"]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake((vWidth-100)/2,CGRectGetHeight(self.alertView.frame)-45,100, 30)];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:LH_RGBCOLOR(17,149,232)];
    [button setTitle:@"确 定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    [_alertView addSubview:button];
}
- (void)commitBtnAction
{
    [self close];
}
- (void)show
{
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    self.alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.alertView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
                        self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                         self.alertView.alpha = 1.0f;
                         
                     }
                     completion:nil
     ];
}

- (void)close
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.bgView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.alertView.alpha = 0.0f;
                         self.bgView.alpha = 0;
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}
- (UILabel *)vTitleL
{
    if (!_vTitleL) {
        _vTitleL = [[UILabel alloc] initWithFrame:CGRectMake(0,10, CGRectGetWidth(self.alertView.frame), 30)];
        _vTitleL.font = [UIFont boldSystemFontOfSize:16];
        [_vTitleL setTextAlignment:NSTextAlignmentCenter];
        _vTitleL.textColor = [UIColor blackColor];
    }
    return _vTitleL;
}
- (UILabel *)vContentL
{
    if (!_vContentL) {
        _vContentL = [[UILabel alloc] init];
        _vContentL.font = [UIFont systemFontOfSize:15];
        _vContentL.textColor = [UIColor darkTextColor];
        [_vContentL setTextAlignment:NSTextAlignmentCenter];
        _vContentL.numberOfLines = 0;
    }
    return _vContentL;
}
- (UILabel *)vFenL
{
    if (!_vFenL) {
        _vFenL = [[UILabel alloc] init];
        _vFenL.font = [UIFont systemFontOfSize:15];
        _vFenL.textColor = [UIColor darkTextColor];
    }
    return _vFenL;
}
- (UILabel *)vDateL
{
    if (!_vDateL) {
        _vDateL = [[UILabel alloc] init];
        _vDateL.font = [UIFont systemFontOfSize:15];
        _vDateL.textColor = [UIColor darkTextColor];
        [_vDateL setTextAlignment:NSTextAlignmentRight];
    }
    return _vDateL;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    }
    return _bgView;
}
- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame)-40, 300)];
        _alertView.center = self.center;
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 10;
    }
    return _alertView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
