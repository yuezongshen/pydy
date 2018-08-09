//
//  ZQSubstituteOrderCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/1.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQSubstituteOrderCell.h"

@interface ZQSubstituteOrderCell ()
{
    CGFloat oSpace;
    CGFloat labelHeight;
    CGFloat font_size;
}
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) UILabel *titleL;

@property (nonatomic, strong) UILabel *phoneL;

@property (nonatomic, strong) UILabel *carCodeL;

@property (nonatomic, strong) UILabel *addressL;

@property (nonatomic, strong) UILabel *statusL;

@property (nonatomic, strong) UILabel *feeL;

@property (nonatomic, strong) UILabel *timeL;

@property (nonatomic, strong) UILabel *priceL;

@end

@implementation ZQSubstituteOrderCell

+ (CGFloat)SubstituteOrderCellHeight
{
    //    return __kWidth*150/750+20;
    return 18*8+34;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        oSpace = 8;
        labelHeight = 18;
        font_size = 13;
//        [self.contentView addSubview:self.imgV];
//        [self.contentView addSubview:self.titleL];
//        [self.contentView addSubview:self.phoneL];
//        [self.contentView addSubview:self.carCodeL];
//        [self.contentView addSubview:self.addressL];
//        [self.contentView addSubview:self.statusL];
//        [self.contentView addSubview:self.feeL];
//        [self.contentView addSubview:self.timeL];
//        [self.contentView addSubview:self.priceL];
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.imgV];
        [self.bgView addSubview:self.titleL];
        [self.bgView addSubview:self.phoneL];
        [self.bgView addSubview:self.carCodeL];
        [self.bgView addSubview:self.addressL];
        [self.bgView addSubview:self.statusL];
        [self.bgView addSubview:self.feeL];
        [self.bgView addSubview:self.timeL];
        [self.bgView addSubview:self.priceL];
        [self.bgView addSubview:self.substitutePayBtn];
    }
    
    return self;
}

- (void)setOrderModel:(ZQSubstituteOrderModel *)orderModel
{
    if ([_orderModel isEqual:orderModel]) {
        return;
    }
    _orderModel = orderModel;
    //    [self.imgV setImage:[UIImage imageNamed:@"agency"]];
    [self.titleL setText:[NSString stringWithFormat:@"罚单编号: %@",_orderModel.ticket_number]];
    [self.phoneL setText:[NSString stringWithFormat:@"车牌号码: %@",_orderModel.car_card]];
    NSString *moneyStr = [NSString stringWithFormat:@"处罚金额: ￥%@",_orderModel.fine_money];
    NSRange range = [moneyStr rangeOfString:[NSString stringWithFormat:@"￥%@",_orderModel.fine_money]];
    NSMutableAttributedString *attachStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attachStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [self.carCodeL setAttributedText:attachStr];
    [self.addressL setText:[NSString stringWithFormat:@"处罚日期: %@",_orderModel.fine_date]];
//    [self.statusL setText:[NSString stringWithFormat:@"手机号码: %@",_orderModel.phone_num]];
    [self.statusL setText:[NSString stringWithFormat:@"手机号码: %@",_orderModel.phone]];
    if (!_orderModel.late_fee) {
        _orderModel.late_fee = @"0";
    }
    moneyStr = [NSString stringWithFormat:@"滞纳金: ￥%@",_orderModel.late_fee];
    range = [moneyStr rangeOfString:[NSString stringWithFormat:@"￥%@",_orderModel.late_fee]];
    attachStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attachStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [self.feeL setAttributedText:attachStr];

    //    NSTimeInterval time=[_orderModel.create_time doubleValue]+28800;
    NSTimeInterval time=[_orderModel.create_time doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    [self.timeL setText:[NSString stringWithFormat:@"下单时间: %@",currentDateStr]];
    
    if (!_orderModel.pay_money) {
        _orderModel.pay_money = @"0";
    }
    moneyStr = [NSString stringWithFormat:@"总价: ￥%@",_orderModel.pay_money];
    range = [moneyStr rangeOfString:[NSString stringWithFormat:@"￥%@",_orderModel.pay_money]];
    attachStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attachStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [self.priceL setAttributedText:attachStr];
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 3, __kWidth-2*8, [ZQSubstituteOrderCell SubstituteOrderCellHeight]-6)];
        _bgView.backgroundColor = MainBgColor;
    }
    return _bgView;
}

