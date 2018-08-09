//
//  PBActivityDetailController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/20.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBActivityDetailController.h"

@interface PBActivityDetailController ()

@property (nonatomic, strong) UIScrollView *aScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *attachBtn;
@end

@implementation PBActivityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self configDetailView];
    [self.view addSubview:self.aScrollView];

}
- (void)setActivityId:(NSString *)activityId
{
    if (_activityId != activityId) {
        _activityId = activityId;
        [self activityData];
    }
}
- (void)activityData
{
//
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"api/Ln/myhuodongxiangqing" withParameters:@{@"id":self.activityId} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSDictionary *dic = jsonDic[@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    [self configDetailViewWithDic:dic];
                }
            }
        }
        else
        {
           
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
    } animated:NO];

}
- (void)configDetailViewWithDic:(NSDictionary *)dic
{
//    [self.view addSubview:self.aScrollView];
    
    NSString *titleStr = dic[@"InfoTitle"];
    [self.titleLabel setText:titleStr];
    CGSize size = [titleStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(_titleLabel.frame), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    [self.titleLabel setFrame:CGRectMake(15, 10, KWidth-30, size.height+10)];
    [self.aScrollView addSubview:self.titleLabel];
    
    [self.timeLabel setText:dic[@"InfoTime"]];
    [self.aScrollView addSubview:self.timeLabel];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLabel.frame)+10, CGRectGetWidth(_aScrollView.frame), 0.5)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self.aScrollView addSubview:lineV];
    
    NSString *contentStr = dic[@"InfoContent"];
    [self.contentLabel setText:contentStr];
     size = [contentStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(_titleLabel.frame), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil].size;
    [self.contentLabel setFrame:CGRectMake(CGRectGetMinX(_timeLabel.frame), CGRectGetMaxY(_timeLabel.frame)+20, CGRectGetWidth(_titleLabel.frame), size.height+20)];
    [self.aScrollView addSubview:self.contentLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_contentLabel.frame)+10, CGRectGetWidth(_aScrollView.frame)-30, 140)];
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.borderWidth = 1.0;
    [self.aScrollView addSubview:bgView];
    
    NSString *timeStr = @"2018.02.13-2018.03.20 1:00";
    NSString *addressStr = @"北京市西城区委员会社";
    NSString *timeEndStr = @"2018-3-20 00:00";
    NSString *personNumStr = @"40";
    NSString *textStr = [NSString stringWithFormat:@"活动时间: %@\n活动地点: %@\n活动截止时间: %@\n参与人数: %@",timeStr,addressStr,timeEndStr,personNumStr];
//    [self.detailLabel setText:detailStr];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:textStr];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[textStr rangeOfString:timeStr]];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[textStr rangeOfString:addressStr]];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[textStr rangeOfString:timeEndStr]];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[textStr rangeOfString:personNumStr]];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [textStr length])];
    
    [self.detailLabel setAttributedText:attributedString1];


    [self.detailLabel setFrame:CGRectMake(20, 10, CGRectGetWidth(bgView.frame)-40, 110)];
    [bgView addSubview:self.detailLabel];
    
    [self.attachBtn setFrame:CGRectMake(30, CGRectYH(bgView)+50, __kWidth-60, 46)];
    [self.aScrollView addSubview:self.attachBtn];
    [self.attachBtn setEnabled:NO];
//    _attachBtn.backgroundColor = __DefaultColor;
    _attachBtn.backgroundColor = [UIColor lightGrayColor];

    _aScrollView.contentSize = CGSizeMake(KWidth, CGRectYH(_attachBtn)+50);
    [_aScrollView setContentInset:UIEdgeInsetsZero];
}

- (void)attachBtnAction
{
    
}
- (UIScrollView *)aScrollView
{
    if (!_aScrollView) {
        _aScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _aScrollView.backgroundColor = MainBgColor;
    }
    return _aScrollView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+5, 200, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = [UIColor lightGrayColor];
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UIButton *)attachBtn
{
    if (!_attachBtn) {
        _attachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attachBtn.layer.cornerRadius = 4;
        _attachBtn.titleLabel.font = MFont(18);
        [_attachBtn setTitle:@"已参与" forState:BtnNormal];
        [_attachBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
        [_attachBtn addTarget:self action:@selector(attachBtnAction) forControlEvents:BtnTouchUpInside];
    }
    return _attachBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
