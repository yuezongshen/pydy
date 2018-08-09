//
//  ZQTimeCollectionViewCell.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQTimeCollectionViewCell.h"

@implementation ZQTimeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.timeLabel.layer.cornerRadius = 5;
    self.timeLabel.clipsToBounds = YES;
    // Initialization code
}

@end
