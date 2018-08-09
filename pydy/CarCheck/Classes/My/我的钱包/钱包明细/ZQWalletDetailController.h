//
//  ZQWalletDetailController.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/10.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

typedef enum
{
    ZQAllDataView = 0,               //全部
    ZQIncomeView,                    //收入
    ZQPayView,                       //支出
} ZQWalletType;

@interface ZQWalletDetailController : BaseViewController

@property (nonatomic, assign) ZQWalletType currentWalletType;
@end
