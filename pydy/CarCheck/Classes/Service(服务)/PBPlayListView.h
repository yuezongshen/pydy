//
//  PBPlayListView.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/26.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^playListCellAction)(NSInteger);

@interface PBPlayListView : UIView

@property (nonatomic, strong) NSArray *playListArr;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, assign) NSInteger seletedIndex;
@property (nonatomic, assign) BOOL isMyDataList;
@property (nonatomic, copy) playListCellAction cellAction;
@end
