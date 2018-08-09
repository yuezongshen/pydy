//
//  BaseTabBarViewController.h
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarViewController : UITabBarController

@property (strong,nonatomic) UIView *tabBarV;

@property (nonatomic) NSInteger  selectIndex;

@end
