//
//  ZQNoDataView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReloadPageAction)(void);
@interface ZQNoDataView : UIView

@property (nonatomic, copy)   ReloadPageAction reloadPageAction;
@property (nonatomic, strong) UIImageView *noOrderImgV;
@property (nonatomic, strong) UILabel *noOrderLabel;
@end
