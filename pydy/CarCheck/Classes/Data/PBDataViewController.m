//
//  PBDataViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/15.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBDataViewController.h"
#import "PBClerkView.h"

#import "PieCharVIew.h"
#import "PieCharModel.h"

#import "PBInfoViewController.h"
#import "ZQChoosePickerView.h"
#import "ZQLoginViewController.h"
#import "BaseNavigationController.h"

#import "UIImageView+WebCache.h"

@interface PBDataViewController ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) PBClerkView *clerkV;
@property (nonatomic, strong) UIButton *yearBtn;
@property (nonatomic, strong) UIButton *quarterBtn;
@property (nonatomic, strong) UIButton *monthBtn;
@property (nonatomic, strong) UIButton *dataBtn;

@property (nonatomic, strong) UILabel *totalRankL;
@property (nonatomic, strong) UILabel *scoreRankL;
@property (nonatomic, strong) UILabel *totalScoreL;
@property (nonatomic, strong) UILabel *basicScoreL;
@property (nonatomic, strong) UILabel *firstScoreL;
@property (nonatomic, strong) UILabel *currentScoreL;

@property (nonatomic, strong) ZQChoosePickerView *pickView;

@property (nonatomic, assign) BOOL requestSucc;

@property (nonatomic, strong) PieCharView *pieChar;
@property (nonatomic, strong) UIImageView *bgImageV;
@end

@implementation PBDataViewController

- (void)dealloc
{
    NSLog(@"PBDataViewController dealloc");
}
- (void)changeHeadImage:(UIImage *)image
{
    [self.clerkV.imgV setImage:image];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([Utility isLogin]) {
        if (_requestSucc) {
            
        }
        else
        {
            [self requestPBData];
        }
    }
    else
    {
        [self.clerkV setcontentData:nil];
    }
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bgScrollView];
    [self configSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requstStatuesChange) name:ZQdidLogoutNotication object:nil];
}
- (void)requstStatuesChange
{
    self.requestSucc = NO;
}
- (void)requestPBData
{
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"api/Ln/djdata" withParameters:@{@"token":[Utility getWalletPayPassword],@"year":self.yearBtn.titleLabel.text,@"quarter":self.quarterBtn.titleLabel.text,@"month":self.monthBtn.titleLabel.text,@"integral":self.dataBtn.titleLabel.text} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                [strongSelf.clerkV setcontentData:jsonDic[@"data"]];
                strongSelf.totalRankL.attributedText = [strongSelf LabelAttributedTitle:[NSString stringWithFormat:@"%@",jsonDic[@"data"][@"zongfenp"]] subTitle:@"总分排名"];
                strongSelf.scoreRankL.attributedText = [strongSelf LabelAttributedTitle:[NSString stringWithFormat:@"%@",jsonDic[@"data"][@"defenp"]] subTitle:@"得分排名"];
                strongSelf.totalScoreL.attributedText = [strongSelf LabelAttributedTitle:[NSString stringWithFormat:@"%@",jsonDic[@"data"][@"zongfen"]] subTitle:@"总分"];
                strongSelf.totalRankL.attributedText = [strongSelf LabelAttributedTitle:[NSString stringWithFormat:@"%@",jsonDic[@"data"][@"jibenfen"]] subTitle:@"基本分"];
                strongSelf.firstScoreL.attributedText = [strongSelf LabelAttributedTitle:[NSString stringWithFormat:@"%@",jsonDic[@"data"][@"shangqizongfen"]] subTitle:@"上期总分"];
                strongSelf.currentScoreL.attributedText = [strongSelf LabelAttributedTitle:[NSString stringWithFormat:@"%@",jsonDic[@"data"][@"dangqizongfen"]] subTitle:@"当前得分"];
                strongSelf.requestSucc = YES;
                NSString *imageUrl = jsonDic[@"img"];
                if ([imageUrl isKindOfClass:[NSString class]]) {
                    if (imageUrl.length) {
                        [strongSelf.bgImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageBaseAPI,imageUrl]] placeholderImage:[UIImage imageNamed:@"data_bg.jpg"]];
                        [strongSelf.pieChar setHidden:YES];
                        [strongSelf.bgImageV setHidden:NO];
                        return ;
                    }
                }
                NSArray *array = jsonDic[@"data"][@"Roundcake"];
                NSMutableArray *contentArr = [NSMutableArray arrayWithCapacity:0];
                NSArray *colorArray = @[[UIColor colorWithRed:66.0/255.0 green:114.0/255.0 blue:197.0/255.0 alpha:1.0],[UIColor colorWithRed:90.0/255.0 green:155.0/255.0 blue:214.0/255.0 alpha:1.0],[UIColor colorWithRed:234.0/255.0 green:125.0/255.0 blue:49.0/255.0 alpha:1.0],[UIColor colorWithRed:163.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0],[UIColor colorWithRed:252.0/255.0 green:193.0/255.0 blue:0 alpha:1.0]];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        for (int i = 0; i<array.count; i++) {
                            NSDictionary *dic = array[i];
                            PieCharModel *model1 = [[PieCharModel alloc] init];
                            model1.title = dic[@"title"];
                            model1.percent = dic[@"value"];
                            if (i<colorArray.count) {
                                model1.color = colorArray[i];
                            }
                            else
                            {
                                model1.color = [strongSelf randomColor];
                            }
                            [contentArr addObject:model1];
                        }
                    }
                }
                if (contentArr.count) {
                    strongSelf.pieChar.dataArray = contentArr;
                    [strongSelf.bgImageV setHidden:YES];
                    [strongSelf.pieChar setHidden:NO];
                }
                else
                {
                    [strongSelf.bgImageV setHidden:NO];
                    [strongSelf.pieChar setHidden:YES];
                }
            }
        }
        else
        {
            [self.clerkV setcontentData:nil];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        [self.clerkV setcontentData:nil];

    } animated:NO];
}

