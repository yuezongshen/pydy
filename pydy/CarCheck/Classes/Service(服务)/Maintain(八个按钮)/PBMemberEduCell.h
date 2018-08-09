//
//  PBMemberEduCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/19.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBMemberEduCell : UITableViewCell

@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *attachLabel;

+ (CGFloat)EduCellHeight;
- (void)setEduContent:(NSDictionary *)cDic type:(NSInteger)type;
@end
