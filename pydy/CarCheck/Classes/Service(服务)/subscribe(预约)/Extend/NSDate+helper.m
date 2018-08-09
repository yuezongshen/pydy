//
//  NSDate+helper.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/16.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "NSDate+helper.h"

@implementation NSDate (helper)

//获取两个日期之间的所有日期，包括起始和截止日期
+ (NSArray *)datesFromStartDate:(NSDate *)startDate toEndDate:(NSDate *)endDate
{
    if (!startDate && !endDate)
        return nil;
    
    if ([startDate earlierDate:endDate] == endDate)
        return nil;
    
    NSMutableArray *datesArray = [NSMutableArray array];
    if (!startDate && endDate)
    {
        [datesArray addObject:endDate];
        return datesArray;
    }
    
    if (startDate && !endDate)
    {
        [datesArray addObject:startDate];
        return datesArray;
    }
    
    [datesArray addObject:startDate];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSTimeInterval startTime = [startDate timeIntervalSince1970];
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    
    for (NSTimeInterval time = startTime + secondsPerDay; time < endTime; time += secondsPerDay)
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        [datesArray addObject:date];
    }
    
    [datesArray addObject:endDate];
    return datesArray;
}
- (NSDate *)dateAfterDay:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterDay;
}
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(NSInteger)week
{
    NSString *str_week;
    
    switch (week) {
        case 1:
            str_week = @"星期日";
            break;
        case 2:
            str_week = @"星期一";
            break;
        case 3:
            str_week = @"星期二";
            break;
        case 4:
            str_week = @"星期三";
            break;
        case 5:
            str_week = @"星期四";
            break;
        case 6:
            str_week = @"星期五";
            break;
        case 7:
            str_week = @"星期六";
            break;
    }
    return str_week;
}
@end
