//
//  ZQWalletDetailController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/10.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQWalletDetailController.h"
#import "ZQNoDataView.h"
#import "pydy/pydy.h"
#import "ZQWalletDetailModel.h"

@interface ZQWalletDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    ZQOrderTypeChooseView *orderHeadView;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSMutableArray *allDataList;
@property (strong, nonatomic) NSMutableArray *incomeList;
@property (strong, nonatomic) NSMutableArray *payList;

@property (strong, nonatomic) ZQNoDataView *noDataView;
@property (assign, nonatomic) NSInteger  page;//页面
@property (strong, nonatomic) NSString *status;//订单类型
@end

@implementation ZQWalletDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"钱包明细";
    _status =@"";
    _page = 1;
    [self.view addSubview:self.tableView];
    [self requestWalletDataType];
//    [self addSegment];
//    [self segmentAction:ZQAllDataView];
}
- (void)requestWalletDataType
{
    //收支明细接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_money_detailed/u_id/%@",[Utility getUserID]];
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    strongSelf.dataArr = [ZQWalletDetailModel mj_objectArrayWithKeyValuesArray:array];
                    [strongSelf.tableView reloadData];
                }
            }
        }
    } failure:^(NSError *error) {
    
    } animated:NO];
    
    
}
- (void)requestWalletDataWithType
{
    orderHeadView.userInteractionEnabled = YES;
    switch (_currentWalletType) {
        case ZQAllDataView:
        {
            self.allDataList = [NSMutableArray arrayWithCapacity:0];
            if (self.allDataList.count) {
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"当前没有钱包明细";
            }
        }
            break;
        case ZQIncomeView:
        {
            self.incomeList = [NSMutableArray arrayWithCapacity:0];
            if (self.incomeList.count) {
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"当前没有收入明细";
            }
        }
            break;
        case ZQPayView:
        {
            self.payList = [NSMutableArray arrayWithCapacity:0];
            if (self.payList.count) {
                [self.tableView setHidden:NO];
                [self.noDataView removeFromSuperview];
                self.noDataView = nil;
            }
            else
            {
                [self.tableView setHidden:YES];
                [self.view addSubview:self.noDataView];
                self.noDataView.noOrderLabel.text = @"当前没有支出明细";
            }
        }
            break;
        default:
            break;
    }
}
- (void)addSegment
{
    if (!orderHeadView) {
        orderHeadView = [[ZQOrderTypeChooseView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 40)];
        [orderHeadView configViewWithArray:@[@"全部",@"收入",@"支出"] andType:_currentWalletType];
        [self.view addSubview:orderHeadView];
        
        __weak __typeof(self)weakSelf = self;
        orderHeadView.chooseOrderType = ^(NSInteger orderType){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf segmentAction:orderType];
            }
        };
    }
}
#pragma mark -segmentMethod-
- (void)segmentAction:(NSInteger)walletType
{
    _currentWalletType = (ZQWalletType)walletType;
    switch (walletType) {
        case 0:
        {
            //全部
            if (self.allDataList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestWalletDataWithType];
            }
            else
            {
                self.dataArr = _allDataList;
                [self.tableView reloadData];
            }
        }
            break;
        case 1:
        {
            //收入
            if (self.incomeList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestWalletDataWithType];
            }
            else
            {
                self.dataArr = _incomeList;
                [self.tableView reloadData];
            }
        }
            break;
        case 2:
        {
            //支出
            if (self.payList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestWalletDataWithType];
            }
            else
            {
                self.dataArr = _payList;
                [self.tableView reloadData];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark ==UITableViewDelegate==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _dataArr.count;
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"walletDetails"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"walletDetails"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
        UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
        priceL.font = [UIFont systemFontOfSize:13];
        priceL.textColor = [UIColor lightGrayColor];
        priceL.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = priceL;
//        [cell.contentView addSubview:priceL];
//        priceL.tag = 11111;
    }
    cell.imageView.image = [UIImage imageNamed:@"myMoney"];
    ZQWalletDetailModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.type;

    NSString *moneyStr = [NSString stringWithFormat:@"金额: ￥%@",model.x_my];
    NSRange range = [moneyStr rangeOfString:[NSString stringWithFormat:@"￥%@",model.x_my]];
    NSMutableAttributedString *attachStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attachStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    [cell.detailTextLabel setAttributedText:attachStr];

    UILabel *label = (UILabel *)cell.accessoryView;
    if ([model.time isKindOfClass:[NSString class]]) {
        NSTimeInterval time=[model.time doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        label.text = [dateFormatter stringFromDate: detaildate];
    }
    else
    {
        label.text = @"2017-11-12";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UITableView *)tableView
{
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, KWidth, self.view.bounds.size.height-40) style:(UITableViewStyleGrouped)];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 20)];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}
- (ZQNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[ZQNoDataView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, 200)];
        _noDataView.center = self.view.center;
    }
    return _noDataView;
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
