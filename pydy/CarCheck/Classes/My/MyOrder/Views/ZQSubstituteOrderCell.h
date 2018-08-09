//
//  ZQSubstituteOrderCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/1.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQSubstituteOrderModel.h"

@interface ZQSubstituteOrderCell : UITableViewCell

+ (CGFloat)SubstituteOrderCellHeight;
@property (nonatomic, strong) UIButton *substitutePayBtn;
@property (nonatomic, strong) ZQSubstituteOrderModel *orderModel;
@end
