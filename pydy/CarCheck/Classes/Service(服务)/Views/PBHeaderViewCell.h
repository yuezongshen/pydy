//
//  PBHeaderViewCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/15.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQOrderObject;
@class ZQBannerModel;

typedef void(^reloadHomeView)(void);
@interface PBHeaderViewCell : UICollectionViewCell

@property (nonatomic, copy) reloadHomeView reloadHomeV;
@property (nonatomic, strong) ZQOrderObject *orderObj;

@property (nonatomic,strong) UIButton *operateBtn;
@end
