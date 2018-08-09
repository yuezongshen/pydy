//
//  ZQMaintainCell.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/3.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQMaintainCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *infoDict;

+ (CGFloat)MaintainCellHeight;
@end
