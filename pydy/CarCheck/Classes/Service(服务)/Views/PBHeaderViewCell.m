//
//  PBHeaderViewCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/15.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBHeaderViewCell.h"
#import "UIImageView+WebCache.h"
#import "ZQOrderObject.h"
#import "ZQBannerModel.h"

@interface PBHeaderViewCell ()
{
    CGFloat spaceX;
    CGFloat spaceY;
}
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *distanceLabel;
@property (strong,nonatomic) UILabel *desLabel;
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *contactLabel;
@end

@implementation PBHeaderViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MainBgColor;
        spaceX = 10;
        spaceY = 8;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(spaceX, spaceX, __kWidth-spaceX*2, 100+spaceY*2)];
        bgView.layer.cornerRadius = 4;
        bgView.layer.masksToBounds = YES;
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        [bgView addSubview:self.titleLabel];
        [bgView addSubview:self.distanceLabel];
        [bgView addSubview:self.desLabel];
        
        [bgView addSubview:self.nameLabel];
        UIView *pV = [self getPointView];
        pV.center = CGPointMake(spaceX+4, self.nameLabel.center.y+2);
        [bgView addSubview:pV];
        [bgView addSubview:self.contactLabel];
        pV = [self getPointView];
        pV.center = CGPointMake(spaceX+4, self.contactLabel.center.y+2);
        [bgView addSubview:pV];
        [bgView addSubview:self.timeLabel];
        pV = [self getPointView];
        pV.center = CGPointMake(spaceX+4, self.timeLabel.center.y+2);
        [bgView addSubview:pV];
        
        
        UIButton *logonBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(bgView.frame)-spaceX-48-60, CGRectGetMinY(self.contactLabel.frame), 60, 20)];
        logonBtn .titleLabel.font = MFont(13);
        logonBtn.backgroundColor =[UIColor clearColor];
        [logonBtn setTitle:@"联系游客" forState:BtnNormal];
        [logonBtn setTitleColor:__MoneyColor forState:BtnNormal];
        [logonBtn addTarget:self action:@selector(contactBtnAction) forControlEvents:BtnTouchUpInside];
        [bgView addSubview:logonBtn];

        UIButton *actionBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(bgView.frame)-spaceX-48, CGRectGetHeight(bgView.frame)-48-spaceY*2, 48, 48)];
        actionBtn .titleLabel.font = MFont(13);
        actionBtn.backgroundColor = __MoneyColor;
        actionBtn.layer.cornerRadius = CGRectGetWidth(actionBtn.frame)/2;
        [actionBtn setTitle:@"开始\n服务" forState:BtnNormal];
        actionBtn.titleLabel.numberOfLines = 2;
        [actionBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
        [actionBtn addTarget:self action:@selector(serverActionBtn) forControlEvents:BtnTouchUpInside];
        [bgView addSubview:actionBtn];
        self.operateBtn = actionBtn;
    }
    return self;
}
- (void)contactBtnAction
{
    [Utility callTraveller:self.orderObj.guestphone];
}
- (void)serverActionBtn
{
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/startServers" withParameters:@{@"id":self.orderObj.ID,@"user_id":[Utility getUserID],@"istype":[NSString stringWithFormat:@"%ld",self.orderObj.is_confirm.integerValue+1]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf performSelector:@selector(reloadServerMainView) withObject:nil afterDelay:SXLoadingTime];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
    } animated:YES];
}
- (void)reloadServerMainView
{
    if (self.reloadHomeV) {
        self.reloadHomeV();
    }
}

