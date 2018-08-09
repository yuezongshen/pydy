//
//  ZQInspectionListController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQInspectionListController.h"
#import "ZQInspectionCell.h"

#import "ZQHtmlViewController.h"
#import "ZQAlerInputView.h"
#import "ZQUpSubdataViewController.h"
#import "ZQOnlineSubViewController.h"
#import "ZQOnlineAlertView.h"
#import "ZQSuccessAlerView.h"


//#import <MapKit/MapKit.h>
//#import "NSDictionary+propertyCode.h"
//UISearchControllerDelegate,UISearchResultsUpdating,
@interface ZQInspectionListController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UISearchController *searchController;
}
@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *agencyList;

@property (nonatomic, strong) NSMutableArray *searchListArry;

@property (nonatomic, strong) NSArray *siftArray; //筛选的条件

@property (nonatomic, assign) NSInteger page;
@end

@implementation ZQInspectionListController

@synthesize searchController = _searchController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"检车机构";
    [self addNavigationRightItem];
    
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAgencyListData];
    }];
    [self.tableView.mj_header beginRefreshing];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10)];
    self.tableView.tableFooterView = view;
  
    //创建UISearchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //设置代理
//    self.searchController.delegate= self;
//    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
//    UIImageView *barImageView = [[[self.searchController.searchBar.subviews firstObject] subviews] firstObject];
//    barImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    barImageView.layer.borderWidth = 1;
    
    self.searchController.searchBar.tintColor =  [UIColor darkGrayColor];
    // 改变searchBar背景颜色
    self.searchController.searchBar.barTintColor =  [UIColor whiteColor];
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    // 取消searchBar上下边缘的分割线
    self.searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchController.searchBar.placeholder = @"搜索检测站";
    
    UITextField *searchTextField = (UITextField *)[[[self.searchController.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = [UIColor colorWithRed:182.0/255 green:182.0/255 blue:182.0/255 alpha:0.3];
//
//    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:[UISearchBar class]]
//    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
//    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];


    //位置
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.searchController.searchBar.frame.size.width, 44.0);
//    [_searchController.searchBar sizeToFit];
    
//    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)getAgencyListData
{
    [self.tableView.mj_footer resetNoMoreData];
    self.page = 1;
//    o_product经度  o_range维度
    NSString *urlStr = nil;
    if (self.siftArray) {
//筛选条件
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        urlStr = [NSString stringWithFormat:@"daf/get_car_mechanism/u_id/%@/o_name/%@/province/%@/city/%@/o_product/%f/o_range/%f/p/1",[Utility getUserID],self.siftArray[0],self.siftArray[1],self.siftArray[2],[Utility getLongitude],[Utility getLatitude]];
    }
    else
    {
//        /o_product/%@/o_range/%@/o_name/%@/province/%@/city/%@
        urlStr = [NSString stringWithFormat:@"daf/get_car_mechanism/u_id/%@/o_product/%f/o_range/%f/p/1",[Utility getUserID],[Utility getLongitude],[Utility getLatitude]];
    }
    //检车机构接口
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.agencyList = [ZQInspectionModel mj_objectArrayWithKeyValuesArray:array];
                    }
                    else
                    {
                        [strongSelf.agencyList removeAllObjects];
                    }
                    [strongSelf.tableView reloadData];
                }
            }
        }
        [strongSelf.tableView.mj_header endRefreshing];
        [ZQLoadingView hideProgressHUD];
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf.agencyList removeAllObjects];
            [strongSelf.tableView reloadData];
            [strongSelf.tableView.mj_header endRefreshing];
        }
        [ZQLoadingView hideProgressHUD];
    } animated:NO];
    /*
    __weak __typeof(self) weakSelf = self;
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (weakSelf.agencyList.count) {
            [weakSelf.agencyList removeAllObjects];
//            [weakSelf.agencyList addObject:@{@"image":@"agency",@"name":@"柏乡县宏泰机动车检测有限公司",@"distance":@"2.3km",@"address":@"思明区岭兜北二路401",@"phone":@"13932100437"}];
             [weakSelf.agencyList addObject:@{@"image":@"agency",@"name":@"柏乡县宏泰机动车检测有限公司",@"address":@"柏乡县县城东",@"phone":@"13932100437",@"distance":@"2.3km",@"linkman":@"王小虎",@"isUse":@YES}];
        }
        else
        {
//            weakSelf.agencyList = [NSMutableArray arrayWithObject:@{@"image":@"agency",@"name":@"柏乡县宏泰机动车检测有限公司",@"address":@"柏乡县县城东",@"phone":@"13932100437"}];
            weakSelf.agencyList = [NSMutableArray arrayWithCapacity:0];

        }
        NSDictionary *dic = @{@"image":@"agency",@"name":@"柏乡县宏泰机动车检测有限公司",@"address":@"柏乡县县城东",@"phone":@"13932100437",@"distance":@"2.3km",@"linkman":@"王小虎",@"isUse":@YES};
        [self.agencyList addObject:dic];
        dic = @{@"image":@"agency",@"name":@"霸州市永盛机动车检测有限公司",@"address":@"廊坊市霸州市南孟镇西粉营村",@"phone":@"13831691118",@"distance":@"2.3km",@"linkman":@"王小虎",@"isUse":@NO};
        [self.agencyList addObject:dic];
        dic = @{@"image":@"agency",@"name":@"保定和安汽车检测技术服务有限公司",@"address":@"保定高开区创业路368号",@"phone":@"13588373703",@"distance":@"2.3km",@"linkman":@"王小虎",@"isUse":@NO};
        [self.agencyList addObject:dic];

//        for (int i = 0; i<5; i++) {
//            NSDictionary *dic = @{@"image":@"agency",@"name":@"聚州机动车检站",@"distance":@"2.3km",@"address":@"思明区岭兜北二路401",@"phone":@"0592-5979816\n18120732580"};
//            [self.agencyList addObject:dic];
//        }
//        if (weakSelf.agencyList.count<3) {
//            [tableView.mj_footer endRefreshingWithNoMoreData];
//        }
        [tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
    });
     */
}
- (void)getAgencyListDataWithText:(NSString *)text
{
    //    o_product经度  o_range维度
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_car_mechanism/u_id/%@/o_name/%@/o_product/%f/o_range/%f/p/1",[Utility getUserID],text,[Utility getLongitude],[Utility getLatitude]];
    //检车机构接口
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.agencyList = [ZQInspectionModel mj_objectArrayWithKeyValuesArray:array];
                    }
                    else
                    {
                        [strongSelf.agencyList removeAllObjects];
                    }
                    [strongSelf.tableView reloadData];
                }
            }
        }
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf.agencyList removeAllObjects];
            [strongSelf.tableView reloadData];
            [strongSelf.tableView.mj_header endRefreshing];
        }
    } animated:YES];
}

