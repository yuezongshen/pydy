//
//  ZQDeclarationCell.h
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/4.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeclarationTextBack)(NSString *);

@interface ZQDeclarationCell : UITableViewCell

@property (nonatomic, copy) DeclarationTextBack dTextBack;

- (void)configTitle:(NSString *)title;
- (void)configTextFeild:(NSString *)tfText;

- (void)configTextFeildText:(NSString *)tfText;
@end