- (void)setOrderObj:(ZQOrderObject *)orderObj
{
    if (_orderObj != orderObj) {
        _orderObj = orderObj;
        if (_orderObj) {
            [self.titleLabel setText:@"预约信息"];
            [self.distanceLabel setText:[NSString stringWithFormat:@"约%@km",@"2.2"]];
            [self.desLabel setText:[NSString stringWithFormat:@"距离服务开始还有%@，请及时联系游客",_orderObj.appoint_time]];
            switch ([self desLabelTextColorWithStr:_orderObj.appoint_time]) {
                case 1:
                {
                    _desLabel.textColor = [UIColor redColor];
                }
                    break;
                case 2:
                {
                    _desLabel.textColor = __TestRedColor;
                }
                    break;
                case 3:
                {
                    _desLabel.textColor = __DesGreenColor;
                }
                    break;
                default:
                    break;
            }
            [self.operateBtn setHidden:NO];
            switch (_orderObj.is_confirm.integerValue) {
                case 0:
                {
                    self.operateBtn.backgroundColor = __MoneyColor;
                    [self.operateBtn setTitle:@"确认\n接单" forState:BtnNormal];
                }
                    break;
                case 1:
                {
                    self.operateBtn.backgroundColor = __MoneyColor;
                    [self.operateBtn setTitle:@"开始\n服务" forState:BtnNormal];
                }
                    break;
                case 2:
                {
                    self.operateBtn.backgroundColor = [UIColor lightGrayColor];
                    [self.operateBtn setTitle:@"结束\n服务" forState:BtnNormal];
                }
                    break;
                default:
                {
                    [self.operateBtn setHidden:YES];
                }
                    break;
            }
            [self.nameLabel setAttributedText:[self attributedWithTitle:@"游客姓名:" content:_orderObj.name]];
            [self.contactLabel setAttributedText:[self attributedWithTitle:@"联系方式:" content:_orderObj.guestphone]];
            [self.timeLabel setAttributedText:[self attributedWithTitle:@"预约时间:" content:_orderObj.appointment_time]];
        }
        else
        {
            [self.titleLabel setText:@"预约信息"];
            [self.distanceLabel setText:[NSString stringWithFormat:@"约%@km",@"--"]];
            [self.desLabel setText:[NSString stringWithFormat:@"距离服务开始还有%@小时，请及时联系游客",@"--"]];
            
            [self.nameLabel setAttributedText:[self attributedWithTitle:@"游客姓名:" content:@"--"]];
            [self.contactLabel setAttributedText:[self attributedWithTitle:@"联系方式:" content:@"--"]];
            [self.timeLabel setAttributedText:[self attributedWithTitle:@"预约时间:" content:@"--"]];
        }
    }
}
- (NSInteger)desLabelTextColorWithStr:(NSString *)time
{
    if (time.length) {
        if ([time rangeOfString:@"天"].location == NSNotFound) {
            if ([time rangeOfString:@"小时"].location == NSNotFound)
            {
                if ([time rangeOfString:@"分"].location != NSNotFound)
                {
                    CGFloat minute = [[time componentsSeparatedByString:@"分"].firstObject floatValue];
                    if (minute>30) {
                        return 2;
                    }
                    else
                    {
                        return 1;
                    }
                }
                
            }
            else
            {
                CGFloat hour = [[time componentsSeparatedByString:@"小时"].firstObject floatValue];
                if (hour>5) {
                    return 3;
                }
                else
                {
                    return 2;
                }
            }
        }
        else
        {
            NSArray *dayArr = [time componentsSeparatedByString:@"天"];
            CGFloat day = [dayArr.firstObject floatValue];
            if (day) {
                return 3;
            }
            else
            {
                NSArray *hourArr = [dayArr.lastObject componentsSeparatedByString:@"小时"];
                CGFloat hour = [hourArr.firstObject floatValue];
                if (hour) {
                    if (hour>5) {
                        return 3;
                    }
                    else
                    {
                        return 2;
                    }
                }
                else
                {
                    CGFloat minute = [[hourArr.lastObject componentsSeparatedByString:@"分"].firstObject floatValue];
                    if (minute>30) {
                        return 2;
                    }
                    else
                    {
                        return 1;
                    }
                }
            }
        }
    }
    else
    {
        [self.desLabel setText:@"该订单已过期"];
    }
    return 3;
}
- (NSMutableAttributedString *)attributedWithTitle:(NSString *)title content:(NSString *)contStr
{
    NSString *totalStr = [NSString stringWithFormat:@"%@   %@",title,contStr];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attributedString1 addAttributes:@{NSForegroundColorAttributeName:__TestGColor,NSFontAttributeName:[UIFont systemFontOfSize:11]} range:[totalStr rangeOfString:title]];
    [attributedString1 addAttributes:@{NSForegroundColorAttributeName:__TestOColor,NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[totalStr rangeOfString:contStr]];
    return attributedString1;
}
- (UIView *)getPointView
{
    UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    pointView.backgroundColor = __MoneyColor;
    pointView.layer.cornerRadius = 2;
    pointView.layer.masksToBounds = YES;
    return pointView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(spaceX,spaceY, 100,20)];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel  = [[UILabel alloc] initWithFrame:CGRectMake(__kWidth-spaceX*3-60,CGRectGetMinY(_titleLabel.frame),60,20)];
        _distanceLabel.textColor = HEXCOLOR(0x777777);
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _distanceLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel  = [[UILabel alloc] initWithFrame:CGRectMake(spaceX,CGRectGetMaxY(_titleLabel.frame), __kWidth-spaceX*4,20)];
        _desLabel.textColor = __TestRedColor;
        _desLabel.font = [UIFont systemFontOfSize:12];
    }
    return _desLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(spaceX*3-4,CGRectGetMaxY(_desLabel.frame), 120,20)];
    }
    return _nameLabel;
}
- (UILabel *)contactLabel{
    if (!_contactLabel) {
        _contactLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame),CGRectGetMaxY(_nameLabel.frame), 160,CGRectGetHeight(_nameLabel.frame))];
    }
    return _contactLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame),CGRectGetMaxY(_contactLabel.frame), 260,CGRectGetHeight(_nameLabel.frame))];
    }
    return _timeLabel;
}
@end
