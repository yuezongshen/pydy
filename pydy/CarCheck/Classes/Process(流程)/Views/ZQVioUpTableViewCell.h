//
//  ZQVioUpTableViewCell.h
//  CarCheck
//
//  Created by zhangqiang on 2017/10/31.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQVioUpTableViewCellDelegate<NSObject>

// 选车牌
-(void)showChooseView;

@end

typedef enum : NSUInteger {
    ZQVioUpCellType1,
    ZQVioUpCellType2,
    ZQVioUpCellType3,
    ZQVioUpCellType4,
    ZQVioUpCellType5,
    ZQVioUpCellType6
} ZqCellType;

@interface ZQVioUpTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField*contentTf;
// 是否是车牌号输入栏
@property(nonatomic,assign)BOOL isCarCode;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *palceText;
@property(nonatomic,assign)id<ZQVioUpTableViewCellDelegate> delegate;
/* 设置cell样式
 * param type:cell类型
 * param placeText:占位符内容
 * param title:每行标题
 */
-(void)setCellType:(ZqCellType )type title:(NSString *)title placeText:(NSString *)placeText provinceCode:(NSString *)carProvince;
- (void)changeTitleColor:(UIColor *)tColor;
@end

