//
//  Utility.m
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(BOOL )isLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}
+ (NSString *)getUserName {
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    if (str.length) {
        return str;
    }
    return @"未登录";
}

+ (NSString *)getUserID {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
//    return @"79";
}

+(NSInteger)getIs_vip
{
    NSInteger temp = [[NSUserDefaults standardUserDefaults] integerForKey:@"is_vip"];
    if (temp == 2) {
        return YES;
    }
    return NO;
}
/**
 *  获取支付
 *
 */
+(NSString *)getWalletPayPassword
{
    NSString *walletPayStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"WalletPayP"];
    if (walletPayStr.length) {
        return walletPayStr;
    }
    return @"";
}
+(NSString *)getUserPhone
{
    NSString *phone = [[NSUserDefaults standardUserDefaults] valueForKey:@"userPhone"];
    if (phone.length) {
        return phone;
    }
    return @"";
}
//+(NSData *)getUserHeadData
//{
//    return [[NSUserDefaults standardUserDefaults] valueForKey:@"userHeadData"];
//}
+(NSString *)getUserHeadUrl
{
    NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"userHeadUrl"];
    if (str.length) {
        return str;
    }
    return nil;
}
+(void)saveWalletPayPassword:(NSString *)pwd
{
   [Utility storageObject:pwd forKey:@"WalletPayP"];
}
+(void)saveUserInfo:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        [Utility setLoginStates:YES];
        [Utility storageObject:dict[@"mobile"] forKey:@"userPhone"];
        [Utility storageObject:[NSString stringWithFormat:@"%@",dict[@"id"]] forKey:@"userId"];
//        NSString *headStr = dict[@"imgurl"];
//        if ([headStr isKindOfClass:[NSString class]]) {
//            if (headStr.length) {
//                [Utility storageObject:headStr forKey:@"userHeadUrl"];
//            }
//        }
    }
    else
    {
        [Utility storageObject:nil forKey:@"userPhone"];
        [Utility storageObject:nil forKey:@"userId"];
//        [Utility storageObject:nil forKey:@"userHeadUrl"];
    }
}
+(double)getLongitude
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"Longitude"];
}
+(double)getLatitude
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:@"Latitude"];
}
+(void)saveLongitude:(double)lon Latitude:(double)lat
{
    [Utility storageValue:lon forKey:@"Longitude"];
    [Utility storageValue:lat forKey:@"Latitude"];
}
+(void)storageValue:(double)value forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)storageObject:(id)object forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)storageBool:(BOOL)object forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setBool:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)storageInteger:(NSInteger)object forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setInteger:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setLoginStates:(BOOL )isLogin {
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    if (!isLogin) {
        [Utility saveUserInfo:nil];
    }
}
+(id)getObjectforKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
//是否已同意预约须知协议
+(void)storageAgreeReservationNotice:(BOOL)agree forKey:(NSString*)key
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setBool:agree forKey:key];
    [ud synchronize];
}
+(BOOL)isAgreeReservationNoticeForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
//+(void)saveUserName:(NSString *)userName {
//    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(void)saveUserId:(NSString *)userId {
//    [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userId"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//+(void)saveUserPhone:(NSString *)phone
//{
//
//}
//+(void)saveIs_vip:(NSInteger)is_vip
//{
//
//}

+ (void)initStateForLeaddingView {
    
    if ([Utility isFirstLoadding]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@0 forKey:@"lead1"];
        [dict setObject:@0 forKey:@"lead2"];
        [dict setObject:@0 forKey:@"lead3"];
        [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"leadView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)isFirstLoadding {
    
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLoadding"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLoadding"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return !flag;
}

+(NSDictionary *)getUserInfoFromLocal
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userInfo"];
    return dict;
}
+ (BOOL )shouldShowLeadViewStateWithKey:(NSString *)leadView {
    // 判断的同时改变状态
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"leadView"];
    BOOL flag = [dict[leadView] boolValue];

    return !flag;
    
}

