//
//  PBPlayBtnView.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/29.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBPlayBtnView.h"

@interface PBPlayBtnView ()

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *upBtn;
@end


@implementation PBPlayBtnView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //        self.backgroundColor = LH_RGBCOLOR(241,239,235);
//        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.playBtn];
        [self addSubview:self.nextBtn];
        [self addSubview:self.upBtn];
    }
    return self;
}

- (void)playDone
{
    [self.playBtn setSelected:NO];
}

- (void)nextBtnAction
{
    if (self.nextAction) {
        self.nextAction();
    }
}
- (void)upBtnAction
{
    if (self.upAction) {
        self.upAction();
    }
}
- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setFrame:CGRectMake(0, 0, 45, 45)];
        _playBtn.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [_playBtn setImage:[UIImage imageNamed:@"play_on_image"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"stop_on_image"] forState:UIControlStateSelected];
    }
    return _playBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setFrame:CGRectMake(CGRectGetMaxX(_playBtn.frame)+30, 17, 21, 21)];
        [_nextBtn setImage:[UIImage imageNamed:@"play_next_image"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
- (UIButton *)upBtn
{
    if (!_upBtn) {
        _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_upBtn setFrame:CGRectMake(CGRectGetMinX(_playBtn.frame)-30-21, 17, 21, 21)];
        [_upBtn setImage:[UIImage imageNamed:@"play_up_image"] forState:UIControlStateNormal];
        [_upBtn addTarget:self action:@selector(upBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
