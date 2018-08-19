//
//  ZQLocationServer.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/8/19.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQLocationServer.h"

#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>

static ZQLocationServer *_locationServer;

@interface ZQLocationServer ()<BMKLocationManagerDelegate,BMKLocationAuthDelegate>
{
    BMKLocationManager *_locationManager;
}
@property (nonatomic, strong) NSTimer *locationTimer;

@end

@implementation ZQLocationServer

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationServer = [ZQLocationServer new];
         [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"pdgGMI4Puvu9NiDBarI4jWgNDgGMPbzt" authDelegate:nil];
    });
    return _locationServer;
}

#pragma mark 初始化定位
-(void)initLocation {
    
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的定位功能位开启 请到\"设置 > 隐私 > 位置 > 定位服务\" 开启定位服务" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
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
}
- (void)locationTimerAction
{
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(requestLocation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
}
- (void)requestLocation
{
    __weak typeof(self) weakSelf = self;
    [_locationManager requestLocationWithReGeocode:NO withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            NSLog(@"定位错误:%@",error.description);
        }
        else
        {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf updateLocationToServer:location];
        }
    }];
}
- (void)updateLocationToServer:(BMKLocation *)bLocation {
    //    order_sn
        __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"appuser/location" withParameters:@{@"guide_id":[Utility getUserID],@"order_sn":[ZQLocationServer shareInstance].orderNo,@"longitude":[NSString stringWithFormat:@"%f",bLocation.location.coordinate.longitude],@"latitude":[NSString stringWithFormat:@"%f",bLocation.location.coordinate.latitude]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        
        if ([jsonDic isKindOfClass:[NSDictionary class]]) {
            NSString *msg = jsonDic[@"msg"];
            if ([msg isKindOfClass:[NSString class]]) {
                if (msg.length) {
                    if ([msg rangeOfString:@"结束服务"].length != NSNotFound) {
                        [weakSelf stopLoction];
                    }
                }
            }
        }
                NSLog(@"jsoDic = %@",jsonDic);
        //        __strong typeof(self) strongSelf = weakSelf;
        //        if (succe) {
        //
        //        }
    } failure:^(NSError *error) {
        
    } animated:NO];
}
- (void)starLoction
{
    [self initLocation];
}
- (void)stopLoction
{
    if (_locationTimer) {
        [self.locationTimer invalidate];
        _locationTimer = nil;
    }
}
@end
