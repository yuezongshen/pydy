//
//  NSDictionary+propertyCode.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/27.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "NSDictionary+propertyCode.h"

@implementation NSDictionary (propertyCode)

- (void)createProperty {
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
    if ([value isKindOfClass:[NSString class]]) {
        NSLog(@"%@", [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;", key]);
    }else if ([value isKindOfClass:[NSArray class]]) {
        NSLog(@"%@", [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@", key]);
    }else if ([value isKindOfClass:[NSNumber class]]) {
        NSLog(@"%@", [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger key;"]);
    }}];
}
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    
    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [str appendFormat:@"\t%@ = %@,\n", key, obj];
    }];
    
    [str appendString:@"}"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length != 0) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end
