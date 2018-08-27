//
//  ZQMyOrderViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyOrderViewController.h"
#import "ZQNoDataView.h"
#import "pydy/pydy.h"

#import "ZQMyBooingCell.h"
#import "ZQHtmlViewController.h"

#import "ZQSubTimeViewController.h"
#import "ZQNewCarCheckController.h"

#import "ZQOrderObject.h"

#import "ZQLocationServer.h"

@interface ZQMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    ZQOrderTypeChooseView *orderHeadView;
    
    NSInteger seletedIndex;
    NSInteger orderStatus;
//    BMKLocationManager *_locationManager;
}
//@property (nonatomic, strong) NSTimer *locationTimer;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArr;

@property (strong, nonatomic) NSMutableArray *allOrdersList;
@property (strong, nonatomic) NSMutableArray *inProcessList;
@property (strong, nonatomic) NSMutableArray *successList;
@property (strong, nonatomic) NSMutableArray *revocationList;

@property (strong, nonatomic) ZQNoDataView *noDataView;
@property (assign, nonatomic) NSInteger  page;//页面
@end

@implementation ZQMyOrderViewController

- (instancetype)initWithOrderViewType:(ZQOrderViewType)orderType
{
    self = [super init];
    if (self) {
        _currentViewType = orderType;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    _page = 1;
   
    
    [self segmentAction:_currentViewType];
    
    [self.view addSubview:self.tableView];
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf segmentAction:weakSelf.currentViewType];
    }];
    
    [self addSegment];
}

- (void)requestOrdersDataWithTableViewType
{
    orderHeadView.userInteractionEnabled = YES;
//        状态导游是否确认 0 是待确认 1是进行中 2完成
    NSInteger confirm = _currentViewType;
    if (confirm == 2) {
        confirm = 3;
    }
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/order" withParameters:@{@"is_confirm":[NSString stringWithFormat:@"%ld",(long)confirm],@"guide_id":[Utility getUserID],@"page":[NSString stringWithFormat:@"%ld",(long)_page]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"];
                if ([array isKindOfClass:[NSArray class]]) {
                    [strongSelf configDataWithArray:array];
                    if (array.count<5) {
                        [strongSelf configMJ_footer:YES];
                    }
                    else
                    {
                        [strongSelf configMJ_footer:NO];
                    }
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
        [strongSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf configDataWithArray:@[]];
        }
        [strongSelf.tableView.mj_header endRefreshing];
        if (strongSelf.tableView.mj_footer) {
            [strongSelf.tableView.mj_footer endRefreshing];
        }
    } animated:YES];
}

