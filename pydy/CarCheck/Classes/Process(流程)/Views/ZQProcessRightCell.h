//
//  ZQProcessRightCell.h
//  CarCheck
//
//  Created by zhangqiang on 2017/9/27.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQProcessRightCellDelegate

-(void)selectRightAtRow:(NSInteger )row index:(NSInteger )index;

@end

@interface ZQProcessRightCell : UITableViewCell

@property(nonatomic,strong)NSArray *dataArray;

@property(strong,nonatomic)UIColor *color;

@property(copy,nonatomic)NSString *title;

@property(assign,nonatomic)id<ZQProcessRightCellDelegate> delegate;

// 数据初始化
-(void)writeDataWithArray:(NSArray *)dataArray color:(UIColor *)color title:(NSString *)title;

@end
