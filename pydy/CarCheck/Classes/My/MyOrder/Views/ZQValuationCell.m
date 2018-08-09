//
//  ZQValuationCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/18.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQValuationCell.h"

#import "ZQValuationModel.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface ZQValuationCell()
{
    CGFloat spaceX;
    CGFloat spaceY;
    CGFloat imageSpace;
    
    CGFloat desHeight;
}
@property (strong,nonatomic) UIView *backV;

@property (strong,nonatomic) UILabel *orderNumL;
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UILabel *desLabel;

@property (strong,nonatomic) UIView *imageBgView;
@property (strong,nonatomic) UIImageView *imageV1;
@property (strong,nonatomic) UIImageView *imageV2;
@property (strong,nonatomic) UIImageView *imageV3;
@property (strong,nonatomic) UIImageView *imageV4;

@property (strong,nonatomic) ZQValuationModel *valuationM;
@end


@implementation ZQValuationCell

+ (CGFloat)getValuationCellHeight
{
    return 160+8*2+8+8+4;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        spaceY = 8;
        spaceX = 12;
        imageSpace = 10;
        desHeight = 60;
        self.backgroundColor = MainBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}
-(void)initView{
    [self.contentView addSubview:self.backV];
    [self.backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-spaceY);
    }];
    UIView *_logoIV = [[UIView alloc] initWithFrame:CGRectMake(spaceX, spaceY+4, 2, 12)];
    _logoIV.backgroundColor = __MoneyColor;
    [_backV addSubview:_logoIV];
    [_backV addSubview:self.orderNumL];
    [self.orderNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backV).offset(spaceX*2);
        make.top.equalTo(_backV).offset(spaceY);
        make.height.equalTo(@(20));
    }];
    
//    CGRectMake(0, CGRectYH(_orderNumL)+spaceY, CGRectGetWidth(_backV.frame), 0.5)
    UIView *lineIV = [[UIView alloc]init];
    [_backV addSubview:lineIV];
    lineIV.backgroundColor = [UIColor lightGrayColor];
    
    [lineIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backV);
        make.top.equalTo(_orderNumL.mas_bottom).offset(spaceY);
        make.height.equalTo(@(0.5));
    }];
    [_backV addSubview:self.timeLabel];
//    CGRectMake(spaceX, CGRectGetMaxY(_orderNumL.frame)+5+spaceY, CGRectGetWidth(_orderNumL.frame), 20)
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_backV).offset(spaceX);
        make.top.equalTo(_orderNumL.mas_bottom).offset(spaceY+5);
        make.height.equalTo(@(20));
    }];
    [_backV addSubview:self.desLabel];

    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backV).offset(spaceX);
        make.right.equalTo(_backV).offset(-spaceX);
        make.top.equalTo(_timeLabel.mas_bottom);
        make.bottom.equalTo(_backV).offset(-desHeight-spaceY);