- (void)loadMoreData
{
     self.page++;
    NSString *urlStr = nil;
    if (self.siftArray) {
        //筛选条件
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        urlStr = [NSString stringWithFormat:@"daf/get_car_mechanism/u_id/%@/o_name/%@/province/%@/city/%@/o_product/%f/o_range/%f/p/%ld",[Utility getUserID],self.siftArray[0],self.siftArray[1],self.siftArray[2],[Utility getLongitude],[Utility getLatitude],(long)self.page];
    }
    else
    {
        //        /o_product/%@/o_range/%@/o_name/%@/province/%@/city/%@
        urlStr = [NSString stringWithFormat:@"daf/get_car_mechanism/u_id/%@/o_product/%f/o_range/%f/p/%ld",[Utility getUserID],[Utility getLongitude],[Utility getLatitude],(long)self.page];
    }
    //检车机构接口
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    NSMutableArray *mArray = nil;
                    if (array.count) {
                        mArray = [ZQInspectionModel mj_objectArrayWithKeyValuesArray:array];
                        [strongSelf.agencyList addObjectsFromArray:mArray];
                    }
//                    [strongSelf.tableView reloadData];
                    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:0];
                    for (int ind = 0; ind < [mArray count]; ind++) {
                        NSIndexPath *newPath =  [NSIndexPath indexPathForRow:[strongSelf.agencyList indexOfObject:[mArray objectAtIndex:ind]] inSection:0];
                        [insertIndexPaths addObject:newPath];
                    }
                    [strongSelf.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                    [strongSelf.tableView.mj_footer setHidden:YES];
                    [strongSelf performSelector:@selector(hideAction) withObject:nil afterDelay:0.6];
                    return ;
                }
            }
        }
         [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    } failure:^(NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf.tableView.mj_footer resetNoMoreData];
        }
    } animated:NO];
    /*
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        NSDictionary *dic = @{@"image":@"agency",@"name":@"聚州机动车检站",@"distance":@"2.3km",@"address":@"思明区岭兜北二路401",@"phone":@"18120732580",@"linkman":@"王小虎"};
        [self.agencyList addObject:dic];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [tableView.mj_footer endRefreshing];
    });
    //            [tableView.mj_footer endRefreshingWithNoMoreData];
*/
}
- (void)hideAction
{
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView.mj_footer setHidden:NO];
}
- (void)addNavigationRightItem
{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnFilterAction)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    return;
    /*
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn setImage:[UIImage imageNamed:@"shouyeyuyue"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(rightBtnFilterAction) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.backgroundColor = [UIColor redColor];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBtnFilterAction)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
     */
}
//右侧筛选按钮
- (void)rightBtnFilterAction
{
    ZQAlerInputView *alerView = [[ZQAlerInputView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    __weak typeof(self) weakSelf = self;
    alerView.handler = ^(NSArray *contenArr)
    {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            strongSelf.siftArray = contenArr;
            [strongSelf getAgencyListData];
        }
    };
    [alerView show];
}
#pragma mark - UITableViewDataSource

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
//{
////    NSLog(@"viewForHeaderInSection--viewForHeaderInSection");
////    UISearchBar *mySearchBar = [[UISearchBar alloc] init];
////    [mySearchBar setShowsCancelButton:YES];
////    mySearchBar.delegate = self;
////    return mySearchBar;
//    return self.searchController.searchBar;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.agencyList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ZQInspectionCell";
    ZQInspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ZQInspectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//        [cell.navigationBtn addTarget:self action:@selector(navigationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.bookingBtn addTarget:self action:@selector(bookingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
//    cell.navigationBtn.tag = indexPath.row;
//    cell.bookingBtn.tag = indexPath.row;
//    cell.inspectionModel = self.agencyList[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZQInspectionCell inspectionCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQInspectionModel *model = nil;
//    if (self.searchController.active) {
//      model = self.searchListArry[indexPath.row];
//    }
//    else
//    {
        model = self.agencyList[indexPath.row];
//    }
//    if (model.type.integerValue == 1) {
//        ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"agency.html" testId:model.o_id andShowBottom:YES];
//        Vc.title = @"检车站详情";
//        Vc.dSubType = self.subType;
//        [self.navigationController pushViewController:Vc animated:YES];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        return;
//    }
    [ZQLoadingView showAlertHUD:@"此机构暂未开通业务敬请期待！" duration:2.0];
}

