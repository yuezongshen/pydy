//
//  PBClerkView.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/19.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClerkViewAction)(void);

@interface PBClerkView : UIView

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, copy) ClerkViewAction clerkViewAction;
- (void)setcontentData:(NSDictionary *)dic;
@end
