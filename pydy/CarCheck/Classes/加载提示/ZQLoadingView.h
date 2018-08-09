//
//  ZQLoadingView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQLoadingView : NSObject

+ (void)showAlertHUD:(NSString *)aString duration:(CGFloat)duration;
+ (void)showProgressHUD:(NSString *)aString duration:(CGFloat)duration;
+ (void)showProgressHUD:(NSString *)aString;
+ (void)hideProgressHUD;
+ (void)updateProgressHUD:(NSString*)progress;
+ (void)makeSuccessfulHudWithTips:(NSString *)tips parentView:(UIView *)view;
@end
