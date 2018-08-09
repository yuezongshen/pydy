//
//  ZQVoiceRecordController.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/7/7.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^UpdateRecordStr)(NSString *);

@interface ZQVoiceRecordController : BaseViewController

@property (nonatomic, copy) UpdateRecordStr updateRecordUrl;
@end
