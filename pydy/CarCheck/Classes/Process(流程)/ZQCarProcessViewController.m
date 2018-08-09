//
//  ZQCarProcessViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQCarProcessViewController.h"
#import "ZQProcessCell.h"
#import "ZQProcessRightCell.h"
#import "ZQViolationViewController.h"
#import "ZQPayVioViewController.h"
#import "ZQSubTimeViewController.h"
//#import "ZQProblemViewController.h"
#import "ZQHtmlViewController.h"
#import "ZQOnlineAlertView.h"
#import "ZQSuccessAlerView.h"
#import "ZQInspectionListController.h"

#import "ZQUpVioViewController.h"

#import "BaseNavigationController.h"

#import "ZQUpSubdataViewController.h"

#import "ZQNewCarCheckController.h" //新车

#import "ZQLoginViewController.h"

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "ZQHtmlViewController.h"

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

@interface ZQCarProcessViewController()<UITableViewDelegate,UITableViewDataSource,ZQProcessRightCellDelegate,ZQProcessCellDelegate,AMapLocationManagerDelegate>{
    
    NSMutableArray *_dataArray;
    NSMutableArray *_colorArray;
    NSMutableArray *_stepArray;
    
}

@property(strong,nonatomic)UITableView *tableView;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end

@implementation ZQCarProcessViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initViews];
    
    [AMapServices sharedServices].apiKey = @"38213c630c734efe09f2259bd241cfd2";

    [self initCompleteBlock];
    
    [self configLocationManager];
    
    [self locAction];
}
#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许在后台定位
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    
    //设置逆地理超时时间
    //    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)cleanUpAction
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
}

//- (void)reGeocodeAction
//{
//    //进行单次带逆地理定位请求
//    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
//}

- (void)locAction
{
    //进行单次定位请求
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}
#pragma mark - Initialization

- (void)initCompleteBlock
{
    //    __weak ZQInspectionListController *weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error != nil && error.code == AMapLocationErrorLocateFailed)
        {
            //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else if (error != nil
                 && (error.code == AMapLocationErrorReGeocodeFailed
                     || error.code == AMapLocationErrorTimeOut
                     || error.code == AMapLocationErrorCannotFindHost
                     || error.code == AMapLocationErrorBadURL
                     || error.code == AMapLocationErrorNotConnectedToInternet
                     || error.code == AMapLocationErrorCannotConnectToHost))
        {
            //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
            NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
        {
            //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
            NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
            return;
        }
        else
        {
            //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
        }
        
        //修改label显示内容
        if (regeocode)
        {
            NSLog(@"定位显示的内容:%@",[NSString stringWithFormat:@"%@ \n %@-%@-%.2fm", regeocode.formattedAddress,regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]);
        }
        else
        {
            NSLog(@"定位成功经纬度内容:%@",[NSString stringWithFormat:@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy]);
            [Utility saveLongitude:location.coordinate.longitude Latitude:location.coordinate.latitude];
        }
    };
}

#pragma mark -AMapLocationManagerDelegate-
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败:error:%@",[error description]);
}
#pragma mark 私有方法
-(void)initViews {
    
    [self getData];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10)];
    headV.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headV;
    // 注册
    [self.tableView registerClass:[ZQProcessCell class] forCellReuseIdentifier:@"ZQProcessCell"];
    [self.tableView registerClass:[ZQProcessRightCell class] forCellReuseIdentifier:@"ZQProcessRightCell"];
    
    // 背景图
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"process.png"]];
    imgView.frame = CGRectMake(0, 0, KWidth, KHeight - 84 - 44);
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.tableView setBackgroundView:imgView];
}

