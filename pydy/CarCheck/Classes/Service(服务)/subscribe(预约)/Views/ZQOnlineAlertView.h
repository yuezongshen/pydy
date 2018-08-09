//
//  ZQOnlineAlertView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQOnlineAlertView : UIView

@property (nonatomic, copy) void (^handler)(NSArray *contenArr);
- (void)show;
@end
