//
//  PBHomeHeadView.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/15.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeaderClick)(void);

@interface PBHomeHeadView : UICollectionReusableView

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *detail;
@property (nonatomic, copy) HeaderClick headerClick;

@end
