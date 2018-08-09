//
//  ZQInspectionListController.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    ZQSubScTypeDefailt,
    ZQSubScTypeCellPhone,
    ZQSubScTypeVisit,
    ZQSubScTypeNone,
} ZQSubScType;

@interface ZQInspectionListController : BaseViewController

@property(nonatomic,assign)ZQSubScType subType;

@end
