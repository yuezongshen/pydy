//
//  ZQProCityPickerV.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZQProvinceBlock)(id seletedModel);

@interface ZQProCityPickerV : UIView

// 显示pickView
-(void)showWithProvinceArray:(NSArray *)dataArray inView:(UIView *)view chooseBackBlock:(ZQProvinceBlock)block;
@end
