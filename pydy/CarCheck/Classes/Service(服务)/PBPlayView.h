//
//  PBPlayView.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/26.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^playViewAction)(void);

@interface PBPlayView : UIView

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *listBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSString *playString;

@property (nonatomic, copy) playViewAction viewAction;
- (void)playActionWithString:(NSString *)str;
- (void)checkPlayBtnStatus:(BOOL)temp;
@end
