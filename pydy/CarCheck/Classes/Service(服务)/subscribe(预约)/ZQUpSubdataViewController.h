//
//  ZQUpSubdataViewController.h
//  CarCheck
//
//  Created by zhangqiang on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQUpSubdataViewController : BaseViewController

@property (assign,nonatomic) CGFloat serviceCharge;  //服务费

@property (assign,nonatomic) NSInteger bookingType; //1.在线 2. 上门

@property (copy,nonatomic) NSString *b_testing_id; //检车机构id
@end
