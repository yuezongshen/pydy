//
//  ZQAlerInputView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, ELAlertActionStyle)
//{
//    ELAlertActionStyleSift = 0,
//    ELAlertActionStyleBooking,
//};

@interface ZQAlerInputView : UIView

@property (nonatomic, copy) void (^handler)(NSArray *contenArr);

- (void)show;
@end
