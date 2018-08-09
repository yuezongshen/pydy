//
//  YPayViewController.m
//  shopsN
//
//  Created by imac on 2016/12/23.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "YPayViewController.h"
#import "YPayTitleHeadView.h"
#import "YPayTypeChooseCell.h"
#import "YPayCardCell.h"
#import "YPayOtherHead.h"
#import "YPayThreeCell.h"
#import "YPayCardAddCell.h"

//#import "YAllOrderViewController.h"
#import "YPayCardCheckView.h"

#import "YOrderSuccessView.h"

//#import <Pingpp.h>

#import "PasswordKeyboard.h"
#import "ZQPayPasswordController.h"

@interface YPayViewController ()<UITableViewDelegate,UITableViewDataSource,YPayOtherHeadDelegate,YOrderSuccessViewDelegate>{
    BOOL _isPaySuccess;
}

@property (strong,nonatomic) UITableView *tableV;

@property (nonatomic) NSInteger chooseIndex;

@property (strong,nonatomic) YOrderSuccessView *successV;

@property (strong,nonatomic) NSArray *imageArr;

@property (strong,nonatomic) NSArray *titleArr;

@property (strong,nonatomic) NSArray *detailArr;

@property (nonatomic, strong) PasswordKeyboard *keyboard;

@end

@implementation YPayViewController

-(void)getData{
//    _imageArr = @[@"Payment_zfb",@"Payment_wx",@"money_logo"];
//    _titleArr = @[@"支付宝支付",@"微信支付",@"钱包支付"];
//    _detailArr = @[@"支付宝安全支付",@"微信安全支付",@"钱包安全支付"];
    
    _imageArr = @[@"Payment_zfb",@"Payment_wx"];
    _titleArr = @[@"支付宝支付",@"微信支付"];
    _detailArr = @[@"支付宝安全支付",@"微信安全支付"];
    
//    if (IsNilString(_payMoney)||_payMoney.floatValue ==0) {
//        _payMoney = @"0.00";
//         [self getSuceessView];
//         return;
//    }
    [_tableV reloadData];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayStatus:) name:YSOrderPayStatus object:nil];
    
    _keyboard = [PasswordKeyboard keyboard];
    [self.view addSubview:_keyboard];
    __weak typeof(self)wk = self;
    _keyboard.completeBlock = ^(NSString *password) {
        if ([password isEqualToString:[Utility getWalletPayPassword]]) {
             [wk requestWallet_vip_orderPay];
        }
        else
        {
            [ZQLoadingView showAlertHUD:@"支付密码错误" duration:SXLoadingTime];
        }
//        wk.pwdTF.text = [NSString stringWithFormat:@"password is %@.",password];
    };
    
    _keyboard.forgotPasswordBlock = ^{
        ZQPayPasswordController *payPasswordVc = [[ZQPayPasswordController alloc] initWithType:2];
        [wk.navigationController pushViewController:payPasswordVc animated:YES];
    };
}


- (void)viewDidLoad {
    [super viewDidLoad];
//     self.title = [NSString stringWithFormat:@"%@收银台",@"carCheck"];
    self.title = @"收银台";
    _chooseIndex = 1;
//    self.rightBtn.frame = CGRectMake(__kWidth-70, 35, 58, 15);
//    self.rightBtn.titleLabel.font = MFont(14);
//    self.rightBtn.backgroundColor = [UIColor clearColor];
//    [self.rightBtn setImage:MImage(@"") forState:BtnNormal];
//    [self.rightBtn setTitle:@"订单中心" forState:BtnNormal];
//    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [self initView];
    [self getData];
}

- (void)initView{
//    _tableV = [[UITableView alloc] initWithFrame];
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-64) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableV];
    _tableV.backgroundColor =  [UIColor whiteColor];
    _tableV.separatorColor = [UIColor clearColor];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    
}

- (void)chooseRight{
//    YAllOrderViewController *vc = [[YAllOrderViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];

}