- (void)loadMoreData
{
    self.page++;
    //        状态导游是否确认 0 是待确认 1是进行中 2完成
    NSInteger confirm = _currentViewType;
    if (confirm == 2) {
        confirm = 3;
    }
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/order" withParameters:@{@"is_confirm":[NSString stringWithFormat:@"%ld",(long)confirm],@"guide_id":[Utility getUserID],@"page":[NSString stringWithFormat:@"%ld",(long)_page]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"];
                if ([array isKindOfClass:[NSArray class]]) {
                    [strongSelf.tableView.mj_footer endRefreshing];
                    [strongSelf configMoreDataWithArray:array];
                    if (array.count<5) {
                        [strongSelf configMJ_footer:YES];
                    }
                    else
                    {
                      [strongSelf configMJ_footer:NO];
                    }
                    return ;
                }
            }
        }
        if (strongSelf.tableView.mj_footer) {
            [strongSelf.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.tableView.mj_footer) {
            [strongSelf.tableView.mj_footer endRefreshing];
        }
    } animated:YES];
}
- (void)configMJ_footer:(BOOL)show
{
    if (show) {
        self.tableView.mj_footer = nil;
    }
    else
    {
        if (!self.tableView.mj_footer) {
            __weak typeof(self) weakSelf = self;
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf loadMoreData];
            }];
        }
    }
}
- (void)configMoreDataWithArray:(NSArray *)array
{
    switch (_currentViewType) {
        case ZQInProcessOrdersView:
        {
            [self.inProcessList addObjectsFromArray:[ZQOrderObject mj_objectArrayWithKeyValuesArray:array]];
            [self reloadMoreDataWithArray:_inProcessList];
          

        }
            break;
        case ZQSucessOrdersView:
        {
            [self.successList addObjectsFromArray:[ZQOrderObject mj_objectArrayWithKeyValuesArray:array]];
            [self reloadMoreDataWithArray:_successList];
        }
            break;
        case ZQToBeConfirmView:
        {
            [self.allOrdersList addObjectsFromArray:[ZQOrderObject mj_objectArrayWithKeyValuesArray:array]];
            [self reloadMoreDataWithArray:_allOrdersList];
        }
            break;
        default:
            break;
    }
}
- (void)configDataWithArray:(NSArray *)array
{
    switch (_currentViewType) {
        case ZQInProcessOrdersView:
        {
            if (array.count) {
                self.inProcessList = [ZQOrderObject mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_inProcessList];
            }
            else
            {
                [self.inProcessList removeAllObjects];
                [self noDataShowText:@"您暂无进行中的订单"];
            }
        }
            break;
        case ZQSucessOrdersView:
        {
            if (array.count) {
                self.successList = [ZQOrderObject mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_successList];
            }
            else
            {
                [self.successList removeAllObjects];
                [self noDataShowText:@"您暂无已完成订单"];
            }
        }
            break;
        case ZQToBeConfirmView:
        {
            if (array.count) {
                self.allOrdersList = [ZQOrderObject mj_objectArrayWithKeyValuesArray:array];
                [self reloadDataWithArray:_allOrdersList];
            }
            else
            {
                [self.allOrdersList removeAllObjects];
                [self noDataShowText:@"您暂无待确认订单"];
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
        CGFloat spaceY = (kDevice_Is_iPhoneX ? 88:64);
        orderHeadView = [[ZQOrderTypeChooseView alloc] initWithFrame:CGRectMake(0, spaceY, CGRectGetWidth(self.view.frame), 36)];
        [orderHeadView configViewWithArray:@[@"待确认",@"进行中",@"已完成",] andType:_currentViewType];

        [self.view addSubview:orderHeadView];
        
        __weak __typeof(self)weakSelf = self;
        orderHeadView.chooseOrderType = ^(NSInteger orderType){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.currentViewType = (ZQOrderViewType)orderType;
                switch (orderType) {
                    case 0:
                        [strongSelf segmentAction:ZQToBeConfirmView];
                        break;
                    case 1:
                        [strongSelf segmentAction:ZQInProcessOrdersView];
                        break;
                    case 2:
                        [strongSelf segmentAction:ZQSucessOrdersView];
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
    switch (orderType) {
        case ZQInProcessOrdersView:
        {
            //进行中
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
        case ZQSucessOrdersView:
        {
            //已完成
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
        case ZQToBeConfirmView:
        {
            //待确认
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
- (void)reloadMoreDataWithArray:(NSMutableArray *)mArray
{
    self.dataArr = mArray;
    [self.tableView reloadData];
}
- (void)reloadDataWithArray:(NSMutableArray *)mArray
{
    if (self.noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
    }
    [self.tableView setHidden:NO];
    self.dataArr = mArray;
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableView.mj_header endRefreshing];

//    [self performSelector:@selector(scrollToTopAction) withObject:nil afterDelay:1.0];
}
- (void)scrollToTopAction
{
//    [self.tableView setContentOffset:CGPointZero animated:YES];
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
    
    static NSString *cellIdentifier = @"ZQMyBooingCell";
    ZQMyBooingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ZQMyBooingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.operateBtn addTarget:self action:@selector(operateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.operateBtn.tag = indexPath.row;
    [cell configOrderViewCell:self.dataArr[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return [ZQMyBooingCell myBooingCellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZQNewCarCheckController *vc = [[ZQNewCarCheckController alloc] init];
    vc.orderObj = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)operateBtnAction:(UIButton *)sender
{
    orderStatus = self.currentViewType+1;
    if ([sender.titleLabel.text rangeOfString:@"结束"].location != NSNotFound) {
        orderStatus = 3;
    }
    ZQOrderObject *model = self.dataArr[sender.tag];
    [ZQLocationServer shareInstance].orderNo = model.order_sn;
    __weak typeof(self) weakSelf = self;
//    1 是确认接单 2开始服务 3完成服务
    [JKHttpRequestService POST:@"Appuser/startServers" withParameters:@{@"id":model.ID,@"user_id":[Utility getUserID],@"istype":[NSString stringWithFormat:@"%ld",(long)orderStatus]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
            [strongSelf deleteCellWithIndex:sender.tag];
            [strongSelf startOrStopLoaction];
        }
    } failure:^(NSError *error) {
        
    } animated:YES];

}
- (void)startOrStopLoaction
{
    if (orderStatus==2) {
        [[ZQLocationServer shareInstance] starLoction];
    }
    if (orderStatus==3) {
      [[ZQLocationServer shareInstance] stopLoction];
    }
}
- (void)deleteCellWithIndex:(NSInteger)index
{
    switch (self.currentViewType) {
        case ZQInProcessOrdersView:
        {
            if (orderStatus==3) {
                [self.inProcessList removeObjectAtIndex:index];
                [self deleteReloadArray:_inProcessList noDataStr:@"您暂时还无进行中的订单" rowIndex:index];
                [self.successList removeAllObjects];
            }
            else
            {
                [self.inProcessList removeAllObjects];
                [self segmentAction:_currentViewType];
            }
        }
            break;
        case ZQSucessOrdersView:
        {
            //已完成
            [self.successList removeObjectAtIndex:index];
            [self deleteReloadArray:_successList noDataStr:@"您暂时已完成的订单" rowIndex:index];
        }
            break;
        case ZQToBeConfirmView:
        {
            //待确认
            [self.allOrdersList removeObjectAtIndex:index];
            [self deleteReloadArray:_allOrdersList noDataStr:@"您暂无待确认订单" rowIndex:index];
            [self.inProcessList removeAllObjects];
        }
            break;
        default:
            break;
    }
}
- (void)deleteReloadArray:(NSMutableArray *)mArray noDataStr:(NSString *)str rowIndex:(NSInteger)index
{
    if (_noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
        [self.tableView setHidden:NO];
    }
    else
    {
        if (!mArray.count) {
            [self noDataShowText:str];
        }
    }
    self.dataArr = mArray;
//    if (self.dataArr.count) {
//        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//    }
//    else
//    {
        [self.tableView reloadData];
//    }
}
//删除订单
- (void)endorseBtnAction:(UIButton *)sender
{
//    ZQOrderObject *model = self.dataArr[sender.tag];
    __block NSInteger tempTag = sender.tag;
    NSString *urlStr = [NSString stringWithFormat:@"daf/delete_order/u_id/%@/order_no/%@",[Utility getUserID],@""];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                [strongSelf.dataArr removeObjectAtIndex:tempTag];
                [strongSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tempTag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    } failure:^(NSError *error) {
     
    } animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    if (self.dataArr.count) {
//         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:seletedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        NSLog(@"00000did%@",self.view);
        CGFloat spaceY = (kDevice_Is_iPhoneX ? 88:64);
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,spaceY+36, KWidth, CGRectGetHeight(self.view.frame)-spaceY-36) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MainBgColor;
//        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"11111did%@",self.view);
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
- (void)dealloc
{
    NSLog(@"订单列表页面销毁");
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