+(void)updateStateForLeadView:(NSString *)leadView {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"leadView"];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [tempDict setValue:@1 forKey:leadView];
    [[NSUserDefaults standardUserDefaults] setValue:tempDict forKey:@"leadView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)checkNewVersion:(void(^)(BOOL hasNewVersion))versionCheckBlock{
    
//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
////    NSLog(@"%@",[infoDict objectForKey:@"CFBundleShortVersionString"]);
//    __block double currentVersion = [[infoDict objectForKey:@"CFBundleShortVersionString"] doubleValue];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:@"IOS" forKey:@"clientType"];
//    [RequestManager startRequest:kCheckNewVersionAPI paramer:dict method:(RequestMethodPost) success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dict = [responseObject objectForKey:@"list"];
//        double newVersion = [[dict objectForKey:@"versionNum"] doubleValue];
//        BOOL flag = newVersion > currentVersion;
//        versionCheckBlock(flag);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        versionCheckBlock(NO);
//    }];
}

//跳转到百度地图
+ (void)baiDuMapWithLongitude:(double)lon latitude:(double)lat {
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
        
//        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&origin=我的位置&lat=%f&lon=%f&dev=0&style=2",lat,lon];
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&&lat=%f&lon=%f&mode=driving&coord_type=gcj02",lat,lon];

//        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=雍和宫&mode=driving&coord_type=gcj02"];
        
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
        //
        NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E7%99%BE%E5%BA%A6%E5%9C%B0%E5%9B%BE-%E5%85%AC%E4%BA%A4%E5%9C%B0%E9%93%81%E5%87%BA%E8%A1%8C%E5%BF%85%E5%A4%87%E7%9A%84%E6%99%BA%E8%83%BD%E5%AF%BC%E8%88%AA/id452186370?mt=8"]];
    }
}

//跳转到高德地图
+ (void)gaoDeMapWithLongitude:(double)lon latitude:(double)lat {
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        //地理编码器
//        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&backScheme=iosamap://&dev=0&style=2"];
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&origin=我的位置&lat=%f&lon=%f&dev=0&style=2",lat,lon];

//        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=mapNavigation&origin=我的位置&destination=雍和宫&dev=0&style=2"];
        NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];
        //
        NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        //我们假定一个终点坐标，上海嘉定伊宁路2000号报名大厅:121.229296,31.336956
//        [geocoder geocodeAddressString:@"天通苑" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            for (CLPlacemark *placemark in placemarks){
//                //坐标（经纬度)
//                CLLocationCoordinate2D coordinate = placemark.location.coordinate;
//
//                NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"mapNavigation",@"iosamap://",coordinate.latitude, coordinate.longitude];
//
//                NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:urlString] invertedSet];
//
//                NSString *url = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//            }
//        }];
    }else{
//        NSLog(@"您的iPhone未安装高德地图，请进行安装！");
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E9%AB%98%E5%BE%B7%E5%9C%B0%E5%9B%BE-%E7%B2%BE%E5%87%86%E5%9C%B0%E5%9B%BE-%E5%AF%BC%E8%88%AA%E5%BF%85%E5%A4%87-%E9%A6%96%E5%8F%91%E9%80%82%E9%85%8Diphone-x/id461703208?mt=8"]];
    }
}

// 底部弹窗Actionsheet
+(void)showActionSheetWithTitle:(NSString *)title
                   contentArray:(NSArray *)contentArray
                     controller:(UIViewController *)controller
                    chooseBlock:(void(^)(NSInteger index))block{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    for (int i = 0; i < contentArray.count; i ++ ) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:contentArray[i] style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            block(i);
        }];
        [alertVC addAction:alertAction];
    }
    [controller presentViewController:alertVC animated:YES completion:nil];
}

//请求的url进行编码
+ (NSString *)percentEncodingWithUrl:(NSString *)url
{
//    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
//    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
//    return [url stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
     return  [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
}

//所有省份简称
+ (NSArray *)getProvinceShortNum
{
    return @[@"京",@"津",@"沪",@"渝",@"蒙",@"冀",@"新",@"辽",@"藏",@"宁",@"桂",@"黑",@"晋",@"青",@"鲁",@"港",@"澳",@"豫",@"苏",@"皖",@"闽",@"赣",@"湘",@"鄂",@"粤",@"琼",@"甘",@"陕",@"贵",@"云",@"川"];
}

+ (NSArray *)getBankNameList
{
    return @[@"招商银行",@"工商银行",@"中国银行",@"建设银行"];
}
/**
 *  获取上门服务费
 *
 */
+(NSString *)getDoorToDoorOutlay
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"DoorOutlay"];
}
/**
 *  获取新车免检服务费
 *
 */
