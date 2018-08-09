//
//  ZQInspectionCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

const CGFloat cSpace =  6;

#import "ZQInspectionCell.h"
#import "UIImageView+WebCache.h"

@interface ZQInspectionCell ()
{
    CGFloat spaceX;
    CGFloat spaceY;
}
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation ZQInspectionCell

+ (CGFloat)inspectionCellHeight
{
    return 65+5;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = MainBgColor;
        spaceX = 10;
        spaceY = 8;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(spaceX*2, 5, __kWidth-spaceX*4, 60)];
        bgView.layer.cornerRadius = 4;
        bgView.layer.masksToBounds = YES;
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];

        UIView *_logoIV = [[UIView alloc] initWithFrame:CGRectMake(spaceX, 12, 4, 11)];
        _logoIV.backgroundColor = __MoneyColor;
        [bgView addSubview:_logoIV];
        
        [bgView addSubview:self.titleLabel];
        [bgView addSubview:self.moneyLabel];
        [bgView addSubview:self.timeLabel];
        [self.timeLabel setFrame:CGRectMake(CGRectGetMaxX(_timeLabel.frame),CGRectGetMinY(_titleLabel.frame),CGRectGetWidth(bgView.frame)-CGRectGetMaxX(_timeLabel.frame)-spaceX,20)];
        [bgView addSubview:self.statusLabel];
       
    }
    
    return self;
}

- (void)setInspectionModel:(ZQInspectionModel *)inspectionModel
{
//    if ([_inspectionModel isEqual:inspectionModel]) {
//        return;
//    }
//    _inspectionModel = inspectionModel;
    [self.titleLabel setText:@"提现申请"];
    [self.moneyLabel setText:inspectionModel.expected_account];
    [self.timeLabel setText:inspectionModel.updatetime];
    if (inspectionModel.isok.integerValue==1) {
     [self.statusLabel setText:@"提现成功"];
    }
    else
    {
        [self.statusLabel setText:@"审核中"];
    }
    /*
    NSString *linkmanStr = _inspectionModel.contact_name;
    rect = self.linkmanDesLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.addressLabel.frame);
    self.linkmanDesLabel.frame = rect;
    
    rect = self.linkmanLabel.frame;
    rect.origin.y = CGRectGetMaxY(self.addressLabel.frame);
    self.linkmanLabel.frame = rect;
    [self.linkmanLabel setText:linkmanStr];
    
    rect = self.phoneDesL.frame;
    rect.origin.y = CGRectGetMaxY(self.linkmanLabel.frame);
    self.phoneDesL.frame = rect;
    
    NSString *phoneStr = _inspectionModel.o_phone;
    //    rect = self.phoneLabel.frame;
    rect = self.phoneBtn.frame;
    rect.origin.y = CGRectGetMinY(self.phoneDesL.frame);
    self.phoneBtn.frame = rect;
    [self.phoneBtn setTitle:phoneStr forState:UIControlStateNormal];
     */
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(spaceX*2,spaceY, 100,20)];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel  = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x777777);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame),CGRectGetMaxY(_titleLabel.frame)+spaceX/2, 120,20)];
        _moneyLabel.textColor = __MoneyColor;
        _moneyLabel.font = [UIFont systemFontOfSize:16];
    }
    return _moneyLabel;
}
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_timeLabel.frame), CGRectGetMinY(_moneyLabel.frame), CGRectGetWidth(_timeLabel.frame), CGRectGetHeight(_moneyLabel.frame))];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = __TestOColor;
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
 - (void)setInfoDict:(NSDictionary *)infoDict
 {
 if ([_infoDict isEqual:infoDict]) {
 return;
 }
 _infoDict = infoDict;
 [self.imgV setImage:[UIImage imageNamed:infoDict[@"image"]]];
 [self.titleLabel setText:infoDict[@"name"]];
 [self.distanceLabel setText:infoDict[@"distance"]];
 
 //    NSString *addressStr = [NSString stringWithFormat:@"地址: %@",infoDict[@"address"]];
 //    NSRange range = [addressStr rangeOfString:@"地址:"];
 //    NSMutableAttributedString *attachStr = [[NSMutableAttributedString alloc] initWithString:addressStr];
 //    [attachStr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(17,149,232) range:range];
 //    [self.addressLabel setAttributedText:attachStr];
 NSString *addressStr = infoDict[@"address"];
 CGRect rect = self.addressLabel.frame;
 //   CGSize size = [addressStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
 //    if (size.width>CGRectGetWidth(self.addressLabel.frame)) {
 //        rect.size.height = 34;
 //    }
 //    else
 //    {
 //        rect.size.height = labelHeight;
 //    }
 self.addressLabel.frame = rect;
 [self.addressLabel setText:addressStr];
 
 NSString *linkmanStr = infoDict[@"linkman"];
 rect = self.linkmanDesLabel.frame;
 rect.origin.y = CGRectGetMaxY(self.addressLabel.frame);
 self.linkmanDesLabel.frame = rect;
 
 rect = self.linkmanLabel.frame;
 rect.origin.y = CGRectGetMaxY(self.addressLabel.frame);
 self.linkmanLabel.frame = rect;
 [self.linkmanLabel setText:linkmanStr];
 
 rect = self.phoneDesL.frame;
 rect.origin.y = CGRectGetMaxY(self.linkmanLabel.frame);
 self.phoneDesL.frame = rect;
 
 NSString *phoneStr = infoDict[@"phone"];
 //    rect = self.phoneLabel.frame;
 rect = self.phoneBtn.frame;
 rect.origin.y = CGRectGetMinY(self.phoneDesL.frame);
 //    size = [phoneStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
 //    rect.size.height = size.height;
 //    if (size.height>34) {
 //        rect.size.height = 34;
 //    }
 
 //    if (size.width>CGRectGetWidth(self.phoneLabel.frame)) {
 //        rect.size.height = 34;
 //    }
 //    else
 //    {
 //        rect.size.height = 15;
 //    }
 //    self.phoneLabel.frame = rect;
 //    [self.phoneLabel setText:phoneStr];
 self.phoneBtn.frame = rect;
 [self.phoneBtn setTitle:phoneStr forState:UIControlStateNormal];
 
 //    NSString *phoneStr = [NSString stringWithFormat:@"电话: %@",infoDict[@"phone"]];
 //    range = [phoneStr rangeOfString:@"电话:"];
 //    attachStr = [[NSMutableAttributedString alloc] initWithString:phoneStr];
 //    [attachStr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(17,149,232) range:range];
 //    [self.phoneLabel setAttributedText:attachStr];
 }
 */
@end