//导航
- (void)navigationBtnAction:(UIButton *)sender
{
//    ZQInspectionModel *model = self.agencyList[sender.tag];
//    if (model.type.integerValue == 1)
//    {
//        if (!model.o_range || !model.o_product) {
//          [ZQLoadingView showAlertHUD:@"此机构暂没有位置数据!" duration:SXLoadingTime];
//            return;
//        }
//        if (![Utility getLatitude]) {
//            [ZQLoadingView showAlertHUD:@"没有当前位置数据!" duration:SXLoadingTime];
//            return;
//        }
//        GPSNaviViewController *nav = [[GPSNaviViewController alloc] init];
//
//        nav.startPoint = [AMapNaviPoint locationWithLatitude:[Utility getLatitude] longitude:[Utility getLongitude]];
//        nav.endPoint = [AMapNaviPoint locationWithLatitude:model.o_range.doubleValue longitude:model.o_product.doubleValue];
//        [self.navigationController pushViewController:nav animated:YES];
//        return;
//    }
    [ZQLoadingView showAlertHUD:@"此机构暂未开通业务敬请期待!" duration:SXLoadingTime];

//    nav.startPoint = [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
//    nav.endPoint = [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.321257];;


    /*
    ZQInspectionModel *model = nil;
//    if (self.searchController.active) {
//        model = self.searchListArry[sender.tag];
//    }
//    else
//    {
        model = self.agencyList[sender.tag];
//    }
    if (model.type.integerValue == 1)
    {
        NSArray *array = @[@"百度地图",@"高德地图",@"取消"];
        [Utility showActionSheetWithTitle:@"选择地图" contentArray:array controller:self chooseBlock:^(NSInteger index) {
            if (index == 0) {
                [Utility baiDuMapWithLongitude:model.o_product.doubleValue latitude:model.o_range.doubleValue];
            }else if(index == 1){
                [Utility gaoDeMapWithLongitude:model.o_product.doubleValue latitude:model.o_range.doubleValue];
            }
        }];
        return;
    }
    [ZQLoadingView showAlertHUD:@"此机构暂未开通业务敬请期待！" duration:2.0];
//    [Utility baiDuMap:nil];
     */
}
//立即预约
- (void)bookingBtnAction:(UIButton *)sender
{
    ZQInspectionModel *model = nil;
//    if (self.searchController.active) {
//        model = self.searchListArry[sender.tag];
//    }
//    else
//    {
        model = self.agencyList[sender.tag];
//    }
//    if (model.type.integerValue != 1)
//    {
//        [ZQLoadingView showAlertHUD:@"此机构暂未开通业务敬请期待！" duration:2.0];
//        return;
//    }
    switch (self.subType) {
            case ZQSubScTypeCellPhone:{
                [Utility phoneCallAction];
            }
            break;
            
            case ZQSubScTypeVisit:{
//                [self showSubView];
//                NSString *htmlStr = @"reservationNotice2.html";
////                if (![UdStorage isAgreeReservationNoticeForKey:htmlStr]) {
//                    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr testId:model.o_id andShowBottom:3];
               
//                ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.6" testId:model.o_id andShowBottom:3];
//                    Vc.title = @"机动车上门接送检车须知";
//                if ([Utility getIs_vip]) {
//                    Vc.charge = [Utility getDoorToDoorOutlay_VIP].floatValue;
//                }
//                else
//                {
//                    Vc.charge = [Utility getDoorToDoorOutlay].floatValue;
//                }
//                    Vc.classString = NSStringFromClass([ZQUpSubdataViewController class]);
//                Vc.dSubType = self.subType;
//                    [self.navigationController pushViewController:Vc animated:YES];
                    return;
//                }
//                ZQUpSubdataViewController *subVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
//                subVC.serviceCharge = 150.0;
//                [subVC setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:subVC animated:YES];

            }
            break;
        case ZQSubScTypeDefailt:
        {
//            NSString *htmlStr = @"reservationNotice3.html";
//            if ([UdStorage isAgreeReservationNoticeForKey:htmlStr]) {
//                ZQUpSubdataViewController *subVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
//                [self.navigationController pushViewController:subVC animated:YES];
//            }
//            else
//            {
//                ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr testId:model.o_id andShowBottom:3];
//            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.2" testId:model.o_id andShowBottom:3];
//                Vc.title = @"预约须知";
//                Vc.classString = NSStringFromClass([ZQUpSubdataViewController class]);
//                 Vc.dSubType = self.subType;
//                [self.navigationController pushViewController:Vc animated:YES];
//            }
            break;
        }
        case ZQSubScTypeNone:
        {
            ZQOnlineSubViewController *vc = [[ZQOnlineSubViewController alloc] initWithNibName:@"ZQOnlineSubViewController" bundle:nil];
            vc.pageType = 1;
//            vc.o_testing_id = model.o_id;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:{}
            break;
    }
//    ZQUpSubdataViewController *subVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
//    [self.navigationController pushViewController:subVC animated:YES];
}

/*
-(void)showSubView {
    ZQOnlineAlertView *alerView = [[ZQOnlineAlertView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alerView.handler = ^(NSArray *contenArr)
    {
        [contenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"上门接送车提交内容:%@",obj);
        }];
        //                    [ZQLoadingView makeSuccessfulHudWithTips:@"上传完成" parentView:nil];
        
        [ZQSuccessAlerView showCommitSuccess];
    };
    [alerView show];
}
*/
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
        tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf1/255.0 blue:0xf4/255.0 alpha:1.0];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView = tableView;
    }
    return _tableView;
}

