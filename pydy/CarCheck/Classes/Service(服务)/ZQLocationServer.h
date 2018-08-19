//
//  ZQLocationServer.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/8/19.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQLocationServer : NSObject

@property (nonatomic, copy)NSString *orderNo;
+ (instancetype)shareInstance;
- (void)starLoction;
- (void)stopLoction;
@end
