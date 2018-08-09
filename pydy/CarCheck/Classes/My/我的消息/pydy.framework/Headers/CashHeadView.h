//
//  CashHeadView.h
//  pydy
//
//  Created by FYXJ（6） on 2018/7/27.
//  Copyright © 2018年 FYXJ（6）. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WithDrawClick)(NSString *);

@interface CashHeadView : UIView

@property (nonatomic, copy) WithDrawClick wDrawClick;

- (void)configTableHeadView:(NSDictionary *)dic;
@end
