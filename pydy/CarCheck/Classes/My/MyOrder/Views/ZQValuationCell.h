//
//  ZQValuationCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/18.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RoloadTableViewCell)(UIButton *temBtn);

@class ZQValuationModel;
@interface ZQValuationCell : UITableViewCell

@property (strong,nonatomic) UIButton *openUpBtn;
@property (copy,nonatomic) RoloadTableViewCell reloadCell;
+ (CGFloat)getValuationCellHeight;

- (void)configValuationCell:(ZQValuationModel *)vModel;
@end
