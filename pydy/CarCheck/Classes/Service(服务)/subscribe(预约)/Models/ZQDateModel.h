//
//  ZQDateModel.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/17.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQDateModel : NSObject

@property (nonatomic, assign) NSInteger dMonth;
@property (nonatomic, copy) NSString *dDay;
@property (nonatomic, copy) NSString *dWeek;
@property (nonatomic, strong) NSDate *dDate;
@property (assign, nonatomic) BOOL isSelected;
@end
