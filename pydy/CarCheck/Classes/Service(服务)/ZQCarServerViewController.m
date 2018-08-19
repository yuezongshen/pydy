//
//  ZQCarServerViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQCarServerViewController.h"
#import "pydy/pydy.h"

#import "ZQServerViewCell.h"
#import "ZQAppointmentHeaderView.h"

#import "ZQHtmlViewController.h"
#import "ZQInspectionListController.h"

#import "ZQOnlineSubViewController.h"
//#import "ZQRechargeViewController.h"

#import "ZQInsuranceView.h"
#import "ZQInsuranceVController.h"
#import "ZQLoadingView.h"
#import "ZQSuccessAlerView.h"

#import "BaseNavigationController.h"
#import "ZQLoginViewController.h"

//#import "ZQBannerModel.h"
#import "PBHomeHeadView.h"
#import "PBHeaderViewCell.h"

#import "UIViewController+MMDrawerController.h"
#import "ZQMessageViewController.h"

#import "ZQOrderObject.h"
#import "ZQMyOrderViewController.h"
#import "ZQNewMyViewController.h"

#import "ZQNewCarCheckController.h"
#import "ZQNoDataView.h"
#import "PPBadgeView.h"


//#import <BMKLocationkit/BMKLocationComponent.h>
//#import <BMKLocationKit/BMKLocationAuth.h>

@interface ZQCarServerViewController()<UICollectionViewDelegate,UICollectionViewDataSource>{
//    BMKLocationManager *_locationManager;
}

//@property (nonatomic, strong) NSTimer *locationTimer;

@property (strong, nonatomic) ZQHeaderViewScoll *aheadView;
@property (strong, nonatomic) UICollectionView *mainView;
@property (strong, nonatomic) UIButton *bottomBtn;
@property (strong, nonatomic) UIButton *acceptOrderBtn;

@property (strong, nonatomic) NSMutableArray *bannerArray;

@property (strong, nonatomic) NSArray *listArray;

@property (strong, nonatomic) UIView *redPV;

@property (strong, nonatomic) ZQNoDataView *noDataView;

@property (strong, nonatomic) UIImageView *bgImageV;

@property (assign, nonatomic)  BOOL isOnline;
@end

@implementation ZQCarServerViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.redPV setHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationItem.rightBarButtonItem pp_addDotWithColor:__TestRedColor];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.redPV setHidden:YES];
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"center_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(centerAction)];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(messageAction)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
//    UIView *redPV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-16, 5, 6, 6)];
//    redPV.backgroundColor = __TestRedColor;
//    redPV.layer.cornerRadius = 3;
//    [self.navigationController.navigationBar addSubview:redPV];
//    self.redPV = redPV;
    
    [self initViews];
    if ([Utility isLogin]) {
        [self loginSuccessGetData];
    }
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessGetData) name:ZQdidLoginNotication object:nil];
    
    self.bgImageV = [[UIImageView alloc] initWithFrame:self.navigationController.view.bounds];
    self.bgImageV.image = [UIImage imageNamed:@"info_bg"];
    [self.navigationController.view addSubview:self.bgImageV];
    
    [self.bgImageV performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
    
//    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"kFkO0joDr0ppZcBUiNdX9Fu26fmEoK7h" authDelegate:self];

}
#pragma mark 初始化定位
/*
-(void)initLocation {
    
        if(![CLLocationManager locationServicesEnabled]){
    //        NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的定位功能位开启 请到\"设置 > 隐私 > 位置 > 定位服务\" 开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            if (_locationTimer) {
                [self.locationTimer invalidate];
                _locationTimer = nil;
            }
            return;
        }
    
    if (!_locationManager) {
        //初始化实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        _locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 10;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 10;
    }
    
    if (!_locationTimer) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(locationTimerAction) object:nil];
        [thread start];
    }
//    locationManager=[[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置定位精度
//    locationManager.distanceFilter = kCLErrorDeferredDistanceFiltered;
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//        [locationManager requestWhenInUseAuthorization];
//    }
//    if(![CLLocationManager locationServicesEnabled]){
////        NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的定位功能位开启 请到\"设置 > 隐私 > 位置 > 定位服务\" 开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }]];
//        [self presentViewController:alert animated:YES completion:nil];
//        return;
//    }
//    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [locationManager requestAlwaysAuthorization]; // 永久授权
//        [locationManager requestWhenInUseAuthorization]; //使用中授权
//    }
//    if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
//        [locationManager setAllowsBackgroundLocationUpdates:YES];
//    }
//    locationManager.pausesLocationUpdatesAutomatically = NO;
//    [locationManager startUpdatingLocation];
    //[locationManager startMonitoringSignificantLocationChanges];
    
    
    
}
- (void)locationTimerAction
{
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(requestLocation) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:_locationTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

- (void)requestLocation
{
    if ([Utility isLogin]) {
        __weak typeof(self) weakSelf = self;
        [_locationManager requestLocationWithReGeocode:NO withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            if (error) {
                NSLog(@"定位错误:%@",error.description);
            }
            else
            {
//            NSLog(@"位置信息:%f,%f",location.location.coordinate.latitude,location.location.coordinate.longitude);

                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf updateLocationToServer:location];
            }
        }];
    }
    else
    {
        [self.locationTimer invalidate];
        self.locationTimer = nil;
        _locationTimer = nil;
    }
}
 */
