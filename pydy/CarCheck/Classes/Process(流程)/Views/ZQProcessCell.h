//
//  ZQProcessCell.h
//  CarCheck
//
//  Created by zhangqiang on 2017/9/27.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQProcessCellDelegate

-(void)selectAtRow:(NSInteger )row index:(NSInteger )index;

@end


@interface ZQProcessCell : UITableViewCell

@property(nonatomic,strong)NSArray *dataArray;

@property(strong,nonatomic)UIColor *color;

@property(copy,nonatomic)NSString *title;

@property(nonatomic,assign)id<ZQProcessCellDelegate> delegate;
// 数据初始化
-(void)writeDataWithArray:(NSArray *)dataArray color:(UIColor *)color title:(NSString *)title;

@end
