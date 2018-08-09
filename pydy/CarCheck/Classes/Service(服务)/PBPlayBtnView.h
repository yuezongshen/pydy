//
//  PBPlayBtnView.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/29.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^playViewNextAction)(void);
typedef void(^playViewUpAction)(void);

@interface PBPlayBtnView : UIView

@property (nonatomic, copy) playViewNextAction nextAction;
@property (nonatomic, copy) playViewUpAction upAction;
@property (nonatomic, strong) UIButton *playBtn;
- (void)playDone;

@end