- (void)configSubViews
{
    UIView *siftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgScrollView.frame), 120)];
    siftView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:siftView];
    
    [siftView addSubview:self.clerkV];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_clerkV.frame)+10, CGRectGetWidth(_clerkV.frame), 0.5)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self.bgScrollView addSubview:lineV];
    
    CGFloat btnWidth = CGRectGetWidth(self.bgScrollView.frame)/4;
    self.yearBtn =  [self siftInstallWithTitle:@"2018" frame:CGRectMake(0, CGRectGetMaxY(lineV.frame), btnWidth, 48)];
    [siftView addSubview:self.yearBtn];
    [self.yearBtn addTarget:self action:@selector(yearBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.quarterBtn = [self siftInstallWithTitle:@"1季度" frame:CGRectMake(CGRectGetMaxX(self.yearBtn.frame), CGRectGetMaxY(lineV.frame), btnWidth, 48)];
    [siftView addSubview:self.quarterBtn];
    [self.quarterBtn addTarget:self action:@selector(quarterBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.monthBtn = [self siftInstallWithTitle:@"1月" frame:CGRectMake(CGRectGetMaxX(self.quarterBtn.frame), CGRectGetMaxY(lineV.frame), btnWidth, 48)];
    [siftView addSubview:self.monthBtn];
    [self.monthBtn addTarget:self action:@selector(monthBtnAction) forControlEvents:UIControlEventTouchUpInside];

    self.dataBtn = [self siftInstallWithTitle:@"积分数据" frame:CGRectMake(CGRectGetMaxX(self.monthBtn.frame), CGRectGetMaxY(lineV.frame), btnWidth, 48)];
    [siftView addSubview:self.dataBtn];
    [self.dataBtn addTarget:self action:@selector(dataBtnAction) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *showV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(siftView.frame)+10, CGRectGetWidth(_bgScrollView.frame), 140)];
    showV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:showV];
    
    CGFloat width = CGRectGetWidth(_bgScrollView.frame)/3;
    CGFloat height = 70;
    self.totalRankL = [self scoreLabelInstallWithTitle:@"0" subTitle:@"总分排名" frame:CGRectMake(0, 0, width, height)];
    [showV addSubview:self.totalRankL];
    
    self.scoreRankL = [self scoreLabelInstallWithTitle:@"0" subTitle:@"得分排名" frame:CGRectMake(CGRectGetMaxX(self.totalRankL.frame), 0, width, height)];
    [showV addSubview:self.scoreRankL];
    self.totalScoreL = [self scoreLabelInstallWithTitle:@"0" subTitle:@"总分" frame:CGRectMake(CGRectGetMaxX(self.scoreRankL.frame), 0, width, height)];
    [showV addSubview:self.totalScoreL];
    self.basicScoreL = [self scoreLabelInstallWithTitle:@"0" subTitle:@"基本分"  frame:CGRectMake(0, CGRectGetMaxY(self.scoreRankL.frame), width, height)];
    [showV addSubview:self.basicScoreL];
    self.firstScoreL = [self scoreLabelInstallWithTitle:@"0" subTitle:@"上期总分" frame:CGRectMake(CGRectGetMaxX(self.basicScoreL.frame), CGRectGetMaxY(self.scoreRankL.frame), width, height)];
    [showV addSubview:self.firstScoreL];
    self.currentScoreL = [self scoreLabelInstallWithTitle:@"0" subTitle:@"当期得分" frame:CGRectMake(CGRectGetMaxX(self.firstScoreL.frame), CGRectGetMaxY(self.scoreRankL.frame), width, height)];
    [showV addSubview:self.currentScoreL];
    
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, CGRectGetHeight(showV.frame))];
    v1.backgroundColor = [UIColor lightGrayColor];
    [showV addSubview:v1];
    
    v1 = [[UIView alloc] initWithFrame:CGRectMake(width*2, 0, 0.5, CGRectGetHeight(showV.frame))];
    v1.backgroundColor = [UIColor lightGrayColor];
    [showV addSubview:v1];
    
    v1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scoreRankL.frame), CGRectGetWidth(_bgScrollView.frame),0.5)];
    v1.backgroundColor = [UIColor lightGrayColor];
    [showV addSubview:v1];
    
    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(showV.frame)+10, CGRectGetWidth(_bgScrollView.frame), 280)];
    dataView.backgroundColor = [UIColor whiteColor];
    [self.bgScrollView addSubview:dataView];
    
    self.pieChar = [[PieCharView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_bgScrollView.frame)-20, 280)];
    self.pieChar.backgroundColor = [UIColor whiteColor];
    self.pieChar.textColor = [UIColor lightGrayColor];
    self.pieChar.textFont = [UIFont systemFontOfSize:12];
    self.pieChar.radius = 90;
    [dataView addSubview:self.pieChar];
    
    