+(NSString *)getNewCarServiceOutlay
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"NewCarOutlay"];
}
/**
 *  获取新车免检VIP服务费
 *
 */
+(NSString *)getNewCarServiceOutlay_VIP
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"NewCarOutlay_VIP"];
}
/**
 *  获取上门VIP服务费
 *
 */
+(NSString *)getDoorToDoorOutlay_VIP
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"DoorOutlay_VIP"];
}
/**
 *  获取服务电话
 *
 */
+(NSString *)getServerPhone
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"ServerPhone"];
}
+(void)saveServiceMoneyWithArray:(NSArray*)array
{
    for (NSDictionary *dic in array) {
        NSString *str = dic[@"c_name"];
        if ([str isKindOfClass:[NSString class]]) {
            if ([str rangeOfString:@"新车"].location != NSNotFound) {
                [Utility storageObject:dic[@"c_cost"] forKey:@"NewCarOutlay"];
                [Utility storageObject:dic[@"vip_cost"] forKey:@"NewCarOutlay_VIP"];
            }
            if ([str rangeOfString:@"上门"].location != NSNotFound) {
                [Utility storageObject:dic[@"c_cost"] forKey:@"DoorOutlay"];
                [Utility storageObject:dic[@"vip_cost"] forKey:@"DoorOutlay_VIP"];
            }
            if ([str rangeOfString:@"罚款"].location != NSNotFound) {
                [Utility storageObject:dic[@"c_cost"] forKey:@"FineOutlay"];
                [Utility storageObject:dic[@"vip_cost"] forKey:@"FineOutlay_VIP"];
            }
        }
    }
}

+ (void)callTraveller:(NSString *)phoneStr
{
    if ([phoneStr isKindOfClass:[NSString class]]) {
        if (phoneStr.length) {
            NSString* PhoneStr = [NSString stringWithFormat:@"tel:%@",phoneStr];
            UIApplication * app = [UIApplication sharedApplication];
            if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil];
                } else {
                    [app openURL:[NSURL URLWithString:PhoneStr]];
                }
            }
            return;
        }
    }
    [ZQLoadingView showAlertHUD:@"电话号码不合法" duration:SXLoadingTime];
}
//打电话
+ (void)phoneCallAction
{
    NSString *phoneStr = [Utility getServerPhone];
    NSString* PhoneStr = [NSString stringWithFormat:@"tel:%@",phoneStr];
    UIApplication * app = [UIApplication sharedApplication];
    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:nil];
        } else {
           [app openURL:[NSURL URLWithString:PhoneStr]];
        }
    }
    
//    NSString *str= [NSString stringWithFormat:@"tel://%@",phoneStr];
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"请拨打新概念检车统一客服热线: %@",phoneStr] preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
//            if (@available(iOS 10.0, *)) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
//            } else {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//            }
//        }
//
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:otherAction];
//
//    [[Utility getCurrentNavigationController] presentViewController:alertController animated:YES completion:nil];
}
+ (UINavigationController *)getCurrentNavigationController
{
    UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    return (UINavigationController *)tbc.selectedViewController;
}
//    阅读学习
+(void)requestAlreadyReadWithId:(NSString *)infoId
{
    if ([Utility isLogin]) {
        if ([infoId isKindOfClass:[NSString class]]) {
            if (infoId.length)
            {
                [ZQLoadingView showProgressHUD:@"loading..."];
                [JKHttpRequestService POST:@"api/index/yuedu" withParameters:@{@"memberid":[Utility getUserID],@"infoid":infoId,@"token":[Utility getWalletPayPassword]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                    [ZQLoadingView hideProgressHUD];
                    if (succe) {
                        
                    }
                    else
                    {
                        [ZQLoadingView showAlertHUD:jsonDic[@"info"] duration:SXLoadingTime];
                    }
                } failure:^(NSError *error) {
                    [ZQLoadingView hideProgressHUD];
                } animated:NO];
            }
        }
    }
}
+ (void)speakActionWithString:(NSString *)string
{
   
}
+(NSString *)verifyActionWithString:(NSString *)str
{
    if ([str isKindOfClass:[NSString class]]) {
        if (str.length) {
            return str;
        }
    }
    return @"";
}
@end
