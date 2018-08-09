//
//  ZQInspectionCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZQInspectionModel.h"
@interface ZQInspectionCell : UITableViewCell

@property (nonatomic, strong) ZQInspectionModel *inspectionModel;

+ (CGFloat)inspectionCellHeight;
@end
