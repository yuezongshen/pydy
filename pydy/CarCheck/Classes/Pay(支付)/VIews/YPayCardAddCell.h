//
//  YPayCardAddCell.h
//  shopsN
//
//  Created by imac on 2016/12/23.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

//#import "BaseTableViewCell.h"

@protocol YPayCardAddCellDelegate <NSObject>

- (void)AddCard;

@end

@interface YPayCardAddCell : UITableViewCell

@property (weak,nonatomic) id<YPayCardAddCellDelegate>delegate;

@end
