//
//  ZQValuationModel.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/7/4.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQValuationModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *updatetime;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSString *scenicname;

@property (nonatomic, assign) BOOL isOpenUp;
@property (nonatomic, assign) CGFloat desTextSize;
@end

