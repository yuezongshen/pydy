//
//  ZQAppointmentHeaderView.h
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeaderClick)(void);
@interface ZQAppointmentHeaderView : UICollectionReusableView

@property (nonatomic, copy) HeaderClick headerClick;

@end
