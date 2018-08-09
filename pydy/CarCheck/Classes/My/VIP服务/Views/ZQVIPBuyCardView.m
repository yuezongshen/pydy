//
//  ZQVIPBuyCardView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/19.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQVIPBuyCardView.h"

@interface ZQVIPBuyCardView ()

@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *spareL;
@property (nonatomic, strong) UILabel *buyCountL;

@end

@implementation ZQVIPBuyCardView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = LH_RGBCOLOR(241,239,235);
        [self initViews];
    }
    return self;
}

-(void)initViews {
    UIImageView *imageLead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, 140)];
    imageLead.image = [UIImage imageNamed:@"WechatIMG47"];
    [self addSubview:imageLead];
    
    UIImageView *imageRight = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, CGRectGetWidth(imageLead.frame)-30, 160)];
//    imageRight.image = [UIImage imageNamed:@"shouyejiantou"];
    imageRight.layer.cornerRadius = 6;
    imageRight.layer.masksToBounds = YES;
    [imageRight setBackgroundColor:LH_RGBCOLOR(220,195,129)];
    [self addSubview:imageRight];
    
    UIView *bView = [[UIView alloc] initWithFrame:CGRectMake(0, 130, CGRectGetWidth(imageRight.frame), 30)];
    [bView setBackgroundColor:LH_RGBCOLOR(187,156,92)];
    [imageRight addSubview:bView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    titleLabel.text = @"会员年卡";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = LH_RGBCOLOR(187,156,92);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.layer.borderWidth = 1.0;
    titleLabel.layer.cornerRadius = 4;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.borderColor = LH_RGBCOLOR(187,156,92).CGColor;
    [imageRight addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(imageRight.frame)-50, 10, 40, 20)];
    titleLabel.text = @"VIP";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.textColor = LH_RGBCOLOR(187,156,92);
    [imageRight addSubview:titleLabel];
    
    UIImageView *cardLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
    cardLogo.image = [UIImage imageNamed:@"icon29"];
    cardLogo.center = CGPointMake(CGRectGetWidth(imageRight.frame)/2, 35);
    [cardLogo setBackgroundColor:LH_RGBCOLOR(220,195,129)];
    [imageRight addSubview:cardLogo];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 26)];
    titleLabel.center = CGPointMake(cardLogo.center.x, cardLogo.center.y+30);
    titleLabel.text = @"会员卡";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [imageRight addSubview:titleLabel];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.center = CGPointMake(cardLogo.center.x, cardLogo.center.y+65);
    titleLabel.text = @"预计可省299元/年\n更好、更省、更优";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor whiteColor];
    [imageRight addSubview:titleLabel];
    self.spareL = titleLabel;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5, 180, 20)];
    titleLabel.text = @"已有10000人购买";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    [bView addSubview:titleLabel];
    self.buyCountL = titleLabel;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bView.frame)-126,5, 116, 20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    [bView addSubview:titleLabel];
    
//    NSString *tString = @"￥99  原价¥398";
//    NSRange range = [tString rangeOfString:@"￥99"];
//    NSRange yRange = [tString rangeOfString:@"原价¥398"];
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:tString];
//    [attr addAttribute:NSFontAttributeName value:MFont(16) range:range];
//    [attr addAttribute:NSFontAttributeName value:MFont(14) range:yRange];
//    [attr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:yRange];
//    titleLabel.attributedText = attr;
    self.priceL = titleLabel;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 210, __kWidth, 30)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:whiteView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 200, 20)];
    titleLabel.text = @"会员权益";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor darkTextColor];
    [whiteView addSubview:titleLabel];
    
    _introduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_introduceBtn setFrame:CGRectMake(CGRectGetWidth(whiteView.frame)-80-15, 5, 80, 20)];
    [_introduceBtn setTitleColor:__TextColor forState:UIControlStateNormal];
    [_introduceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_introduceBtn setTitle:@"详细介绍 >" forState:UIControlStateNormal];
    [whiteView addSubview:_introduceBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 29, __kWidth-30, 0.5)];
    lineView.backgroundColor = HEXCOLOR(0xcccccc);
    [whiteView addSubview:lineView];
}
- (void)configBuyCardViewWithModel:(ZQVIPModel *)model
{
    NSString *tString = [NSString stringWithFormat:@"￥%@  原价¥%@",model.current_price,model.original_price];
    NSRange range = [tString rangeOfString:[NSString stringWithFormat:@"￥%@",model.current_price]];
    NSRange yRange = [tString rangeOfString:[NSString stringWithFormat:@"¥%@",model.original_price]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:tString];
    [attr addAttribute:NSFontAttributeName value:MFont(16) range:range];
    [attr addAttribute:NSFontAttributeName value:MFont(14) range:yRange];
    [attr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:yRange];
    self.priceL.attributedText = attr;
    if (!model.save.integerValue) {
        model.save = @"0";
    }
    self.spareL.text = [NSString stringWithFormat:@"预计可省%@元/年\n更好、更省、更优",model.save];
    if (!model.purchase.integerValue) {
        model.purchase = @"0";
    }
    self.buyCountL.text = [NSString stringWithFormat:@"已有%@人购买",model.purchase];
    
}
@end
