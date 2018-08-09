//
//  PBPayListCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/20.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBPayListCell.h"

@interface PBPayListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *payTypeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation PBPayListCell

+ (CGFloat)PayListCellHeight
{
    return 100;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.payTypeLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.payBtn];
    }
    
    return self;
}
- (void)setPayListContent:(NSDictionary *)cDic
{
    NSString *str = cDic[@"name"];
    [self.titleLabel setText:str];
    self.moneyLabel.text = @"￥50.00";
    self.payTypeLabel.text = @"党费";
    [self.timeLabel setText:@"2018-03-02 17:00 截止"];
    
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 15)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}
- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+10, 100, 15)];
        _moneyLabel.font = [UIFont systemFontOfSize:14];
        _moneyLabel.textColor = HEXCOLOR(0xf62623);
    }
    return _moneyLabel;
}
- (UILabel *)payTypeLabel
{
    if (!_payTypeLabel) {
        _payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame),CGRectGetMaxY(_moneyLabel.frame)+10, 50, 15)];
        _payTypeLabel.font = [UIFont systemFontOfSize:14];
        _payTypeLabel.textColor = [UIColor lightGrayColor];
    }
    return _payTypeLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-10-200, CGRectGetMinY(_payTypeLabel.frame), 200, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}
- (UIButton *)payBtn
{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:@"交费" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_payBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_payBtn setFrame:CGRectMake(KWidth-10-60, (100-28)/2, 60, 28)];
        _payBtn.layer.cornerRadius = 2;
        _payBtn.layer.borderWidth = 0.5;
        _payBtn.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _payBtn;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
