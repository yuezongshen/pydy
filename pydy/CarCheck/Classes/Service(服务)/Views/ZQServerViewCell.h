//
//  ZQServerViewCell.h
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQServerViewCell : UICollectionViewCell

-(void)writeDataWithTitle:(NSString *)str imageStr:(NSString *)imgStr;
-(void)writDataWithModel:(NSDictionary *)mDic;
@end
