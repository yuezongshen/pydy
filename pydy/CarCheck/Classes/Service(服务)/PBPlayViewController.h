//
//  PBPlayViewController.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/29.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"


//typedef void(^NextUpBtnCallBackAction)(NSInteger);
@protocol PBPlayViewControllerDelegate <NSObject>

- (void)NextUpBtnCallBackAction:(NSInteger)temp;
@end

@interface PBPlayViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *playContentDic;
@property (nonatomic, strong) NSArray *playContentArray;
@property (nonatomic, assign) BOOL isStop;
@property (nonatomic, assign) id<PBPlayViewControllerDelegate> pDelegate;

@property (nonatomic, assign) NSInteger isShouldStop;
@property (nonatomic, assign) BOOL isMyData;
@property (nonatomic, assign) NSInteger pPlayIndex;
//@property (nonatomic, copy) NextUpBtnCallBackAction playCallBackAction;
@end


