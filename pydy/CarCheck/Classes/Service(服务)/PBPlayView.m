//
//  PBPlayView.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/26.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBPlayView.h"

@interface PBPlayView ()

@end
@implementation PBPlayView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = LH_RGBCOLOR(241,239,235);
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 1)];
        lineView.backgroundColor = __DefaultColor;
        [self addSubview:lineView];
        
        [self addSubview:self.playBtn];
        [self addSubview:self.titleLabel];
        [self addSubview:self.nextBtn];
        [self addSubview:self.listBtn];
    }
    return self;
}

- (void)playBtnAction:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    if (sender.selected) {
        if ([self.playString isKindOfClass:[NSString class]]) {
            if (self.playString.length)
            {
                return;
            }
        }
        [ZQLoadingView showAlertHUD:@"播放内容为空" duration:SXLoadingTime];
        sender.selected = NO;
    }
}
- (void)playActionWithString:(NSString *)str
{
    if ([str isKindOfClass:[NSString class]]) {
        if (str.length) {
            self.playString = str;
            [self.playBtn setSelected:YES];
            [self performSelector:@selector(pStartAction:) withObject:str afterDelay:1.0];
            return;
        }
    }
    [ZQLoadingView showAlertHUD:@"播放内容为空" duration:SXLoadingTime];
}
- (void)pStartAction:(NSString *)str
{
   

}

- (void)checkPlayBtnStatus:(BOOL)temp
{
    self.playBtn.selected = temp;

}
- (UIButton *)playBtn
{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setFrame:CGRectMake(30, 10, 30, 30)];
        [_playBtn setImage:[UIImage imageNamed:@"play_image"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"stop_image"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, 10, 30, 30)];
        [_nextBtn setImage:[UIImage imageNamed:@"next_image"] forState:UIControlStateNormal];
//        [_nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
- (UIButton *)listBtn
{
    if (!_listBtn) {
        _listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_listBtn setFrame:CGRectMake(CGRectGetMaxX(_nextBtn.frame)+10, 10, 30, 30)];
        [_listBtn setImage:[UIImage imageNamed:@"directory"] forState:UIControlStateNormal];
//        [_listBtn addTarget:self action:@selector(listBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listBtn;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_playBtn.frame)+10, 15, CGRectGetWidth(self.frame)-CGRectGetMinX(_playBtn.frame)-CGRectGetMaxX(_playBtn.frame)-10-10-70, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.viewAction) {
        self.viewAction();
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
