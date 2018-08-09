//
//  ZQHtmlViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQHtmlViewController.h"
#import <MapKit/MapKit.h>
#import <WebKit/WebKit.h>
#import "ZQOnlineSubViewController.h"
#import "ZQUpSubdataViewController.h"


@interface ZQHtmlViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    CGFloat bottomHeight;
    BOOL isAgree;
}
@property (nonatomic, copy)  NSString *urlString;
@property (strong,nonatomic) UIProgressView *progressV;
@property (strong,nonatomic) WKWebView *webView;
@property (assign,nonatomic) NSInteger isShow;

@property (nonatomic, copy) NSString *testing_id; //检测机构id

@end

@implementation ZQHtmlViewController

- (id)initWithUrlString:(NSString *)urlString andShowBottom:(NSInteger)isShow
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.isShow = isShow;
    }
    return self;
}
- (id)initWithUrlString:(NSString *)urlString testId:(NSString *)t_id andShowBottom:(NSInteger)isShow
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.isShow = isShow;
        self.testing_id = t_id;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect rect = self.view.bounds;
    
    //展示底部
    if (_isShow) {
        bottomHeight = 44;
        rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds)-bottomHeight-64);
        [self addBottomBtn];
    }
    else
    {
        rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds)-64);
    }
    [self.webView setFrame:rect];
    [self.view addSubview:self.webView];
    if ([_urlString hasPrefix:@"https://"])
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    }
    else
    {
        if ([_urlString hasPrefix:@"http://"])
        {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
        }
        else
        {
            if ([_urlString hasPrefix:@"agency"]) {
                [self requestInstitutionDetailData];
            }
            else
            {
                if ([_urlString hasPrefix:@"notice"]) {
                    [self requestNoticeDetailData];
                }
                else{
                    NSString *mainBundleDirectory = [[NSBundle mainBundle] bundlePath];
                    NSString *path = [mainBundleDirectory stringByAppendingPathComponent:_urlString];
                    NSURL *url = [NSURL fileURLWithPath:path];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    [self.webView loadRequest:request];
                }
            }
        }
    }
    [self.progressV setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 5)];
    [self.view addSubview:self.progressV];
    [self.view bringSubviewToFront:_progressV];
}
- (void)requestInstitutionDetailData
{
    //机构详情接口
//    NSString *urlStr = [NSString stringWithFormat:@"daf/get_car_mechanism_text/o_id/%@",self.testing_id];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"api/index/xiangqing" withParameters:@{@"infoid":self.testing_id} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSString *jsonStr = jsonDic[@"res"];
                if ([jsonStr isKindOfClass:[NSString class]]) {
                    [strongSelf.webView loadHTMLString:jsonStr baseURL:nil];
                }
            }
        }
    } failure:^(NSError *error) {
    } animated:NO];
}
- (void)requestNoticeDetailData
{
    //机构详情接口http://localhost/Myjob/chejian/index.php/api/base/websitenotes/id/8
    NSString *noticeId = [[self.urlString componentsSeparatedByString:@"."] lastObject];
    NSString *urlStr = [NSString stringWithFormat:@"base/websitenotes/id/%@",noticeId];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSString *jsonStr = jsonDic[@"list"][@"content"];
                if ([jsonStr isKindOfClass:[NSString class]]) {
                    NSString *htmlStr = [NSString stringWithFormat:@"<!DOCTYPE html>\n<html>\n<head>\n<meta name=\"viewport\"content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no\"/>\n<meta http-equiv=\"Content-Type\" content=\"texthtml; charset=UTF-8\"/>\n<style>body{\n\t max-width: 100%% !important; \n\theight: auto;\n\tfont-family:\"San Francisco\",sans-serif !important; font-size: 18px !important;\n}\n</style>\n</head>\n<body>\n\n%@</body>\n</html>", jsonStr];
                    [strongSelf.webView loadHTMLString:htmlStr baseURL:nil];
                    return ;
                }
            }
        }
        NSString *mesStr = jsonDic[@"message"];
        if ([mesStr isKindOfClass:[NSString class]]) {
            if (mesStr.length) {
                [ZQLoadingView showAlertHUD:mesStr duration:SXLoadingTime];
                return;
            }
        }
        [ZQLoadingView showAlertHUD:@"请求失败" duration:SXLoadingTime];
    } failure:^(NSError *error) {
    } animated:NO];
}
- (void)addBottomBtn
{
    switch (_isShow) {
        case 2:
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(0,  CGRectGetHeight(self.view.bounds)-bottomHeight-64,CGRectGetWidth(self.view.bounds), bottomHeight)];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.view addSubview:button];
                [button setBackgroundColor:LH_RGBCOLOR(17,149,232)];
                [button setImage:[UIImage imageNamed:@"naviIcon"] forState:UIControlStateNormal];
                [button setTitle:@"导航到点" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 0;
                return;
            }
            break;
        case 3:
        {
//            是否同意按钮
            UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(self.view.bounds)-bottomHeight-64,CGRectGetWidth(self.view.bounds), bottomHeight)];
            bottomV.backgroundColor = MainBgColor;
            [self.view addSubview:bottomV];
            
            CGFloat width = CGRectGetWidth(self.view.bounds)/2;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(12, 0, bottomHeight, bottomHeight)];
            [button setImage:[UIImage imageNamed:@"unAgree"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [bottomV addSubview:button];
            isAgree = [Utility isAgreeReservationNoticeForKey:_urlString];
            [button setSelected:isAgree];
            
            UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 12, width-60, 20)];
            agreeLabel.text = @"阅读并同意";
            agreeLabel.textColor = [UIColor lightGrayColor];
            agreeLabel.font = [UIFont systemFontOfSize:13.0];
            [bottomV addSubview:agreeLabel];
            
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(CGRectGetMaxX(agreeLabel.frame),0,width, bottomHeight)];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:LH_RGBCOLOR(17,149,232)];
            [button setTitle:@"下一步" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [bottomV addSubview:button];

            return;
        }
            break;
        default:
            break;
    }
    CGFloat width = CGRectGetWidth(self.view.bounds)/2;
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(width*i,  CGRectGetHeight(self.view.bounds)-bottomHeight-64,width, bottomHeight)];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        if (i) {
            [button setBackgroundColor:LH_RGBCOLOR(12,189,49)];
            [button setTitle:@"立即预约" forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundColor:LH_RGBCOLOR(17,149,232)];
            [button setImage:[UIImage imageNamed:@"naviIcon"] forState:UIControlStateNormal];
            [button setTitle:@"导航到点" forState:UIControlStateNormal];
        }
        button.tag = i;
        [button addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
    }
}
- (void)bottomBtnAction:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    if (sender.tag) {
//        立即预约
//        ZQOnlineSubViewController *vc = [[ZQOnlineSubViewController alloc] initWithNibName:@"ZQOnlineSubViewController" bundle:nil];
//        [self.navigationController pushViewController:vc animated:YES];
        
        if (self.dSubType == 2) {
//            NSString *htmlStr = @"reservationNotice2.html";
//            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr andShowBottom:3];
            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.6" andShowBottom:3];
            Vc.title = @"机动车上门接送检车须知";
            if ([Utility getIs_vip]) {
                Vc.charge = [Utility getDoorToDoorOutlay_VIP].floatValue;
            }
            else
            {
                Vc.charge = [Utility getDoorToDoorOutlay].floatValue;
            }
            Vc.classString = NSStringFromClass([ZQUpSubdataViewController class]);
            Vc.dSubType = self.dSubType;
            [self.navigationController pushViewController:Vc animated:YES];
            return;
        }
        else if (self.dSubType == 0)
        {
//            NSString *htmlStr = @"reservationNotice3.html";
//            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr andShowBottom:3];
            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.2" andShowBottom:3];
            Vc.title = @"预约须知";
            Vc.classString = NSStringFromClass([ZQUpSubdataViewController class]);
            [self.navigationController pushViewController:Vc animated:YES];
            return;
        }
        else
       {
           ZQOnlineSubViewController *vc = [[ZQOnlineSubViewController alloc] initWithNibName:@"ZQOnlineSubViewController" bundle:nil];
           vc.pageType = 1;
           [self.navigationController pushViewController:vc animated:YES];
           return;
//           ZQUpSubdataViewController *subVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
//           [self.navigationController pushViewController:subVC animated:YES];
      }
    }
    else
    {
//        if (self.inModel.type.integerValue == 1)
//        {
//            if (!self.inModel.o_range || !self.inModel.o_product) {
//                [ZQLoadingView showAlertHUD:@"此机构暂没有位置数据!" duration:SXLoadingTime];
//                return;
//            }
//            if (![Utility getLatitude]) {
//                [ZQLoadingView showAlertHUD:@"没有当前位置数据!" duration:SXLoadingTime];
//                return;
//            }
//            GPSNaviViewController *nav = [[GPSNaviViewController alloc] init];
//            
//            nav.startPoint = [AMapNaviPoint locationWithLatitude:[Utility getLatitude] longitude:[Utility getLongitude]];
//            nav.endPoint = [AMapNaviPoint locationWithLatitude:self.inModel.o_range.doubleValue longitude:self.inModel.o_product.doubleValue];
//            [self.navigationController pushViewController:nav animated:YES];
//            return;
//        }
        [ZQLoadingView showAlertHUD:@"此机构暂未开通业务敬请期待!" duration:SXLoadingTime];
        
//        NSArray *array = @[@"百度地图",@"高德地图",@"取消"];
//        [Utility showActionSheetWithTitle:@"选择地图" contentArray:array controller:self chooseBlock:^(NSInteger index) {
//            if (index == 0) {
//                [Utility baiDuMapWithLongitude:self.inModel.o_product.doubleValue latitude:self.inModel.o_range.doubleValue];
//            }else if(index == 1){
//                [Utility gaoDeMapWithLongitude:self.inModel.o_product.doubleValue latitude:self.inModel.o_range.doubleValue];
//            }
//        }];
//        导航到店
//        [self baiDuMap:nil];
    }
}
- (void)clickAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [Utility storageAgreeReservationNotice:sender.selected forKey:self.urlString];
    isAgree = sender.selected;
