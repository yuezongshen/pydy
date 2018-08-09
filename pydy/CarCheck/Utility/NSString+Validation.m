//
//  NSString+Validation.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/18.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "NSString+Validation.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Validation)

- (BOOL)isValidMobilePhoneNumber
{
    NSString *mobileNum = self;
    NSString *regexStr = @"^1[3|4|5|6|7|8|9][0-9]{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES) {
        return YES;
    }
    return NO;
}
-(NSString *)md5Encrypt
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, strlen(cStr), digest );
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
- (NSString *)trimDoneString
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@" "];
}
- (NSString *)dealWithString
{
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < self.length; i++) {
        
        count++;
        doneTitle = [doneTitle stringByAppendingString:[self substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }
    }
    return doneTitle;
}
- (NSString *)noEmptyString
{
    NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];

    NSArray *parts = [self componentsSeparatedByCharactersInSet:whitespaces];
    NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [filteredArray componentsJoinedByString:@""];
}
@end
