//
//  YPayViewController.h
//  shopsN
//
//  Created by imac on 2016/12/23.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "BaseViewController.h"
//ZQPayPurseView = 0,    //钱包
typedef enum
{
    ZQPayVIPView = 0,      //VIP购买
    ZQPayNewCarView,       //新车免检预约
    ZQPayAFineView,        //代缴罚款
    ZQPayBookingView,      //检车预约
} ZQPayType;

@interface YPayViewController : BaseViewController

/**支付json*/
@property (strong,nonatomic) NSDictionary *payJson;
/**订单号*/
@property (copy,nonatomic) NSString *orderNo;
/**金额*/
@property (copy, nonatomic) NSString *payMoney;
/**订单名称*/
@property (copy,nonatomic) NSString *orderName;

//支付类型
@property (assign,nonatomic) ZQPayType aPayType;
@property (nonatomic,copy) void(^paySuccess)(void);

//@property (strong,nonatomic) YAddressModel *addressModel;

@end