//    if (sender.selected) {
//        [self dismissViewControllerAnimated:YES completion:^{
//        }];
//    }
}
//下一步
- (void)nextBtnAction
{
    if (!isAgree) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先阅读并同意相关须知 !" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([self.classString isEqualToString:@"ZQUpSubdataViewController"]) {
        ZQUpSubdataViewController *subVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
        if (self.charge>0) {
            subVC.serviceCharge = self.charge;
        }
        if (self.dSubType == 2)  {
            subVC.bookingType = 2;
        }
        else if (self.dSubType == 0)
        {
            subVC.bookingType = 1;
        }
        subVC.b_testing_id = self.testing_id;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else
    {
        UIViewController *Vc = [[NSClassFromString(self.classString) alloc] init];
        [self.navigationController pushViewController:Vc animated:YES];
        
    }
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"开始加载");
    self.progressV.hidden = NO;
    self.progressV.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    NSLog(@"返回加载");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    NSLog(@"加载完成");
    self.progressV.hidden = YES;
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"加载失败");
}

-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
//    NSLog(@"createWebViewWithConfiguration");
    
    if (!navigationAction.targetFrame.isMainFrame) {
        
        [webView loadRequest:navigationAction.request];
        
    }
    
    return nil;
    
}
//**WKNavigationDelegate*
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *requestString = navigationAction.request.URL.absoluteString;
    NSLog(@"requestString1111:%@",requestString);

    if (navigationAction.targetFrame==nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //获取请求的url路径.
    NSString *requestString = navigationResponse.response.URL.absoluteString;
    NSLog(@"requestString:%@",requestString);
//    if (decisionHandler) {
//        <#statements#>
//    }
    // 遇到要做出改变的字符串
//    NSString *subStr = @"www.baidu.com";
//    if ([requestString rangeOfString:subStr].location != NSNotFound) {
//        NSLog(@"这个字符串中有subStr");
//        //回调的URL中如果含有百度，就直接返回，也就是关闭了webView界面
////        [self.navigationController  popViewControllerAnimated:YES];
//    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == self.webView) {
        self.progressV.progress = self.webView.estimatedProgress;
        if (self.progressV.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressV.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressV.hidden = YES;
                [weakSelf.progressV removeFromSuperview];
                weakSelf.progressV = nil;
            }];
        }        }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return _webView;
}
- (UIProgressView *)progressV {
    if (!_progressV) {
        _progressV = [[UIProgressView alloc] init];
        _progressV.backgroundColor = LH_RGBCOLOR(17,149,232);
    }
    return _progressV;
}

//跳转到百度地图
- (void)baiDuMap:(id)sender {
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=雍和宫&mode=driving&coord_type=gcj02"];
        
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
        //
        NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        NSLog(@"您的iPhone未安装百度地图，请进行安装！");
    }
}

//跳转到高德地图
- (void)gaoDeMap:(id)sender {
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        //地理编码器
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //我们假定一个终点坐标，上海嘉定伊宁路2000号报名大厅:121.229296,31.336956
        [geocoder geocodeAddressString:@"天通苑" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark *placemark in placemarks){
                //坐标（经纬度)
                CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                
                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"mapNavigation",@"iosamap://",coordinate.latitude, coordinate.longitude];
                
                NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:urlString] invertedSet];
                
                NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }];
    }else{
        NSLog(@"您的iPhone未安装高德地图，请进行安装！");
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
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