-(void)getData {
    
//    _dataArray = [NSMutableArray arrayWithObjects:@[@"违章查询"],@[@"代缴违章罚款"],@[@"检车预约",@"上门接送检车",@"电话预约检车"],@[@"常见问题"],@[@"平台介绍"], nil];
//    _dataArray = [NSMutableArray arrayWithObjects:@[@"违章查询"],@[@"代缴违章罚款"],@[@"机动车在线预约检车",@"上门接送预约检车",@"电话预约检车",@"新车免检预约服务"],@[@"常见问题"],@[@"平台介绍"], nil];
    
    _dataArray = [NSMutableArray arrayWithObjects:@[@"违章查询"],@[@"代缴违章罚款"],@[@"在线预约检车",@"上门接送检车",@"电话预约检车",@"新车免检服务"],@[@"常见问题"],@[@"平台介绍"], nil];

    
//    _stepArray = [NSMutableArray arrayWithObjects:@"一",@"二",@"三",@"四",@"五", nil];
    _stepArray = [NSMutableArray arrayWithObjects:@"第一步",@"第二步",@"第三步",@"第四部",@"了解", nil];

    _colorArray = [NSMutableArray array];
    [_colorArray addObject:[UIColor colorWithRed:4/255.0 green:139/255.0 blue:254/255.0 alpha:1]];
    [_colorArray addObject:[UIColor colorWithRed:143/255.0 green:130/255.0 blue:188/255.0 alpha:1]];
    [_colorArray addObject:[UIColor colorWithRed:18/255.0 green:180/255.0 blue:177/255.0 alpha:1]];
    [_colorArray addObject:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1]];
    [_colorArray addObject:[UIColor colorWithRed:228/255.0 green:1/255.0 blue:127/255.0 alpha:1]];
    
}

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
#pragma mark 共有方法

