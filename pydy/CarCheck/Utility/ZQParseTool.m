//
//  ZQParseTool.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/28.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQParseTool.h"

@implementation ZQParseTool

//字典转字符串
+(NSString *)jsonDict:(NSDictionary *)dict {
    
    NSArray *allKeys = [dict allKeys];
    NSMutableString *jsonStr = [NSMutableString string];
    for (NSString *key in allKeys) {
        NSString *value = [dict valueForKey:key];
        [jsonStr appendFormat:@"\"%@\":\"%@\",",key,value];
    }
    if (jsonStr.length) {
        NSString *paramStr = [jsonStr substringToIndex:jsonStr.length - 1];
        return [NSString stringWithFormat:@"{%@}",paramStr];
    }
    return @"";
}

@end
