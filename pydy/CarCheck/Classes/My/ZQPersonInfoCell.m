//
//  ZQPersonInfoCell.m
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/6.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQPersonInfoCell.h"

@interface ZQPersonInfoCell ()

@property (strong,nonatomic) UILabel *titleLb;

@end

@implementation ZQPersonInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        [self initView];
    }
    return self;
}

-(void)initView{
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 100, 15)];
    [self addSubview:_titleLb];
    _titleLb.textAlignment = NSTextAlignmentLeft;
    _titleLb.font = MFont(15);
    _titleLb.textColor = __TestOColor;
    
    _detailTF = [[UITextField alloc]initWithFrame:CGRectMake(100, 15, __kWidth-135, 20)];
    [self addSubview:_detailTF];
    _detailTF.textAlignment = NSTextAlignmentRight;
    _detailTF.textColor = __TestGColor;
    _detailTF.font= MFont(15);
}

- (void)setTitle:(NSString *)title attributedString:(NSString *)attriStr placeholderText:(NSString *)pText
{
    NSString *totalStr = [NSString stringWithFormat:@"%@%@",title,attriStr];
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attri addAttribute:NSForegroundColorAttributeName value:__TestOColor range:[totalStr rangeOfString:title]];
    [attri addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xbc2c29) range:[totalStr rangeOfString:attriStr]];
    [_titleLb setAttributedText:attri];
    _detailTF.placeholder = pText;
}
- (void)setTitle:(NSString *)title placeholderText:(NSString *)pText
{
    _titleLb.text = title;
    _detailTF.placeholder = pText;
}
-(void)setTitle:(NSString *)title{
    _titleLb.text = title;
    _detailTF.placeholder = [NSString stringWithFormat:@"请填写%@",title];
}

@end
