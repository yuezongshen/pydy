//
//  ZQRechargeViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/11.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQRechargeViewController.h"

//#import "YPayCardCell.h"
#import "YPayThreeCell.h"

#import "YOrderSuccessView.h"
//#import <Pingpp.h>

@interface ZQRechargeViewController ()<UITableViewDelegate,UITableViewDataSource,YOrderSuccessViewDelegate,UITextFieldDelegate>
{
    BOOL _isPaySuccess;
}
/**金额*/
@property (strong,nonatomic) NSString *payMoney;

@property (strong,nonatomic) UITableView *tableV;

@property (nonatomic) NSInteger chooseIndex;

@property (strong,nonatomic) YOrderSuccessView *successV;

@property (strong,nonatomic) NSArray *imageArr;

@property (strong,nonatomic) NSArray *titleArr;

@property (strong,nonatomic) NSArray *detailArr;
@end

@implementation ZQRechargeViewController

-(void)getData{
    _imageArr = @[@"Payment_zfb",@"Payment_wx"];
    _titleArr = @[@"支付宝支付",@"微信支付"];
    _detailArr = @[@"支付宝安全支付",@"微信安全支付"];
    //    if (IsNilString(_payMoney)||_payMoney.floatValue ==0) {
    //        _payMoney = @"0.00";
    //         [self getSuceessView];
    //         return;
    //    }
//    [_tableV reloadData];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayStatus:) name:@"" object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    _chooseIndex = 1;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self getData];

    [self initView];
}

- (void)initView{
    //    _tableV = [[UITableView alloc] initWithFrame];
    _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight-64) style:(UITableViewStyleGrouped)];
    [self.view addSubview:_tableV];
    _tableV.backgroundColor =  [UIColor whiteColor];
    _tableV.separatorColor = [UIColor clearColor];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 86)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 20)];
    label.text = @"填写充值金额:";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    [headView addSubview:label];
    
    UITextField *_contactView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 10, CGRectGetWidth(self.view.frame)-CGRectGetMaxX(label.frame)-20, 30)];
    _contactView.backgroundColor = [UIColor whiteColor];
    _contactView.borderStyle = UITextBorderStyleRoundedRect;
    _contactView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contactView.returnKeyType = UIReturnKeyDone;
    _contactView.keyboardType = UIKeyboardTypeDecimalPad;
    _contactView.delegate = self;
//    _contactView.placeholder = @"";
    _contactView.font = [UIFont systemFontOfSize:14];
    _contactView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [headView addSubview:_contactView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+20, 150, 20)];
    label.text = @"选择充值方式:";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    [headView addSubview:label];
    
    self.tableV.tableHeaderView = headView;
}

- (void)chooseRight{
    //    YAllOrderViewController *vc = [[YAllOrderViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        self.payMoney = textField.text;    return YES;
    }
    else
    {
        if (string.length == 0) return YES;
        NSString *lastStr = [[textField.text componentsSeparatedByString:@"."] lastObject];
        if (lastStr.length>1) {
            return NO;
        }
        self.payMoney = textField.text;
        return YES;
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.payMoney = textField.text;
    return YES;
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    switch (indexPath.row) {
        case 0:
            {
                [self requestAliPay];
            }
            break;
        case 1:
        {
            [self requestWeiChatPay];
        }
            break;
        case 2:
        {
            [self requestWallet_vip_orderPay];
        }
            break;
        default:
            break;
    }
}

- (void)requestWeiChatPay
{
    if (_payMoney.floatValue > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"daf/wx_order/channel/wx/u_id/%@/money/%.2f",[Utility getUserID],_payMoney.floatValue];
        __weak typeof(self) weakSelf = self;
        [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
//                [Pingpp createPayment:jsonDic viewController:strongSelf appURLScheme:@"CarCheckSchemes" withCompletion:^(NSString *result, PingppError *error) {
//
//                    if (error) {
//                                            NSLog(@"微信支付结果:%@",result);
//                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:YSOrderPayStatus object:@[@"成功"] userInfo:nil];
//                        //                    [strongSelf getPayStatus:nil];
//                        [ZQLoadingView showAlertHUD:result duration:SXLoadingTime];
//                    }
//                    else
//                    {
//                        [ZQLoadingView showAlertHUD:@"支付成功" duration:SXLoadingTime];
//                    }
//                }];
            }
        } failure:^(NSError *error) {
        } animated:YES];
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请填写金额" duration:SXLoadingTime];
    }
}
- (void)requestWallet_vip_orderPay
{
    if (_payMoney.floatValue>0) {
        NSString *urlStr = [NSString stringWithFormat:@"daf/wx_order/u_id/%@/money/%@",[Utility getUserID],_payMoney];
//        __weak typeof(self) weakSelf = self;
        [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//                    if (succe) {
//                        __strong typeof(self) strongSelf = weakSelf;
//                        if (strongSelf)
//                        {
//                            strongSelf.rechargeSuccess();
//                        }
//                    }
        } failure:^(NSError *error) {
        } animated:YES];
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请填写金额" duration:SXLoadingTime];
    }
}
- (void)requestAliPay
{
    if (_payMoney.floatValue > 0) {
        NSString *urlStr = [NSString stringWithFormat:@"daf/wx_order/channel/alipay/u_id/%@/money/%.2f",[Utility getUserID],_payMoney.floatValue];
        __weak typeof(self) weakSelf = self;
        [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
//                [Pingpp createPayment:jsonDic viewController:strongSelf appURLScheme:@"CarCheckSchemes" withCompletion:^(NSString *result, PingppError *error) {
//                    
//                    if (error) {
//                        NSLog(@"支付宝支付结果:%@",result);
//                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:YSOrderPayStatus object:@[@"成功"] userInfo:nil];
//                        //                    [strongSelf getPayStatus:nil];
//                        [ZQLoadingView showAlertHUD:result duration:SXLoadingTime];
//                    }
//                    else
//                    {
//                        [ZQLoadingView showAlertHUD:@"支付成功" duration:SXLoadingTime];
//                    }
//                }];
            }
        } failure:^(NSError *error) {
        } animated:YES];
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请填写金额" duration:SXLoadingTime];
    }
}
-(void)getSuceessView{
//    _isPaySuccess = YES;
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