//        make.height.equalTo(@(desHeight));
    }];
    [_backV addSubview:self.openUpBtn];
    [self.openUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_backV).offset(-34);
        make.top.equalTo(_desLabel.mas_bottom);
        make.height.equalTo(@(20));
        make.width.equalTo(@(34));
    }];
}
- (void)configValuationCell:(ZQValuationModel *)vModel
{
    self.valuationM = vModel;
    [self.orderNumL setText:[NSString stringWithFormat:@"订单编号:%@",vModel.order_sn]];
    [self.timeLabel setText:[NSString stringWithFormat:@"%@   %@",vModel.updatetime,vModel.scenicname]];
    [self.desLabel setText:vModel.content];
    if (vModel.desTextSize) {
        [self.openUpBtn setHidden:((vModel.desTextSize-20) < desHeight)];
    }
    else
    {
        CGSize size = [vModel.content boundingRectWithSize:CGSizeMake(__kWidth-2*spaceX, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.desLabel.font} context:nil].size;
        [self.openUpBtn setHidden:(size.height < desHeight)];
        vModel.desTextSize = size.height+20;
    }
    if (self.openUpBtn.hidden) {
        [self.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_backV).offset(-desHeight-spaceY);
        }];
    }
    else
    {
        [self.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_backV).offset(-desHeight-spaceY-20);
        }];
    }
    if (vModel.isOpenUp) {
        [self.openUpBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    else
    {
        [self.openUpBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
    if (_imageBgView) {
        [_imageBgView removeFromSuperview];
    }
    if (vModel.images) {
        if (vModel.images.count==1) {
            NSString *urls = vModel.images[0];
            if ([urls rangeOfString:@"|"].location != NSNotFound) {
                vModel.images = [urls componentsSeparatedByString:@"|"];
            }
        }
        if (vModel.images.count) {
            [_backV addSubview:self.imageBgView];
            [self.imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_backV);
                make.bottom.equalTo(_backV).offset(-spaceY);
                make.height.equalTo(@(desHeight));
            }];
            switch (vModel.images.count) {
                case 0:
                {
                    
                }
                    break;
                case 1:
                {
                    [_imageBgView addSubview:self.imageV1];
                    [self.imageV1 sd_setImageWithURL:[NSURL URLWithString:vModel.images[0]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                }
                    break;
                case 2:
                {
                    [_imageBgView addSubview:self.imageV1];
                    [_imageBgView addSubview:self.imageV2];
                    [self.imageV1 sd_setImageWithURL:[NSURL URLWithString:vModel.images[0]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                    [self.imageV2 sd_setImageWithURL:[NSURL URLWithString:vModel.images[1]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                }
                    break;
                case 3:
                {
                    [_imageBgView addSubview:self.imageV1];
                    [_imageBgView addSubview:self.imageV2];
                    [_imageBgView addSubview:self.imageV3];
                    [self.imageV1 sd_setImageWithURL:[NSURL URLWithString:vModel.images[0]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                    [self.imageV2 sd_setImageWithURL:[NSURL URLWithString:vModel.images[1]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                    [self.imageV3 sd_setImageWithURL:[NSURL URLWithString:vModel.images[2]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];

                }
                    break;
                default:
                {
                    [_imageBgView addSubview:self.imageV1];
                    [_imageBgView addSubview:self.imageV2];
                    [_imageBgView addSubview:self.imageV3];
                    [_imageBgView addSubview:self.imageV4];
                    [self.imageV1 sd_setImageWithURL:[NSURL URLWithString:vModel.images[0]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                    [self.imageV2 sd_setImageWithURL:[NSURL URLWithString:vModel.images[1]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                    [self.imageV3 sd_setImageWithURL:[NSURL URLWithString:vModel.images[2]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                    [self.imageV4 sd_setImageWithURL:[NSURL URLWithString:vModel.images[3]] placeholderImage:[UIImage imageNamed:@"showImage.jpg"]];
                }
                    break;
            }
        }
    }
}

- (void)changeCellFrame:(CGFloat)height
{
//    [self.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(height));
//    }];
//    CGRect rect = self.desLabel.frame;
//    rect.size.height = height;
//    self.desLabel.frame = rect;
//
//    rect = self.openUpBtn.frame;
//    rect.origin.y = CGRectGetMaxY(self.desLabel.frame);
//    [self.openUpBtn setFrame:rect];
//
//    rect = self.imageBgView.frame;
//    rect.origin.y = CGRectGetMaxY(self.openUpBtn.frame);
//    [self.imageBgView setFrame:rect];
//
//    rect = self.backV.frame;
//    rect.size.height = 100+spaceY*3+4+height;
//    self.backV.frame = rect;
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGFloat tHeight = desHeight;
//    if (self.valuationM.desTextSize) {
//        tHeight = self.valuationM.desTextSize;
//    }
//    [self.backV setFrame:CGRectMake(0, 0, __kWidth, 100+spaceY*3+4+tHeight)];
//    [self.orderNumL setFrame:CGRectMake(spaceX*2, spaceY, CGRectGetWidth(_backV.frame)-spaceX*2, 20)];
//    [self.timeLabel setFrame:CGRectMake(spaceX, CGRectGetMaxY(_orderNumL.frame)+5+spaceY, CGRectGetWidth(_orderNumL.frame), 20)];
//    [self.desLabel setFrame:CGRectMake(spaceX, CGRectGetMaxY(_timeLabel.frame), CGRectGetWidth(_orderNumL.frame), tHeight)];
//    [self.openUpBtn setFrame:CGRectMake(CGRectGetWidth(_backV.frame)-spaceX-34, CGRectGetMaxY(_desLabel.frame), 34, 20)];
//    if (self.openUpBtn.hidden) {
//        _imageBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_desLabel.frame), CGRectGetWidth(self.backV.frame), desHeight)];
//    }
//    else
//    {
//        _imageBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_openUpBtn.frame), CGRectGetWidth(self.backV.frame), desHeight)];
//    }
//
//}
#pragma mark ==懒加载==
-(UIView *)backV{
    if (!_backV) {
//        _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 160+spaceY*3+4)];
        _backV = [[UIView alloc] init];
        _backV.backgroundColor = [UIColor whiteColor];
    }
    return _backV;
}
-(UIView *)imageBgView{
    if (!_imageBgView) {
        _imageBgView = [[UIView alloc]init];
//        if (self.openUpBtn.hidden) {
//             _imageBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_desLabel.frame), CGRectGetWidth(self.backV.frame), desHeight)];
//        }
//        else
//        {
//            _imageBgView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_openUpBtn.frame), CGRectGetWidth(self.backV.frame), desHeight)];
//        }
        _imageBgView.backgroundColor = [UIColor whiteColor];
    }
    return _imageBgView;
}
-(UIImageView *)imageV1{
    if (!_imageV1) {
        CGFloat imageW = (__kWidth - spaceX*2-3*imageSpace)/4;
        _imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(spaceX, 0, imageW, 60)];
        _imageV1.contentMode = UIViewContentModeScaleAspectFill;
        _imageV1.clipsToBounds = YES;
    }
    return _imageV1;
}
-(UIImageView *)imageV2{
    if (!_imageV2) {
        _imageV2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageV1.frame)+imageSpace, CGRectGetMinY(_imageV1.frame), CGRectGetWidth(_imageV1.frame), CGRectGetHeight(_imageV1.frame))];
        _imageV2.contentMode = UIViewContentModeScaleAspectFill;
        _imageV2.clipsToBounds = YES;

    }
    return _imageV2;
}
-(UIImageView *)imageV3{
    if (!_imageV3) {
        _imageV3 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageV2.frame)+imageSpace, CGRectGetMinY(_imageV1.frame), CGRectGetWidth(_imageV1.frame), CGRectGetHeight(_imageV1.frame))];
        _imageV3.contentMode = UIViewContentModeScaleAspectFill;
        _imageV3.clipsToBounds = YES;
    }
    return _imageV3;
}
-(UIImageView *)imageV4{
    if (!_imageV4) {
        _imageV4 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageV3.frame)+imageSpace, CGRectGetMinY(_imageV1.frame), CGRectGetWidth(_imageV1.frame), CGRectGetHeight(_imageV1.frame))];
        _imageV4.contentMode = UIViewContentModeScaleAspectFill;
        _imageV4.clipsToBounds = YES;
    }
    return _imageV4;
}
-(UILabel *)orderNumL{
    if (!_orderNumL) {
        _orderNumL = [[UILabel alloc] init];
//        _orderNumL = [[UILabel alloc]initWithFrame:CGRectMake(spaceX*2, spaceY, CGRectGetWidth(_backV.frame)-spaceX*2, 20)];
        _orderNumL.font = MFont(16);
        _orderNumL.textColor = __MoneyColor;
    }
    return _orderNumL;
}
-(UILabel *)timeLabel{
    if (!_timeLabel) {
//        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, CGRectGetMaxY(_orderNumL.frame)+5+spaceY, CGRectGetWidth(_orderNumL.frame), 20)];
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = MFont(12);
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}
-(UILabel *)desLabel{
    if (!_desLabel) {
//        _desLabel = [[UILabel alloc]initWithFrame:CGRectMake(spaceX, CGRectGetMaxY(_timeLabel.frame), CGRectGetWidth(_orderNumL.frame), desHeight)];
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = MFont(14);
        _desLabel.textColor = __TestOColor;
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}
- (UIButton *)openUpBtn
{
    if (!_openUpBtn) {
        _openUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openUpBtn setTitleColor:__MoneyColor forState:UIControlStateNormal];
        [_openUpBtn setTitleColor:__TestOColor forState:UIControlStateSelected];
        _openUpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
       
    }
    return _openUpBtn;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
