//
//  ZQMyBooingCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQOrderObject;
@interface ZQMyBooingCell : UITableViewCell

@property (nonatomic, strong) ZQOrderObject *orderModel;

@property (nonatomic, strong) UIButton *operateBtn;
+(CGFloat)myBooingCellHeight;
- (void)configOrderViewCell:(ZQOrderObject *)orderObj;
@end
