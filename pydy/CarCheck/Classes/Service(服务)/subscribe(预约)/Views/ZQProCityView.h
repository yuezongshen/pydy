//
//  ZQProCityView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/20.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQProCityView : UIView

@property (nonatomic, copy) void (^handler)(NSString *proCityStr);
@end
