//
//  ZQMyMoneyViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/10.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyMoneyViewController.h"
#import "UIButton+UIButtonExt.h"
#import "pydy/pydy.h"
#import "ZQWalletDetailController.h"

#import "ZQNewUpVioViewController.h"
#import "ZQInspectionCell.h"

@interface ZQMyMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, strong) UILabel *showMoneyL;

@property (nonatomic, copy) NSString *pendingCashStr;

@property (nonatomic, strong) CAShapeLayer *coverLayer;
@end

@implementation ZQMyMoneyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMyMoney];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现申请";
    [self.view addSubview:self.tableView];
    [self configTableHeadView];
//    [self cofigTableHeadBottomView];
}

- (void)getMyMoney
{
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"appuser/reflect_list" withParameters:@{@"guide_id":[Utility getUserID]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"][@"reflects"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.listArray = [ZQInspectionModel mj_objectArrayWithKeyValuesArray:array];
                        [strongSelf.tableView reloadData];
                    }
                }
                CashHeadView *headView = (CashHeadView *)strongSelf.tableView.tableHeaderView;
                [headView configTableHeadView:jsonDic[@"data"]];
            }
        }
    } failure:^(NSError *error) {
       
    } animated:NO];
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [self.totalMoneyL setText:@"0"];
//    [self.usableL setText:@"0"];
//    [self.pendingReturnL setText:@"0"];
//}

- (void)withdrawAction
{
    ZQNewUpVioViewController *applyVC = [[ZQNewUpVioViewController alloc] init];
    applyVC.maxMoney = self.pendingCashStr;
    [self.navigationController pushViewController:applyVC animated:YES];
}
- (void)walletBtnAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {
            if ([Utility getWalletPayPassword]) {
//                ZQRechargeViewController *Vc = [[ZQRechargeViewController alloc] init];
//                //    Vc.rechargeSuccess = ^{
//                //
//                //    };
//                [self.navigationController pushViewController:Vc animated:YES];
            }
            else
            {
//                ZQPayPasswordController *payPasswordVc = [[ZQPayPasswordController alloc] initWithType:1];
//                [self.navigationController pushViewController:payPasswordVc animated:YES];
            }
        }
            break;
        case 101:
        {
            [Utility phoneCallAction];
        }
            break;
        case 102:
        {
            ZQWalletDetailController *Vc = [[ZQWalletDetailController alloc] init];
            [self.navigationController pushViewController:Vc animated:YES];
        }
            break;
        default:
            break;
    }
}
//钱包充值
- (void)walletRechargeBtnAction
{
//    ZQRechargeViewController *Vc = [[ZQRechargeViewController alloc] init];
////    Vc.rechargeSuccess = ^{
////        
////    };
//    [self.navigationController pushViewController:Vc animated:YES];

}
//钱包明细
- (void)walletDetailsBtnAction
{
    ZQWalletDetailController *Vc = [[ZQWalletDetailController alloc] init];
    [self.navigationController pushViewController:Vc animated:YES];
}
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    ZQInspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletMoney"];
    if (!cell) {
        cell = [[ZQInspectionCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"walletMoney"];
    }
    cell.inspectionModel = self.listArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10)];
    label.text = @"      账户记录";
    label.backgroundColor = MainBgColor;
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZQInspectionCell inspectionCellHeight];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
        footView.backgroundColor = MainBgColor;
        [_tableView setTableFooterView:footView];
    }
    return _tableView;
}
- (void)configTableHeadView
{
    CashHeadView *bgView = [[CashHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 280)];
    bgView.backgroundColor = HeaderBgColor;
    self.tableView.tableHeaderView = bgView;
    
    __weak typeof(self) weakSelf = self;
    bgView.wDrawClick = ^(NSString *cashStr) {
        [weakSelf withdrawAction];
    };
}

- (void)cofigTableHeadBottomView
{
    CGFloat height = 82;
//    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(16, 162, CGRectGetWidth(self.view.frame)-32, height)];
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(16, 122, CGRectGetWidth(self.view.frame)-32, height)];

//    bottomV.layer.cornerRadius = 6;
//    bottomV.layer.masksToBounds = YES;
    [bottomV setBackgroundColor:LH_RGBCOLOR(238,247,255)];
    [self.tableView.tableHeaderView addSubview:bottomV];
    
    NSArray *imageArr = @[@"walletRecharge",@"withdrawal",@"walletDetails"];
    NSArray *titleArr = @[@"钱包充值",@"钱包提现",@"钱包明细"];
    CGFloat magin = 5;
    CGFloat width = (CGRectGetWidth(bottomV.frame)-magin*4)/3;
    for (int i = 0; i<imageArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake((width+5)*i+magin, magin, width, height-2*magin)];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:__TextColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button centerImageAndTitle];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(walletBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomV addSubview:button];
        button.tag = i + 100;
    }
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(0, 0, width, height)];
//    [button setImage:[UIImage imageNamed:@"walletRecharge"] forState:UIControlStateNormal];
//    [button setTitle:@"钱包充值" forState:UIControlStateNormal];
//    [button setTitleColor:__TextColor forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [button centerImageAndTitle];
//    [button addTarget:self action:@selector(walletRechargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bottomV addSubview:button];
//
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(width, 0, width, height)];
//    [button setImage:[UIImage imageNamed:@"walletDetails"] forState:UIControlStateNormal];
//    [button setTitle:@"钱包明细" forState:UIControlStateNormal];
//    [button setTitleColor:__TextColor forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [button centerImageAndTitle];
//    [button addTarget:self action:@selector(walletDetailsBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [bottomV addSubview:button];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(bottomV.frame)+10, CGRectGetWidth(bottomV.frame), 20)];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setTextColor:[UIColor darkTextColor]];
//    [label setFont:[UIFont systemFontOfSize:15]];
//    label.text = @"热门活动";
//    [self.tableView.tableHeaderView addSubview:label];
//
//    label = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(label.frame), CGRectGetWidth(label.frame), 20)];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setTextColor:__TextColor];
//    [label setFont:[UIFont systemFontOfSize:13]];
//    label.text = @"您感兴趣的活动";
//    [self.tableView.tableHeaderView addSubview:label];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
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