- (void)loginSuccessGetData
{
    [self getBannerData];
}
- (void)getBannerData
{
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/guideIndex" withParameters:@{@"id":[Utility getUserID]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"][@"info"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.listArray = [ZQOrderObject mj_objectArrayWithKeyValuesArray:array];
                        [strongSelf.mainView reloadData];
                        [strongSelf hiddenNoDataView];
                    }
                    else
                    {
                        [strongSelf noDataShowText:@"暂无数据"];
                    }
                }
                NSDictionary *headerDic = jsonDic[@"data"][@"count"];
                if (_aheadView) {
                    [strongSelf.aheadView configHeaderViewWithDic:headerDic];
                }
                strongSelf.isOnline = [headerDic[@"is_online"] boolValue];
                [strongSelf isShowOnlineView:strongSelf.isOnline];
                ZQNewMyViewController *newMyVc = (ZQNewMyViewController *)strongSelf.mm_drawerController.leftDrawerViewController;
                [newMyVc setMyHeaderView:headerDic];
            }
        }
        else
        {
            [strongSelf noDataShowText:@"点击重新加载"];
            if (_aheadView) {
                [strongSelf.aheadView configHeaderViewWithDic:nil];
            }
            [strongSelf isShowOnlineView:0];
            ZQNewMyViewController *newMyVc = (ZQNewMyViewController *)strongSelf.mm_drawerController.leftDrawerViewController;
            [newMyVc setMyHeaderView:nil];
        }
        [strongSelf.mainView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf noDataShowText:@"点击重新加载"];
        [strongSelf.mainView.mj_header endRefreshing];
    } animated:YES];
    
}

- (void)initViews {
    
    ZQHeaderViewScoll *headView = [[ZQHeaderViewScoll alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX ?88:64, CGRectGetWidth(self.view.frame), 200)];
    self.aheadView = headView;
    headView.headerBtnAction = ^(NSInteger btnIndex) {
        ZQMyOrderViewController *myOrderVc = [[ZQMyOrderViewController alloc] initWithOrderViewType:(ZQOrderViewType)btnIndex];
        [self.navigationController pushViewController:myOrderVc animated:YES];
    };

    [self.view addSubview:headView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-CGRectGetMaxY(headView.frame)-50) collectionViewLayout:flowLayout];
    self.mainView.backgroundColor = MainBgColor;
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:self.mainView];
    __weak __typeof(self) weakSelf = self;
    self.mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getBannerData];
    }];
    // 注册
    [self.mainView registerClass:[PBHeaderViewCell class] forCellWithReuseIdentifier:@"PBHeaderViewCell"];

//    [self.mainView registerClass:[ZQHeaderViewScoll class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScrollPageView"];
    
     [self.mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewHeader"];
    [self.mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewFooter"];
    
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.view.frame), 50)];
    startView.backgroundColor = __HeaderBgColor;
    [self.view addSubview:startView];
    
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(70,8, CGRectGetWidth(startView.frame)-140, 34)];
    _putBtn.titleLabel.font = MFont(18);
    [_putBtn addTarget:self action:@selector(receiveOrdersAction) forControlEvents:BtnTouchUpInside];
    [startView addSubview:_putBtn];
    self.bottomBtn = _putBtn;
    
