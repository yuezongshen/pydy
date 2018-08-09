//
//  NSString+Validation.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/18.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL)isValidMobilePhoneNumber;
- (NSString *) md5Encrypt;
- (NSString *)trimDoneString;

- (NSString *)dealWithString;
- (NSString *)noEmptyString;
@end
