//
//  UdStorage.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "UdStorage.h"
#import "ZQOrderModel.h"

@implementation UdStorage

//订单列表
+(NSMutableArray *)getOrderModelWithArray:(NSArray *)array
{
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in array) {
        ZQOrderModel *model = [[ZQOrderModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [mutArray addObject:model];
    }
    return mutArray;
}
//消息列表
+(NSMutableArray *)getMessageModelWithArray:(NSArray *)array
{
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in array) {
        ZQMessageModel *model = [[ZQMessageModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [mutArray addObject:model];
    }
    return mutArray;
}
@end