- (UIImageView *)imgV
{
    if (!_imgV) {
        //        CGFloat imageW =  __kWidth*150/750;
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,0,0)];
        //        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10,imageW, [ZQInspectionCell inspectionCellHeight]-20)];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}

- (UILabel *)titleL
{
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+oSpace, 10, __kWidth-CGRectGetMaxX(_imgV.frame)-oSpace*2-40, 20)];
        //         _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cSpace, 10, __kWidth-CGRectGetMaxX(_imgV.frame)-cSpace*2, 20)];
        _titleL.font = [UIFont boldSystemFontOfSize:16];
        _titleL.textColor = [UIColor blackColor];
    }
    return _titleL;
}
- (UILabel *)phoneL
{
    if (!_phoneL) {
        _phoneL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+oSpace, CGRectGetMaxY(_titleL.frame)+2, CGRectGetWidth(_titleL.frame), labelHeight)];
        _phoneL.font = [UIFont systemFontOfSize:font_size];
        _phoneL.textColor = [UIColor darkGrayColor];
    }
    return _phoneL;
}
- (UILabel *)carCodeL
{
    if (!_carCodeL) {
        _carCodeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+oSpace, CGRectGetMaxY(_phoneL.frame)+2, CGRectGetWidth(_phoneL.frame), labelHeight)];
        _carCodeL.font = [UIFont systemFontOfSize:font_size];
        _carCodeL.textColor = [UIColor darkGrayColor];
    }
    return _carCodeL;
}
- (UILabel *)addressL
{
    if (!_addressL) {
        _addressL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+oSpace, CGRectGetMaxY(_carCodeL.frame)+2, CGRectGetWidth(_carCodeL.frame), labelHeight)];
        _addressL.font = [UIFont systemFontOfSize:font_size];
        _addressL.textColor = [UIColor darkGrayColor];
    }
    return _addressL;
}
- (UILabel *)statusL
{
    if (!_statusL) {
        _statusL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+oSpace, CGRectGetMaxY(_addressL.frame), CGRectGetWidth(_titleL.frame), labelHeight)];
        _statusL.font = [UIFont systemFontOfSize:font_size];
        _statusL.textColor = [UIColor darkGrayColor];
    }
    return _statusL;
}
- (UILabel *)feeL
{
    if (!_feeL) {
        _feeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+oSpace, CGRectGetMaxY(_statusL.frame)+2, CGRectGetWidth(_statusL.frame), labelHeight)];
        _feeL.font = [UIFont systemFontOfSize:font_size];
        _feeL.textColor = [UIColor darkGrayColor];
    }
    return _feeL;
}

- (UILabel *)timeL
{
    if (!_timeL) {
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+oSpace, CGRectGetMaxY(_feeL.frame)+2, CGRectGetWidth(_feeL.frame), labelHeight)];
        _timeL.font = [UIFont systemFontOfSize:font_size];
        _timeL.textColor = [UIColor darkGrayColor];
    }
    return _timeL;
}

- (UILabel *)priceL
{
    if (!_priceL) {
        _priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+oSpace, CGRectGetMaxY(_timeL.frame), CGRectGetWidth(_titleL.frame), labelHeight)];
        _priceL.font = [UIFont systemFontOfSize:font_size];
        //        _priceL.textColor = LH_RGBCOLOR(17,149,232);
        _priceL.textColor = [UIColor darkGrayColor];
    }
    return _priceL;
}
- (UIButton *)substitutePayBtn
{
    if (!_substitutePayBtn) {
        _substitutePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_substitutePayBtn setFrame:CGRectMake(CGRectGetWidth(_bgView.frame)-90,CGRectGetHeight(_bgView.frame)-40,80, 30)];
        _substitutePayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_substitutePayBtn setTitle:@"继续支付" forState:UIControlStateNormal];
        [_substitutePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_substitutePayBtn setBackgroundColor:[UIColor redColor]];
        _substitutePayBtn.layer.cornerRadius = 6;
    }
    return _substitutePayBtn;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
