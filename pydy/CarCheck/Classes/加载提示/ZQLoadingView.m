//
//  ZQLoadingView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

UIWindow *_mainWindow() {
    return [UIApplication sharedApplication].keyWindow;
}

#import "ZQLoadingView.h"
#import "MBProgressHUD.h"

static MBProgressHUD  *s_progressHUD = nil;

@implementation ZQLoadingView

+ (void)showProgressHUD:(NSString *)aString duration:(CGFloat)duration {
    [self hideProgressHUD];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:_mainWindow()];
    for (id obj in _mainWindow().subviews) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [obj removeFromSuperview];
        }
    }
    [_mainWindow() addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.label.text = aString;
    
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.bezelView.opaque = NO;
    [progressHUD showAnimated:YES];
    [progressHUD hideAnimated:YES afterDelay:duration];
//    progressHUD.opacity = 0.7;
//    [progressHUD show:NO];
//    [progressHUD hide:YES afterDelay:duration];
}

+ (void)showProgressHUD:(NSString *)aString {
    if (!s_progressHUD) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            s_progressHUD = [[MBProgressHUD alloc] initWithView:_mainWindow()];
        });
    }else{
        [s_progressHUD hideAnimated:NO];
    }
    for (id obj in _mainWindow().subviews) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [obj removeFromSuperview];
        }
    }
    [_mainWindow() addSubview:s_progressHUD];
    s_progressHUD.removeFromSuperViewOnHide = YES;
    s_progressHUD.animationType = MBProgressHUDAnimationZoom;
    if ([aString length]>0) {
//        s_progressHUD.labelText = aString;
        s_progressHUD.label.text = aString;
    }
//    else s_progressHUD.labelText = nil;
    else s_progressHUD.label.text = nil;

//    s_progressHUD.opacity = 0.7;
//    [s_progressHUD show:YES];
    s_progressHUD.bezelView.opaque = NO;
    [s_progressHUD showAnimated:YES];
}

+ (void)showAlertHUD:(NSString *)aString duration:(CGFloat)duration {
//    [self hideProgressHUD];
    if (s_progressHUD) {
        [s_progressHUD hideAnimated:NO];
    }
    for (id obj in _mainWindow().subviews) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [obj removeFromSuperview];
        }
    }
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:_mainWindow()];
    [_mainWindow() addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.label.text = aString;
    progressHUD.label.numberOfLines = 0;
//    progressHUD.labelText =aString;
    progressHUD.removeFromSuperViewOnHide = YES;
//    progressHUD.opacity = 0.7;
    progressHUD.bezelView.opaque = NO;
    progressHUD.mode = MBProgressHUDModeText;
//    [progressHUD show:NO];
    [progressHUD showAnimated:YES];
    [progressHUD hideAnimated:YES afterDelay:duration];
//    [progressHUD hide:YES afterDelay:duration];
}

+ (void)hideProgressHUD {
    if (s_progressHUD) {
//        [s_progressHUD hide:YES];
        [s_progressHUD hideAnimated:YES];
    }
}

+ (void)updateProgressHUD:(NSString*)progress {
    if (s_progressHUD) {
        s_progressHUD.label.text = progress;
    }
}
+ (void)makeSuccessfulHudWithTips:(NSString *)tips parentView:(UIView *)view
{
    [self hideProgressHUD];
    for (id obj in _mainWindow().subviews) {
        if ([obj isKindOfClass:[MBProgressHUD class]]) {
            [obj removeFromSuperview];
        }
    }
    MBProgressHUD *mbProgressHud = [[MBProgressHUD alloc] initWithView:_mainWindow()];
    [_mainWindow() addSubview:mbProgressHud];
//    mbProgressHud.dimBackground = NO;
    mbProgressHud.animationType = MBProgressHUDAnimationZoomOut;
    mbProgressHud.mode = MBProgressHUDModeCustomView;
    mbProgressHud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doneRight"]];
    mbProgressHud.label.text = tips;
    [mbProgressHud showAnimated:YES];
    [mbProgressHud hideAnimated:YES afterDelay:1.5];
//    [mbProgressHud show:YES];
//    [mbProgressHud hide:YES afterDelay:1.5];

}
@end