//    PieCharModel *model2 = [[PieCharModel alloc] init];
//    model2.title = @"党员积分";
//    model2.percent = @"0.05";
//    model2.color = [UIColor colorWithRed:163.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0];
//
//    PieCharModel *model3 = [[PieCharModel alloc] init];
//    model3.title = @"党员排名";
//    model3.percent = @"0.25";
//    model3.color = [UIColor colorWithRed:252.0/255.0 green:193.0/255.0 blue:0 alpha:1.0];
//
//    PieCharModel *model4 = [[PieCharModel alloc] init];
//    model4.title = @"学员自学";
//    model4.percent = @"0.15";
//    model4.color = [UIColor colorWithRed:66.0/255.0 green:114.0/255.0 blue:197.0/255.0 alpha:1.0];
//
//    PieCharModel *model5 = [[PieCharModel alloc] init];
//    model5.title = @"先锋作用";
//    model5.percent = @"0.3";
//    model5.color = [UIColor colorWithRed:90.0/255.0 green:155.0/255.0 blue:214.0/255.0 alpha:1.0];
//
//    pieChar.dataArray = @[model1, model2, model3, model4,model5];
    
    self.bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"data_bg.jpg"]];
//    imageV.center = CGPointMake(CGRectGetWidth(_bgScrollView.frame)/2, 140);
    self.bgImageV.frame = CGRectMake(0, 0, CGRectGetWidth(_bgScrollView.frame), 280);
    self.bgImageV.contentMode = UIViewContentModeScaleAspectFit;
    [dataView addSubview:self.bgImageV];
    
}
-(ZQChoosePickerView *)pickView {
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, KWidth, 300)];
    }
    return _pickView;
}

