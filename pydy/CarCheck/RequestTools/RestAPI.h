//
//  RestAPI.h
//  美食厨房
//
//  Created by zhangqiang on 15/8/7.
//  Copyright (c) 2015年 zhangqiang. All rights reserved.
//

#ifndef _____RestAPI_h
#define _____RestAPI_h
#import <UIKit/UIKit.h>


#define AccountBaseAPI          @"http://pypc.sztd123.com/api/"
//http://pypc.sztd123.com/index.php/api/py/
#define BaseAPI                 @"https://pypc.sztd123.com/api/"
//#define BaseAPI                 @"http://dangj.sztd123.com/"  // 公司服务器
#define ImageBaseAPI            @"https://pypc.sztd123.com"  // 公司服务器

#define MAXRECORDTIME 180
#define MINRECORDTIME 1
//   常量
/**************************************************************************************/

static NSString *const ZQdidLoginNotication = @"didLoginNotication";    // 登录成功

static NSString *const ZQdidLogoutNotication = @"didLogoutNotication"; // 退出登录

static NSString *const ZQReadStateDidChangeNotication = @"changeReadStatesNotication"; // 消息已读状态

static NSString *const ZQAddServeInfoNotication = @"addServeInfoNotication"; // 添加服务台消息

static NSString *const ZQAddOtherInfoNotication = @"addOtherInfoNotication"; // 添加其他消息

/**************************************************************************************/

//   storyboardId
/**************************************************************************************/

static NSString *const ZQLoginViewCotrollerId = @"loginViewCotrollerId";    // 登录控制器Id

static NSString *const ZQServeTabViewControllerId = @"serveTabViewControllerId";    // 服务台信息

static NSString *const ZQServeDetailViewControllerId = @"serveDetailViewControllerId"; // 服务台信息详情
static NSString *const ZQPublishInfoViewControllerId = @"publishInfoViewControllerId"; // 发布消息

/**************************************************************************************/

// 推送
//#define AppKey @"b4b8bd0f427af09839e23286"    // 测试

#define AppKey @"6816fee48fb77859f7a9011b"     // 发布

#endif
