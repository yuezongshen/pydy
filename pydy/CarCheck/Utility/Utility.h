//
//  Utility.h
//  OATest
//
//  Created by zhangqiang on 15/9/2.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSArray *)getBankNameList;
/**
 *  初始化是否显示引导图信息
 *
 */
+ (void)initStateForLeaddingView;

/**
 *  是否显示过
 *
 *  @return flag
 */
+ (BOOL )shouldShowLeadViewStateWithKey:(NSString *)leadView;

/**
 *  更新状态
 *
 */
+(void)updateStateForLeadView:(NSString *)leadView;
/**
 *  获取用户信息
 *
 *  @return 用户信息
 */
+(NSDictionary *)getUserInfoFromLocal;

/**
 *  设置登录状态
 *
 *  @param isLogin 是否登录
 */
+(void)setLoginStates:(BOOL )isLogin;
/**
 *  登录后保存用户信息
 *
 *
 */
+(void)saveUserInfo:(NSDictionary *)dict;
/**
 *  登录状态
 *
 *  @return 是否登录
 */
+(BOOL )isLogin;

/**
 *  获取用户ID
 */
+ (NSString *)getUserID;

/**
 *  获取用户名
 *
 */
+ (NSString *)getUserName;
/**
 *  获取是否是vip会员
 *
 */
+(NSInteger)getIs_vip;
/**
 *  获取用户手机
 *
 */
+(NSString *)getUserPhone;
/**
 *  获取头像Data
 *
 */
//+(NSData *)getUserHeadData;
/**
 *  获取头像Url
 *
 */
+(NSString *)getUserHeadUrl;
/**
 *  版本检测
 *
 *  @param versionCheckBlock 是否有新版本
 */
+(void)checkNewVersion:(void(^)(BOOL hasNewVersion))versionCheckBlock;

/**
 *  打开百度地图
 *
 */
+ (void)baiDuMapWithLongitude:(double)lon latitude:(double)lat;

/**
 *  打开高德地图
 *
 */
+ (void)gaoDeMapWithLongitude:(double)lon latitude:(double)lat;

/**
 *  弹窗
 *
 *  @param title 标题
 *  @param contentArray 内容项
 *  @param controller 显示的控制器
 *  @param block 选中回调
 */
+(void)showActionSheetWithTitle:(NSString *)title
                   contentArray:(NSArray *)contentArray
                     controller:(UIViewController *)controller
                    chooseBlock:(void(^)(NSInteger index))block;
//保存获取数据
+(void)storageObject:(id)object forKey:(NSString*)key;
+(id)getObjectforKey:(NSString*)key;
+(void)storageBool:(BOOL)object forKey:(NSString*)key;
+(void)storageInteger:(NSInteger)object forKey:(NSString*)key;
//是否已同意预约须知协议
+(void)storageAgreeReservationNotice:(BOOL)agree forKey:(NSString*)key;
+(BOOL)isAgreeReservationNoticeForKey:(NSString*)key;

//请求的url进行编码
+ (NSString *)percentEncodingWithUrl:(NSString *)url;

//所有省份简称
+ (NSArray *)getProvinceShortNum;


/**
 *  获取上门服务费
 *
 */
+(NSString *)getDoorToDoorOutlay;
/**
 *  获取新车免检服务费
 *
 */
+(NSString *)getNewCarServiceOutlay;
/**
 *  获取新车免检VIP服务费
 *
 */
+(NSString *)getNewCarServiceOutlay_VIP;
/**
 *  获取上门VIP服务费
 *
 */
+(NSString *)getDoorToDoorOutlay_VIP;
//保存费用
+(void)saveServiceMoneyWithArray:(NSArray*)array;
/**
 *  获取服务电话
 *
 */
+(NSString *)getServerPhone;
/**
 *  获取支付
 *
 */
+(NSString *)getWalletPayPassword;
+(void)saveWalletPayPassword:(NSString *)pwd;
//经纬度
+(double)getLongitude;
+(double)getLatitude;
+(void)saveLongitude:(double)lon Latitude:(double)lat;
+(void)phoneCallAction;
+(void)callTraveller:(NSString *)phoneStr;
+(void)requestAlreadyReadWithId:(NSString *)infoId;
+ (void)speakActionWithString:(NSString *)string;
+(NSString *)verifyActionWithString:(NSString *)str;
@end