- (void)yearBtnAction
{
    [self hiddenView];
    NSMutableArray *yearArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 2018; i>1970; i--) {
        [yearArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:yearArr inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                [weakSelf.yearBtn setTitle:selectedStr forState:UIControlStateNormal];
            }
        }
    }];
}
- (void)quarterBtnAction
{
    [self hiddenView];
    NSArray *yearArr = @[@"1季度",@"2季度",@"3季度",@"4季度"];
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:yearArr inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                [weakSelf.quarterBtn setTitle:selectedStr forState:UIControlStateNormal];
                if ([selectedStr isEqualToString:@"1季度"]) {
                [weakSelf configBtnWithString:@"1月" button:weakSelf.monthBtn];
                }
                else if ([selectedStr isEqualToString:@"2季度"])
                {
                    [weakSelf configBtnWithString:@"4月" button:weakSelf.monthBtn];
                }
                else if ([selectedStr isEqualToString:@"3季度"])
                {
                    [weakSelf configBtnWithString:@"5月" button:weakSelf.monthBtn];
                }
                else if ([selectedStr isEqualToString:@"4季度"])
                {
                    [weakSelf configBtnWithString:@"9月" button:weakSelf.monthBtn];
                }
            }
        }
    }];
}
- (void)monthBtnAction
{
    [self hiddenView];
    NSArray *monthArr = nil;
    if ([self.quarterBtn.titleLabel.text isEqualToString:@"1季度"]) {
        monthArr = @[@"1月",@"2月",@"3月"];
    }
    else if ([self.quarterBtn.titleLabel.text isEqualToString:@"2季度"])
    {
        monthArr = @[@"4月",@"5月",@"6月"];
    }
    else if ([self.quarterBtn.titleLabel.text isEqualToString:@"3季度"])
    {
     monthArr = @[@"7月",@"8月",@"9月"];
    }
    else if ([self.quarterBtn.titleLabel.text isEqualToString:@"4季度"])
    {
      monthArr = @[@"10月",@"11月",@"12月"];
        }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:monthArr inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                [weakSelf configBtnWithString:selectedStr button:weakSelf.monthBtn];
            }
        }
    }];
}
- (void)configBtnWithString:(NSString *)string button:(UIButton *)btn
{
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}];
    [btn setTitle:string forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"downArrow"];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width+2, 0, -size.width-2)];
}
- (void)dataBtnAction
{
    [self hiddenView];
    NSArray *dataArr = @[@"0~20",@"20~40",@"40~60",@"60~80",@"80~100",@"100+"];
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:dataArr inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                [weakSelf configBtnWithString:selectedStr button:weakSelf.dataBtn];
            }
        }
    }];
}
- (void)hiddenView {
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
}
- (UIButton *)siftInstallWithTitle:(NSString *)title frame:(CGRect)rect
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:rect];
    [button setTitle:title forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"downArrow"];
    [button setImage:image forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
//    button.titleLabel.textColor = [UIColor darkGrayColor];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, size.width+2, 0, -size.width-2)];

    return button;
}
- (UILabel *)scoreLabelInstallWithTitle:(NSString *)title subTitle:(NSString *)subTitle frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.font = MFont(16);
//    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:string];
//    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:title]];
//    [attr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(153, 153, 153) range:[string rangeOfString:subTitle]];
    label.attributedText = [self LabelAttributedTitle:title subTitle:subTitle];
    return label;
}
- (NSMutableAttributedString *)LabelAttributedTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    NSString *string = [NSString stringWithFormat:@"%@\n%@",title,subTitle];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:string];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:title]];
    [attr addAttribute:NSForegroundColorAttributeName value:LH_RGBCOLOR(153, 153, 153) range:[string rangeOfString:subTitle]];
    return attr;
}
- (UIScrollView *)bgScrollView
{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _bgScrollView.backgroundColor = MainBgColor;
        _bgScrollView.contentSize = CGSizeMake(KWidth, 600);
    }
    return _bgScrollView;
}
- (PBClerkView *)clerkV
{
    if (!_clerkV) {
        _clerkV = [[PBClerkView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 60)];
        _clerkV.backgroundColor = [UIColor whiteColor];
        __weak __typeof(self) weakSelf = self;
        _clerkV.clerkViewAction = ^{
            if ([Utility isLogin])
            {
            PBInfoViewController *vc = [[PBInfoViewController alloc] init];
            vc.title = @"个人信息";
            [vc setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
                BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
                [weakSelf.navigationController presentViewController:loginNa animated:YES completion:^{
                    
                }];
            }
        };
    }
    return _clerkV;
}
- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
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
