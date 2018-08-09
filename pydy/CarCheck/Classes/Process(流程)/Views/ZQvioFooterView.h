//
//  ZqvioFooterView.h
//  CarCheck
//
//  Created by zhangqiang on 2017/10/31.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQvioFooterViewDelegate<NSObject>

// 是否同意协议
-(void)agreeAction:(BOOL )isAgree;
// 服务须知
-(void)knowProtocolAction:(id )sender;
// 选择图片
-(void)chooseImageAction:(id )sender;

@end

@interface ZQvioFooterView : UITableViewHeaderFooterView

@property(nonatomic,weak)id<ZQvioFooterViewDelegate> delegate;
@property(strong,nonatomic)UIImage *image;

@end
