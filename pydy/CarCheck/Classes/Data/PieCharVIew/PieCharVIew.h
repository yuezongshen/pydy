//  饼状图
//  PieCharView.h
//  TestBtn
//
//  Created by 许文波 on 15/12/25.
//  Copyright © 2015年 许文波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieCharModel.h"

@interface PieCharView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIFont *textFont; // 字体大小
@property (nonatomic, strong) UIColor *textColor; // 字体颜色
@property (nonatomic, assign) CGFloat radius; // 半径

@end
