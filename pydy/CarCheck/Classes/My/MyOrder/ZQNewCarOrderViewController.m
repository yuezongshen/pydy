//
//  ZQNewCarOrderViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/1.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNewCarOrderViewController.h"
#import "ZQNoDataView.h"
#import "ZQOrderCell.h"
#import "pydy/pydy.h"
#import "ZQHtmlViewController.h"

#import "NSDictionary+propertyCode.h"

#import "YPayViewController.h"

@interface ZQNewCarOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ZQOrderTypeChooseView *orderHeadView;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSMutableArray *allOrdersList;
@property (strong, nonatomic) NSMutableArray *inProcessList;
@property (strong, nonatomic) NSMutableArray *successList;
@property (strong, nonatomic) NSMutableArray *revocationList;

@property (strong, nonatomic) ZQNoDataView *noDataView;
@property (assign, nonatomic) NSInteger  page;//页面
@end

@implementation ZQNewCarOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新车免检预约订单";
    _currentViewType = ZQNewCarInProcessOrdersView;
    _page = 1;
    [self.view addSubview:self.tableView];
    [self addSegment];
//    [self segmentAction:ZQNewCarInProcessOrdersView];
    [self segmentAction:ZQNewCarAllOrdersView];
}
- (void)requestOrdersDataWithTableViewType
{
    orderHeadView.userInteractionEnabled = YES;
    //我的订单接口 1.处理中，2.已完成 3.退款
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_new_car/u_id/%@/order_status/%u",[Utility getUserID],_currentViewType];
    [ZQLoadingView  showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    [strongSelf configDataWithArray:array];
                }
            }
        }
        else
        {
            if (strongSelf)
            {
                [strongSelf configDataWithArray:@[]];
            }
        }
        [ZQLoadingView hideProgressHUD];
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf configDataWithArray:@[]];
            [ZQLoadingView hideProgressHUD];
        }
    } animated:NO];
    
    
}

- (void)configDataWithArray:(NSArray *)array
{
    switch (_currentViewType) {
        case ZQNewCarInProcessOrdersView:
        {
            if (array.count) {
                self.inProcessList = [ZQNewCarOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_inProcessList];
            }
            else
            {
                [self.inProcessList removeAllObjects];
                [self noDataShowText:@"您无正在处理的订单"];
            }
        }
            break;
        case ZQNewCarSucessOrdersView:
        {
            if (array.count) {
                self.successList = [ZQNewCarOrderModel mj_objectArrayWithKeyValuesArray:array];
               [self reloadDataWithArray:_successList];
            }
            else
            {
                [self.successList removeAllObjects];
                [self noDataShowText:@"您暂时还无已完成订单"];
            }
        }
            break;
        case NewCarRevocationOrdersV:
        {
            if (array.count) {
                self.revocationList = [ZQNewCarOrderModel mj_objectArrayWithKeyValuesArray:array];
               [self reloadDataWithArray:_revocationList];
            }
            else
            {
                [self.revocationList removeAllObjects];
                [self noDataShowText:@"您无撤销订单"];
            }
        }
            break;
        case ZQNewCarAllOrdersView:
        {
            if (array.count) {
                self.allOrdersList = [ZQNewCarOrderModel mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_allOrdersList];
            }
            else
            {
                [self.allOrdersList removeAllObjects];
                [self noDataShowText:@"您无订单记录"];

            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -segmentMethod-
- (void)addSegment
{
    if (!orderHeadView) {
        orderHeadView = [[ZQOrderTypeChooseView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 40)];
        //        [orderHeadView configViewWithArray:@[@"处理中",@"已成功",@"已撤销",@"全部"]];
//        [orderHeadView configViewWithArray:@[@"处理中",@"已成功",@"全部"]];
        [orderHeadView configViewWithArray:@[@"全部",@"处理中",@"已成功"] andType:_currentViewType];
        [self.view addSubview:orderHeadView];
        
        __weak __typeof(self)weakSelf = self;
        orderHeadView.chooseOrderType = ^(NSInteger orderType){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf) {
                switch (orderType) {
                    case 0:
//                        [strongSelf segmentAction:ZQNewCarInProcessOrdersView];
                        [strongSelf segmentAction:ZQNewCarAllOrdersView];
                        break;
                    case 1:
//                        [strongSelf segmentAction:ZQNewCarSucessOrdersView];
                         [strongSelf segmentAction:ZQNewCarInProcessOrdersView];
                        break;
                    case 2:
                        //                        [strongSelf segmentAction:NewCarRevocationOrdersV];
//                        [strongSelf segmentAction:ZQNewCarAllOrdersView];
                           [strongSelf segmentAction:ZQNewCarSucessOrdersView];
                        
                        break;
                    case 3:
                        [strongSelf segmentAction:ZQNewCarAllOrdersView];
                        break;
                    default:
                        break;
                }
            }
        };
    }
}
- (void)segmentAction:(NSInteger)orderType
{
    _currentViewType = (ZQNewCarOrderViewType)orderType;
    switch (orderType) {
        case ZQNewCarInProcessOrdersView:
        {
            //待处理中
            if (self.inProcessList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                [self reloadDataWithArray:_inProcessList];
            }
        }
            break;
        case ZQNewCarSucessOrdersView:
        {
            //已成功
            if (self.successList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                [self reloadDataWithArray:_successList];
            }
        }
            break;
        case NewCarRevocationOrdersV:
        {
            //已撤销
            if (self.revocationList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                [self reloadDataWithArray:_revocationList];
            }
        }
            break;
        case ZQNewCarAllOrdersView:
        {
            //全部
            if (self.allOrdersList.count == 0) {
                orderHeadView.userInteractionEnabled = NO;
                [self requestOrdersDataWithTableViewType];
            }
            else
            {
                [self reloadDataWithArray:_allOrdersList];
            }
        }
            break;
        default:
            break;
    }
}
- (void)reloadDataWithArray:(NSMutableArray *)mArray
{
    [self.noDataView removeFromSuperview];
    self.noDataView = nil;
    [self.tableView setHidden:NO];
    self.dataArr = mArray;
    [self.tableView reloadData];
}
- (void)noDataShowText:(NSString *)str
{
    [self.tableView setHidden:YES];
    [self.view addSubview:self.noDataView];
    self.noDataView.noOrderLabel.text = str;
//    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
}
#pragma mark ==UITableViewDelegate==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _dataArr.count;
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

     ZQOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQOrderCell"];
     if (!cell) {
     cell = [[ZQOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZQOrderCell"];
    [cell.newCarPayBtn addTarget:self action:@selector(newCarPayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
     }
    ZQNewCarOrderModel *orderModel = _dataArr[indexPath.row];
    if (orderModel.order_status.integerValue==1) {
        cell.newCarPayBtn.tag = indexPath.row;
        [cell.newCarPayBtn setHidden:NO];
    }
    else
    {
      [cell.newCarPayBtn setHidden:YES];
    }
    cell.orderModel = orderModel;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return [ZQOrderCell OrderCellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (void)newCarPayBtnAction:(UIButton *)sender
{
    ZQNewCarOrderModel *orderModel = _dataArr[sender.tag];
    YPayViewController *payVC = [[YPayViewController alloc] init];
    //                payVC.payMoney = [Utility getNewCarServiceOutlay];
    payVC.payMoney = orderModel.pay_money;
    payVC.orderNo = orderModel.order_no;
    payVC.aPayType = ZQPayNewCarView;
    [self.navigationController pushViewController:payVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, KWidth, self.view.bounds.size.height-40-64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
