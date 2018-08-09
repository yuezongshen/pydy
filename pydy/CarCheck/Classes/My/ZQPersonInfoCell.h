//
//  ZQPersonInfoCell.h
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/6.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQPersonInfoCell : UITableViewCell

@property (strong,nonatomic) UITextField *detailTF;
-(void)setTitle:(NSString *)title;
- (void)setTitle:(NSString *)title placeholderText:(NSString *)pText;
- (void)setTitle:(NSString *)title attributedString:(NSString *)attriStr placeholderText:(NSString *)pText;
@end
