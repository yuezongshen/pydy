//
//  UdStorage.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQMessageModel.h"

@interface UdStorage : NSObject
//我的订单列表
+(NSMutableArray *)getOrderModelWithArray:(NSArray *)array;
//消息列表
+(NSMutableArray *)getMessageModelWithArray:(NSArray *)array;
@end