//    UIButton * acceptBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_putBtn.frame)+5,8, CGRectGetMinX(_putBtn.frame)-10, 34)];
//    acceptBtn.titleLabel.font = MFont(12);
//    [acceptBtn setTitleColor:__TestGColor forState:BtnNormal];
//    [acceptBtn addTarget:self action:@selector(receiveOrdersAction) forControlEvents:BtnTouchUpInside];
//    [startView addSubview:acceptBtn];
//    self.acceptOrderBtn = acceptBtn;
    [self isShowOnlineView:NO];
}
- (void)isShowOnlineView:(BOOL)isOnline
{
    if (isOnline) {
//        [self.bottomBtn setTitle:@"开始接单" forState:BtnNormal];
        [self.bottomBtn setTitle:@"接单中" forState:BtnNormal];
        self.bottomBtn.backgroundColor = __MoneyColor;
        [self.bottomBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
//        [self.acceptOrderBtn setTitle:@"我要休息" forState:UIControlStateNormal];
//        [self initLocation];
    }
    else
    {
        [self.bottomBtn setTitle:@"休息中" forState:BtnNormal];
        self.bottomBtn.backgroundColor = [UIColor whiteColor];
        [self.bottomBtn setTitleColor:__HeaderBgColor forState:BtnNormal];
//        [self.acceptOrderBtn setTitle:@"我要接单" forState:UIControlStateNormal];
//        if (_locationTimer) {
//            [self.locationTimer invalidate];
//            _locationTimer = nil;
//        }
    }
}
- (void)acceptBtnAction
{
    if (self.isOnline) {
        [ZQLoadingView showAlertHUD:@"您现在可以开始接单了" duration:SXLoadingTime];
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"您现在正在休息中" duration:SXLoadingTime];
    }
}
- (void)receiveOrdersAction
{
//    0休息 1工作
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/isOnline" withParameters:@{@"id":[Utility getUserID],@"istype":@(!_isOnline)} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                strongSelf.isOnline = !strongSelf.isOnline;
                [strongSelf isShowOnlineView:strongSelf.isOnline];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}

- (BOOL)userIsLogin
{
    if ([Utility isLogin])
    {
        return YES;
    }
    else
    {
        ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
        BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:loginNa animated:YES completion:^{
            
        }];
        return NO;
    }
}
#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.listArray.count;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PBHeaderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PBHeaderViewCell" forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.reloadHomeV = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf getBannerData];
    };
    if (cell == nil) {
        cell = [[PBHeaderViewCell alloc] init];
    }
    [cell setOrderObj:self.listArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZQNewCarCheckController *vc = [[ZQNewCarCheckController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.orderObj = self.listArray[indexPath.row];
}

#pragma mark headerAndFooter
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reuseV = nil;
    if (kind == UICollectionElementKindSectionHeader) {
//        ZQHeaderViewScoll *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScrollPageView" forIndexPath:indexPath];
//        self.aheadView = headView;
//        headView.headerBtnAction = ^(NSInteger btnIndex) {
//            ZQMyOrderViewController *myOrderVc = [[ZQMyOrderViewController alloc] initWithOrderViewType:(ZQOrderViewType)btnIndex];
//            [self.navigationController pushViewController:myOrderVc animated:YES];
//        };
//        reuseV = headView;
        
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewHeader" forIndexPath:indexPath];
        reuseV.backgroundColor = MainBgColor;
        reuseV = headView;
    }else {
        UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewFooter" forIndexPath:indexPath];
        reuseV.backgroundColor = MainBgColor;
        reuseV = headView;
    }
    return reuseV;
    
}

#pragma mark flowlayout
//x 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//y 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(10, 0, 0, 0);
//}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(__kWidth, 126);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
   
//    return CGSizeMake(__kWidth, 200);
    return CGSizeZero;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(__kWidth, 20);
}
/*
- (void)updateLocationToServer:(BMKLocation *)bLocation {
//    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"appuser/location" withParameters:@{@"guide_id":[Utility getUserID],@"longitude":[NSString stringWithFormat:@"%f",bLocation.location.coordinate.longitude],@"latitude":[NSString stringWithFormat:@"%f",bLocation.location.coordinate.latitude]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        NSLog(@"jsoDic = %@",jsonDic[@"msg"]);
//        __strong typeof(self) strongSelf = weakSelf;
//        if (succe) {
//
//        }
    } failure:^(NSError *error) {
        
    } animated:NO];
}
*/
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)hiddenNoDataView
{
    if (_noDataView) {
        [self.noDataView removeFromSuperview];
        self.noDataView = nil;
        [self.mainView setHidden:NO];
    }
}
- (void)noDataShowText:(NSString *)str
{
    [self.mainView setHidden:YES];
    [self.view addSubview:self.noDataView];
//    self.noDataView.noOrderLabel.text = str;
}
- (ZQNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[ZQNoDataView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _noDataView.noOrderImgV.image = [UIImage imageNamed:@"noData_bg"];
        _noDataView.center = self.mainView.center;
        __weak typeof(self) weakSelf = self;
        _noDataView.reloadPageAction = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf getBannerData];
            }
        };
    }
    return _noDataView;
}
- (void)centerAction
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}
- (void)messageAction
{
    ZQMessageViewController *messageVC = [[ZQMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}
@end
