//
//  ZQAreaView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQAreaModel.h"

@interface ZQAreaView : UIView

@property (nonatomic, copy) void (^handler)(ZQAreaModel *areaModel);
- (instancetype)initWithFrame:(CGRect)frame provinceId:(NSString *)pId;
@end