#pragma mark ==UITableViewDelegate==
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YPayThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YPayThreeCell"];
    if (!cell) {
        cell = [[YPayThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YPayThreeCell"];
    }
    cell.title = _titleArr[indexPath.row];
    cell.detail = _detailArr[indexPath.row];
    cell.imageName = _imageArr[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    YPayTitleHeadView *header = [[YPayTitleHeadView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 50)];
    header.money = _payMoney;
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self requestAliPayData];
            break;
       case 1:
        {
             [self requestWeiChatPay];
        }
            break;
        case 2:
        {
            if ([Utility getWalletPayPassword])
            {
                [_keyboard showKeyboard];
            }
            else{
                ZQPayPasswordController *payPasswordVc = [[ZQPayPasswordController alloc] initWithType:1];
                [self.navigationController pushViewController:payPasswordVc animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

- (void)requestWeiChatPay
{
    NSString *urlStr = nil;
    switch (self.aPayType) {
        case ZQPayVIPView:
        {
        urlStr = [NSString stringWithFormat:@"daf/wx_vip_order/u_id/%@/channel/wx",[Utility getUserID]];
        }
            break;
        case ZQPayNewCarView:
        {
            if (self.orderNo.length) {
                urlStr = [NSString stringWithFormat:@"daf/n_bespeak_order/u_id/%@/channel/wx/order_no/%@",[Utility getUserID],self.orderNo];
            }
            else
            {
                [ZQLoadingView showAlertHUD:@"没有订单号" duration:SXLoadingTime];
            }
        }
            break;
        case ZQPayAFineView:
        {
            urlStr = [NSString stringWithFormat:@"daf/wx_fine_order/u_id/%@/channel/wx/order_no/%@",[Utility getUserID],self.orderNo];
        }
            break;
        case ZQPayBookingView:
        {
            urlStr = [NSString stringWithFormat:@"daf/upload_order/u_id/%@/channel/wx/order_no/%@",[Utility getUserID],self.orderNo];
        }
            break;
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            if ([jsonDic[@"code"] integerValue] != 100)
            {
//                [Pingpp createPayment:jsonDic viewController:strongSelf appURLScheme:@"CarCheckSchemes" withCompletion:^(NSString *result, PingppError *error) {
//                    if (error) {
//                         NSLog(@"YpayVC微信支付结果:%@",result);
//                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:YSOrderPayStatus object:@[@"成功"] userInfo:nil];
//                        //                        [strongSelf getPayStatus:nil];
//                        [ZQLoadingView showAlertHUD:result duration:SXLoadingTime];
//                    }
//                    else
//                    {
//                        [ZQLoadingView showAlertHUD:@"支付成功" duration:SXLoadingTime];
//                    }
//                }];
            }
        }
    } failure:^(NSError *error) {
    } animated:YES];
}
- (void)requestAliPayData
{
    NSString *urlStr = nil;
    switch (self.aPayType) {
        case ZQPayVIPView:
        {
            urlStr = [NSString stringWithFormat:@"daf/wx_vip_order/u_id/%@/channel/alipay",[Utility getUserID]];
        }
            break;
        case ZQPayNewCarView:
        {
            if (self.orderNo.length) {
                urlStr = [NSString stringWithFormat:@"daf/n_bespeak_order/u_id/%@/channel/alipay/order_no/%@",[Utility getUserID],self.orderNo];
            }
            else
            {
                [ZQLoadingView showAlertHUD:@"没有订单号" duration:SXLoadingTime];
            }
        }
            break;
        case ZQPayAFineView:
        {
            urlStr = [NSString stringWithFormat:@"daf/wx_fine_order/u_id/%@/channel/alipay/order_no/%@",[Utility getUserID],self.orderNo];
        }
            break;
        case ZQPayBookingView:
        {
            urlStr = [NSString stringWithFormat:@"daf/upload_order/u_id/%@/channel/alipay/order_no/%@",[Utility getUserID],self.orderNo];
        }
            break;
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            if ([jsonDic[@"code"] integerValue] != 100)
            {
//                [Pingpp createPayment:jsonDic viewController:strongSelf appURLScheme:@"CarCheckSchemes" withCompletion:^(NSString *result, PingppError *error) {
//                    if (error) {
//                        NSLog(@"YpayVC支付宝支付结果:%@",result);
//                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:YSOrderPayStatus object:@[@"成功"] userInfo:nil];
//                        //                        [strongSelf getPayStatus:nil];
//                        [ZQLoadingView showAlertHUD:result duration:SXLoadingTime];
//                    }
//                    else
//                    {
//                        [ZQLoadingView showAlertHUD:@"支付成功" duration:SXLoadingTime];
//                    }
//                }];
            }
        }
    } failure:^(NSError *error) {
    } animated:YES];
}
- (void)requestWallet_vip_orderPay
{
    NSString *urlStr = nil;
    switch (self.aPayType) {
        case ZQPayVIPView:
        {
            urlStr = [NSString stringWithFormat:@"daf/wallet_vip_order/u_id/%@",[Utility getUserID]];
        }
            break;
        case ZQPayNewCarView:
        {
            if (self.orderNo.length) {
                urlStr = [NSString stringWithFormat:@"daf/wallet_n_bespeak_order/u_id/%@/order_no/%@",[Utility getUserID],self.orderNo];
            }
            else
            {
                [ZQLoadingView showAlertHUD:@"没有订单号" duration:SXLoadingTime];
                return;
            }
        }
            break;
        case ZQPayAFineView:
        {
            urlStr = [NSString stringWithFormat:@"daf/wallet_send/u_id/%@/order_no/%@",[Utility getUserID],self.orderNo];
        }
            break;
        case ZQPayBookingView:
        {
            urlStr = [NSString stringWithFormat:@"daf/wallet_bespeak_order/u_id/%@/order_no/%@",[Utility getUserID],self.orderNo];
        }
            break;
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                if (strongSelf.aPayType==ZQPayVIPView) {
                    [Utility storageInteger:2 forKey:@"is_vip"];
                    if (strongSelf.paySuccess) {
                        strongSelf.paySuccess();
                    }
                    [strongSelf performSelector:@selector(backAction) withObject:nil afterDelay:2.6];
                }
                [strongSelf performSelector:@selector(backRootVcAction) withObject:nil afterDelay:2.6];
            }
        }
    } failure:^(NSError *error) {
    } animated:YES];
}

- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)backRootVcAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getSuceessView{
    _isPaySuccess = YES;
    [self.view addSubview:self.successV];
    [self.view bringSubviewToFront:self.successV];

}

-(void)choosePay {
    
}

#pragma mark ==YOrderSuccessViewDelegate==
-(void)makelookOrder{
    [_successV removeFromSuperview];
//    YOrdersDetailViewController *vc = [[YOrdersDetailViewController alloc]init];
//    vc.status = @"待处理";
//    vc.orderId = _orderId;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark ==懒加载==
-(YOrderSuccessView *)successV{
    if (!_successV) {
        _successV = [[YOrderSuccessView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, __kHeight-64)];
//        _successV.name = _addressModel.name;
//        _successV.address = [NSString stringWithFormat:@"%@%@%@%@",_addressModel.province,_addressModel.city,_addressModel.area,_addressModel.Address];
//        _successV.address = _addressModel.address_info;
        _successV.money = _payMoney;
        _successV.delegate = self;
    }
    return _successV;
}

- (void)getPayStatus:(NSNotification *)info {
    [self getSuceessView];
}

-(void)back{
    
    if (_isPaySuccess) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
