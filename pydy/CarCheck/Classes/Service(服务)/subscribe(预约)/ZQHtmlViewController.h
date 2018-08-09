//
//  ZQHtmlViewController.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"
#import "ZQInspectionModel.h"

@interface ZQHtmlViewController : BaseViewController

- (id)initWithUrlString:(NSString *)urlString andShowBottom:(NSInteger)isShow;
- (id)initWithUrlString:(NSString *)urlString testId:(NSString *)t_id andShowBottom:(NSInteger)isShow;

@property (nonatomic, copy) NSString *classString;
@property (nonatomic, assign) CGFloat charge;

@property (nonatomic,assign) NSInteger dSubType;

@property (nonatomic,strong) ZQInspectionModel *inModel;
@end
