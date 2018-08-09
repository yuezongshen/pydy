//
//  ZQMyOrderViewController.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
typedef enum
{
    ZQToBeConfirmView = 0,        //待确认
    ZQInProcessOrdersView,      //进行中
    ZQSucessOrdersView,         //已成功
} ZQOrderViewType;

@interface ZQMyOrderViewController : BaseViewController

- (instancetype)initWithOrderViewType:(ZQOrderViewType)orderType;
@property (nonatomic, assign) ZQOrderViewType currentViewType; 
@end
