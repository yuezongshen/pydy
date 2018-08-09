//
//  ZQVIPBuyCardView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/19.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQVIPModel.h"

@interface ZQVIPBuyCardView : UICollectionReusableView

@property (nonatomic, strong) UIButton *introduceBtn;
- (void)configBuyCardViewWithModel:(ZQVIPModel *)model;
@end
