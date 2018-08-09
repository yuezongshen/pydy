//
//  ZQNewCarOrderViewController.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/1.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
typedef enum
{
    ZQNewCarAllOrdersView = 0,        //全部
    ZQNewCarInProcessOrdersView,      //处理中
    ZQNewCarSucessOrdersView,         //已成功
    NewCarRevocationOrdersV,     //已撤销
} ZQNewCarOrderViewType;

@interface ZQNewCarOrderViewController : BaseViewController

@property (nonatomic, assign) ZQNewCarOrderViewType currentViewType;

@end
