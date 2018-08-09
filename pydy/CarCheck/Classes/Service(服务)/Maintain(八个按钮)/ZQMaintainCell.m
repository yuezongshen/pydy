//
//  ZQMaintainCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/3.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//
const CGFloat cCSpace =  8;

#import "ZQMaintainCell.h"
#import "VerticallyAlignedLabel.h"
#import "UIImageView+WebCache.h"

@interface ZQMaintainCell ()
{
    CGFloat labelWidth;
}
@property (nonatomic, strong) UIImageView *imgV;

@property (nonatomic, strong) VerticallyAlignedLabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ZQMaintainCell

+ (CGFloat)MaintainCellHeight
{
    return kHeightScale(74)+20;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        labelWidth = 36;
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
    }
    
    return self;
}

- (void)setInfoDict:(NSDictionary *)infoDict
{
//    [self.imgV setImage:[UIImage imageNamed:infoDict[@"image"]]];
    if (![infoDict isKindOfClass:[NSDictionary class]]) {
        [self.imgV setImage:nil];
        [self.timeLabel setText:@""];
        [self.titleLabel setText:@""];
        return;
    }
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseAPI,infoDict[@"InfoPicture"]]] placeholderImage:[UIImage imageNamed:@"agency"]];

    NSString *str = infoDict[@"InfoTitle"];
//      CGSize size = [str boundingRectWithSize:CGSizeMake(__kWidth-CGRectGetMaxX(_imgV.frame)-cCSpace*2, CGRectGetHeight(_imgV.frame)-15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLabel.font} context:nil].size;
//    CGRect rect = _titleLabel.frame;
//    rect.size = size;
//    [self.titleLabel setFrame:rect];
    [self.titleLabel setText:str];
    [self.timeLabel setText:infoDict[@"InfoTime"]];
}
- (UIImageView *)imgV
{
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kWidthScale(110), [ZQMaintainCell MaintainCellHeight]-20)];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.masksToBounds = YES;
    }
    return _imgV;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[VerticallyAlignedLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+cCSpace, 10-1, __kWidth-CGRectGetMaxX(_imgV.frame)-cCSpace*2, CGRectGetHeight(_imgV.frame)-15)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = HEXCOLOR(0x333333);
//        _titleLabel.numberOfLines = (CGRectGetHeight(_imgV.frame)-15)/(16+3);
        _titleLabel.numberOfLines = 2;
        _titleLabel.verticalAlignment = VerticalAlignmentTop;
    }
    return _titleLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_imgV.frame)-15, CGRectGetWidth(_titleLabel.frame), 15)];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textColor = HEXCOLOR(0x666666);
    }
    return _timeLabel;
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
