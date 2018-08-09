//
//  ZQOrderCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQNewCarOrderModel.h"

@interface ZQOrderCell : UITableViewCell

+ (CGFloat)OrderCellHeight;
@property (nonatomic, strong) UIButton *newCarPayBtn;
@property (nonatomic, strong) ZQNewCarOrderModel *orderModel;
@end
