//
//  PBPayListCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/20.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBPayListCell : UITableViewCell

@property (nonatomic, strong) UIButton *payBtn;
+ (CGFloat)PayListCellHeight;
- (void)setPayListContent:(NSDictionary *)cDic;
@end
