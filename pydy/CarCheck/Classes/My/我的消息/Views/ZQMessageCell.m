//
//  ZQMessageCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMessageCell.h"

@interface ZQMessageCell ()

//@property (strong,nonatomic) UIImageView *logoIV;

@property (strong,nonatomic) UILabel *titleLb;

@property (strong,nonatomic) UILabel *detailLb;

@property (strong,nonatomic) UILabel *timeLb;

@end

@implementation ZQMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 6, __kWidth-40, 62)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    UIView *_logoIV = [[UIView alloc] initWithFrame:CGRectMake(10, 12, 4, 11)];
    _logoIV.backgroundColor = __MoneyColor;
    [bgView addSubview:_logoIV];
    
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_logoIV)+8, 10, CGRectGetWidth(bgView.frame)-CGRectGetMaxX(_logoIV.frame)-100, 15)];
    [bgView addSubview:_titleLb];
    _titleLb.textColor = __DTextColor;
    _titleLb.font = MFont(15);
    
    _timeLb = [[UILabel  alloc]initWithFrame:CGRectMake(CGRectGetWidth(bgView.frame)-140, CGRectGetMinY(_titleLb.frame), 130, 15)];
    [bgView addSubview:_timeLb];
    _timeLb.textAlignment = NSTextAlignmentRight;
    _timeLb.textColor = LH_RGBCOLOR(170, 170, 170);
    _timeLb.font = MFont(12);
    
    _detailLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleLb.frame), CGRectYH(_titleLb)+6, __kWidth-90, 26)];
    [bgView addSubview:_detailLb];
    _detailLb.textColor = LH_RGBCOLOR(153, 153, 153);
    _detailLb.font = MFont(13);
    _detailLb.numberOfLines = 0;
}

- (void)setModel:(ZQMessageModel *)model {
    _model = model;
    _titleLb.text = _model.newsname;
    _detailLb.text = _model.news;
    if (_model.updatetime) {
//        NSTimeInterval time=[_model.t_date doubleValue];
//        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//        _timeLb.text = currentDateStr;
        _timeLb.text = _model.updatetime;
    }
    else
    {
        _timeLb.text = @"2017-11-01";
    }
    //    NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[dateNow timeIntervalSince1970]];
    //    NSInteger sendTime = [timeSp integerValue]- [model.time integerValue];
    //    if (sendTime/60<1) {
    //        _timeLb.text = @"刚刚";
    //    }else if (sendTime/3600<1){
    //        _timeLb.text = [NSString stringWithFormat:@"%ld分钟前",sendTime/60];
    //    }else if (sendTime/216000<1){
    //        _timeLb.text = [NSString stringWithFormat:@"%ld小时前",sendTime/3600];
    //    }else{
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //        [dateFormatter setDateFormat:@"MM-dd"];
    //        NSDate *pass = [NSDate dateWithTimeIntervalSince1970:[model.time integerValue]];
    //        NSString*day = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:pass]];
    //        _timeLb.text = day;
    //    }
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
