//
//  PBDetailViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/29.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface PBDetailViewController ()

@property (nonatomic, strong) UIScrollView *aScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation PBDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setDetailContent:(NSDictionary *)detailContent
{
    if (_detailContent != detailContent) {
        _detailContent = detailContent;
        [self pbDetailViewWithDic];
    }
}
- (void)pbDetailViewWithDic
{
    [self.view addSubview:self.aScrollView];
    
    NSString *titleStr = _detailContent[@"InfoTitle"];
    [self.titleLabel setText:titleStr];
    CGSize size = [titleStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(_titleLabel.frame), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil].size;
    [self.titleLabel setFrame:CGRectMake(15, 10, KWidth-30, size.height+10)];
    [self.aScrollView addSubview:self.titleLabel];
    
    [self.timeLabel setText:_detailContent[@"InfoTime"]];
    [self.aScrollView addSubview:self.timeLabel];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLabel.frame)+10, CGRectGetWidth(_aScrollView.frame), 0.5)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self.aScrollView addSubview:lineV];
    
   
    NSString *contentStr = _detailContent[@"InfoContent"];
    [self.contentLabel setText:contentStr];
    size = [contentStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(_titleLabel.frame), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil].size;
    NSString *imageUrl = [Utility verifyActionWithString:_detailContent[@"InfoPicture"]];
    if (imageUrl.length) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_timeLabel.frame), CGRectGetMaxY(_timeLabel.frame)+20, CGRectGetWidth(_titleLabel.frame), kHeightScale(220))];
        [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseAPI,imageUrl]] placeholderImage:[UIImage imageNamed:@"agency"]];
        [self.aScrollView addSubview:imageV];
        [self.contentLabel setFrame:CGRectMake(CGRectGetMinX(_timeLabel.frame), CGRectGetMaxY(imageV.frame)+20, CGRectGetWidth(_titleLabel.frame), size.height+20)];
    }
    else
    {
        [self.contentLabel setFrame:CGRectMake(CGRectGetMinX(_timeLabel.frame), CGRectGetMaxY(_timeLabel.frame)+20, CGRectGetWidth(_titleLabel.frame), size.height+20)];
    }
    [self.aScrollView addSubview:self.contentLabel];

    _aScrollView.contentSize = CGSizeMake(KWidth, CGRectYH(_contentLabel)+50);
    [_aScrollView setContentInset:UIEdgeInsetsZero];
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
