//
//  ZQSuccessAlerView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQSuccessAlerView.h"

@interface ZQSuccessAlerView ()

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIButton *bgViewBtn;
@end

@implementation ZQSuccessAlerView

+ (void)showCommitSuccess
{
    ZQSuccessAlerView *successAlerView = [[ZQSuccessAlerView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [successAlerView show];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.bgViewBtn];
        [self addSubview:self.alertView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doneRight"]];
        imageView.center = CGPointMake(CGRectGetWidth(self.alertView.frame)/2, 50);
        [self.alertView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, CGRectGetWidth(self.alertView.frame), 30)];
        label.text = @"上传成功";
        label.textColor = [UIColor greenColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:20];
        [self.alertView addSubview:label];
        
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+30, CGRectGetWidth(self.alertView.frame), 20)];
        desLabel.textColor = [UIColor lightGrayColor];
        desLabel.textAlignment = NSTextAlignmentCenter;
        desLabel.text = @"提示: 随后工作人员联系";
        desLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.alertView addSubview:desLabel];
    }
    return self;
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
                         
                         self.bgViewBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                         self.alertView.alpha = 1.0f;
                         
                     }
                     completion:nil
     ];
    [self performSelector:@selector(close) withObject:nil afterDelay:5];
}

- (void)close
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.bgViewBtn.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.alertView.alpha = 0.0f;
                         self.bgViewBtn.alpha = 0;
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

- (UIButton *)bgViewBtn
{
    if (!_bgViewBtn) {
        _bgViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgViewBtn.frame = self.bounds;
        _bgViewBtn.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        [_bgViewBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgViewBtn;
}
- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
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