//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    //    //修改"Cancle"退出字眼,这样修改,按钮一开始就直接出现,而不是搜索的时候再出现
    //    searchController.searchBar.showsCancelButton = YES;
    //    for(id sousuo in [searchController.searchBar subviews])
    //    {
    //
    //        for (id zz in [sousuo subviews])
    //        {
    //
    //            if([zz isKindOfClass:[UIButton class]]){
    //                UIButton *btn = (UIButton *)zz;
    //                [btn setTitle:@"搜索" forState:UIControlStateNormal];
    //                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //            }
    //
    //
    //        }
    //    }
    
//    NSLog(@"updateSearchResultsForSearchController");
//    NSString *searchString = [self.searchController.searchBar text];
//    [self getAgencyListDataWithText:searchString];
//    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
//    if (self.searchListArry!= nil) {
//        [self.searchListArry removeAllObjects];
//    }
    //过滤数据
//    self.searchListArry= [NSMutableArray arrayWithArray:[self.dataListArry filteredArrayUsingPredicate:preicate]];
    //刷新表格
//    [self.tableView reloadData];
}
#pragma mark - UISearchControllerDelegate代理,可以省略,主要是为了验证打印的顺序
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
//    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
//    NSLog(@"didPresentSearchController");
//#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    //    [self.view addSubview:self.searchController.searchBar];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
//    NSLog(@"willDismissSearchController");
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
//    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
//    NSLog(@"presentSearchController");
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    return YES;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getAgencyListDataWithText:searchBar.text];
}
/*
- (void)addDestinationTableView
{
    if (self.tableView == nil) {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height;
        UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, width, 20)];
        sView.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf1/255.0 blue:0xf4/255.0 alpha:1.0];
        [self.view addSubview:sView];
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        searchBar.placeholder = @"输入目的地";
        searchBar.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf1/255.0 blue:0xf4/255.0 alpha:1.0];
        searchBar.tintColor = kHWColorHaiwanMain;
        [self.view addSubview:searchBar];
        
        for (UIView *view in searchBar.subviews) {
            for (UIView *bbView in view.subviews) {
                if ([NSStringFromClass([bbView class]) isEqualToString:@"UISearchBarBackground"]) {
                    [bbView removeFromSuperview];
                    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, width, .5)];
                    lineV.backgroundColor = kHWColorLineGray;
                    [searchBar addSubview:lineV];
                    break;
                }
            }
        }
        
        
        
        searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        searchDisplayController.delegate = self;
        searchDisplayController.searchResultsDataSource = self;
        searchDisplayController.searchResultsDelegate = self;
    }
}
*/

//-(void)back{
//    UIViewController *htmlVc = self.navigationController.viewControllers[1];
//    if ([htmlVc isKindOfClass:[ZQHtmlViewController class]]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
