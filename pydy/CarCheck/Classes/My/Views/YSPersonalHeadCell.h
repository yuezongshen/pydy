//
//  YSPersonalHeadCell.h
//  shopsN
//
//  Created by imac on 2016/12/17.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSPersonalHeadCellDelegate <NSObject>

/**查看消息*/
-(void)seeNews;
/**设置*/
-(void)goSetting;
/**账户管理*/
-(void)userManage;
///**邀请有礼*/
//-(void)chooseInviteGood;

@end

@interface YSPersonalHeadCell : UICollectionViewCell

/**用户头像*/
@property (strong,nonatomic) UIImageView *headIV;

@property (strong,nonatomic) NSString *userName;

@property (strong,nonatomic) NSString *imageName;

@property (weak,nonatomic) id<YSPersonalHeadCellDelegate>delegate;

@end
