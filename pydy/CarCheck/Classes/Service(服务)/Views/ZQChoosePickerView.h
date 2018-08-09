//
//  ZQChoosePickerView.h
//  CarCheck
//
//  Created by zhangqiang on 2017/11/1.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZQBlock)(NSString *seletedStr);
typedef void(^ZQIndexBlock)(NSInteger seletedIndex);


@interface ZQChoosePickerView : UIView

// 显示pickView
-(void)showWithDataArray:(NSArray *)dataArray inView:(UIView *)view chooseBackBlock:(ZQBlock )block;

-(void)showDataArray:(NSArray *)dataArray inView:(UIView *)view chooseBackBlock:(ZQIndexBlock )block;

@end
