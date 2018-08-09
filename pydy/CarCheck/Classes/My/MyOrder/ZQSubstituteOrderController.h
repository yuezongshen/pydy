//
//  ZQSubstituteOrderController.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/1.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

typedef enum
{
    ZQSubAllOrdersView = 0,        //全部
    ZQSubInProcessOrdersView,      //处理中
    ZQSubSucessOrdersView,         //已成功
    ZQSubRevocationOrdersView,     //已撤销
} ZQSubOrderViewType;

@interface ZQSubstituteOrderController : BaseViewController

@property (nonatomic, assign) ZQSubOrderViewType currentViewType;

@end
