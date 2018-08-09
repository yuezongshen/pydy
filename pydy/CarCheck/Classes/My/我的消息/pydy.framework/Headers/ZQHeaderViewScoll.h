//
//  ZQHeaderViewScoll.h
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeaderBtnAction)(NSInteger);

@interface ZQHeaderViewScoll : UICollectionReusableView

@property (nonatomic, copy) HeaderBtnAction headerBtnAction;
- (void)configHeaderViewWithDic:(NSDictionary *)dic;
@end
