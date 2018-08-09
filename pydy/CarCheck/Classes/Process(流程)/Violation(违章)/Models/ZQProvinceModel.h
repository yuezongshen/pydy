//
//  ZQProvinceModel.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQProvinceModel : NSObject

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *province_code;
@property (nonatomic, strong) NSArray *citys;
@end