#pragma mark ZQProcessCellDelegate
-(void)selectAtRow:(NSInteger)row index:(NSInteger)index {
    NSLog(@"ZQProcessCellDelegate row=%ld index = %ld",(long)row,(long)index);
    switch (row) {
        case 0:{
//            违章查询
//            ZQViolationViewController *vc = [[ZQViolationViewController alloc] initWithNibName:@"ZQViolationViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
            ZQHtmlViewController *htmlVc = [[ZQHtmlViewController alloc] initWithUrlString:@"http://m.hbgajg.com/?from=singlemessage&isappinstalled=0" andShowBottom:NO];
            [htmlVc hidesBottomBarWhenPushed];
            htmlVc.title = @"违章查询";
            [self.navigationController pushViewController:htmlVc animated:YES];
//
        }
            break;
        case 2:{
            switch (index) {
                case 0:
                {
                    if ([self userIsLogin]) {
                        //机动车在线预约检车
                        ZQSubScType type = ZQSubScTypeDefailt;
                        //                    NSString *htmlStr = @"reservationNotice3.html";
                        //                    if ([UdStorage isAgreeReservationNoticeForKey:htmlStr]) {
                        ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
                        inspectionVC.subType = type;
                        [inspectionVC setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:inspectionVC animated:YES];
                        //                    }
                        //                    else
                        //                    {
                        //                        ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr andShowBottom:3];
                        //                        Vc.title = @"预约须知";
                        //                        Vc.classString = NSStringFromClass([ZQInspectionListController class]);
                        //                        [Vc setHidesBottomBarWhenPushed:YES];
                        //                        [self.navigationController pushViewController:Vc animated:YES];
                        //                    }
                    }
                }
                    break;
                case 1:
                {
                    if ([self userIsLogin]) {
                        ZQSubScType type = ZQSubScTypeVisit;
                        ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
                        inspectionVC.subType = type;
                        [inspectionVC setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:inspectionVC animated:YES];
                        
                        
                        //                    NSString *htmlStr = @"reservationNotice2.html";
                        //                    if (![UdStorage isAgreeReservationNoticeForKey:htmlStr]) {
                        //                        ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr andShowBottom:3];
                        //                        Vc.title = @"机动车上门接送检车须知";
                        //                        Vc.classString = NSStringFromClass([ZQUpSubdataViewController class]);
                        //                        [Vc setHidesBottomBarWhenPushed:YES];
                        //                        [self.navigationController pushViewController:Vc animated:YES];
                        //                        return;
                        //                    }
                        //                    ZQUpSubdataViewController *subVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
                        //                    subVC.serviceCharge = 150.0;
                        //                    [subVC setHidesBottomBarWhenPushed:YES];
                        //                    [self.navigationController pushViewController:subVC animated:YES];
                    }
                    return;
                }
                    break;
                case 2:
                {
//                    type = ZQSubScTypeCellPhone;
                    [Utility phoneCallAction];
                    return;
                }
                    break;
                case 3:
                {
                    if ([self userIsLogin]) {
                        NSString *htmlStr = @"NewCarNotice.html";
                        //                    if ([UdStorage isAgreeReservationNoticeForKey:htmlStr]) {
                        //                        ZQNewCarCheckController *newCarVC = [[ZQNewCarCheckController alloc] init];
                        //                        [newCarVC setHidesBottomBarWhenPushed:YES];
                        //                        [self.navigationController pushViewController:newCarVC animated:YES];
                        //                    }
                        //                    else
                        //                    {
//                        ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr andShowBottom:3];
                         ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.5" andShowBottom:3];
                        Vc.title = @"新车免检预约服务须知";
                        Vc.classString = NSStringFromClass([ZQNewCarCheckController class]);
                        [Vc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:Vc animated:YES];
                        //                    }
                    }
                    return;
                }
                    break;
                default:
                    break;
            }
//
//            ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
//            inspectionVC.subType = type;
//            [self.navigationController pushViewController:inspectionVC animated:YES];
        }
            break;
        case 4:{
//            ZQProblemViewController *subVC = [[ZQProblemViewController alloc] init];
//            [self.navigationController pushViewController:subVC animated:YES];
            
//            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"platformIntroduction.html" andShowBottom:NO];
            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.3" andShowBottom:NO];
            Vc.title = @"平台介绍";
            [Vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:Vc animated:YES];
        }
            
            break;
            
        default:
            break;
    }
    
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
#pragma mark ZQProcessRightCellDelegate
-(void)selectRightAtRow:(NSInteger)row index:(NSInteger)index {
    NSLog(@"ZQProcessRightCellDelegate row=%ld index = %ld",(long)row,(long)index);
    switch (row) {
        case 1:{
            if ([self userIsLogin]) {
                //            ZQPayVioViewController *vc = [[ZQPayVioViewController alloc] initWithNibName:@"ZQPayVioViewController" bundle:nil];
                //            [self.navigationController pushViewController:vc animated:YES];
                ZQUpVioViewController *vc = [[ZQUpVioViewController alloc] init];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3:{
//            ZQProblemViewController *subVC = [[ZQProblemViewController alloc] init];
//            [self.navigationController pushViewController:subVC animated:YES];
//            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"questions.html" andShowBottom:NO];
             ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.4" andShowBottom:NO];
            Vc.title = @"常见问题";
            [Vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:Vc animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row % 2 == 0) {
        ZQProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQProcessCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ZQProcessCell alloc] init];
        }
        cell.delegate = self;
        [cell writeDataWithArray:_dataArray[indexPath.row] color:_colorArray[indexPath.row] title:_stepArray[indexPath.row]];
        return cell;
    }else{
        
        ZQProcessRightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQProcessRightCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (cell == nil) {
            cell = [[ZQProcessRightCell alloc] init];
        }
        [cell writeDataWithArray:_dataArray[indexPath.row] color:_colorArray[indexPath.row] title:_stepArray[indexPath.row]];
        cell.dataArray = _dataArray[indexPath.row];
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *tmpArray = _dataArray[indexPath.row];
//    return 35 * (2 + tmpArray.count) + 5 * (tmpArray.count - 1);
    if (__kWidth>320) {
        if (__kWidth>375) {
            return 40 * tmpArray.count+50;
        }
        return 40 * tmpArray.count+40;
    }
    return 40 * tmpArray.count+20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
