//
//  NSDate+helper.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/16.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (helper)

+ (NSArray *)datesFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate;
- (NSDate *)dateAfterDay:(NSInteger)day;
+(NSString *)getWeekStringFromInteger:(NSInteger)week;
@end
