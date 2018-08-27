//
//  ZQNewUpVioViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNewUpVioViewController.h"
#import "ZQVioUpTableViewCell.h"
#import "ZQvioFooterView.h"
#import "YSureOrderBottomView.h"
#import "YBuyingDatePicker.h"
#import "ZQChoosePickerView.h"
#import "ZQHtmlViewController.h"
#import "YPayViewController.h"

#import "NSString+Validation.h"
#import "UITextField+ZQProTextField.h"
#import "BankCardSearch.h"

@interface ZQNewUpVioViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIImage        *_chooseImage;
    NSString       *desString;
    
    NSInteger temp;
}

@property (strong, nonatomic) UITableView          *tableView;
@property (strong, nonatomic) YSureOrderBottomView *bottomV;
@property (strong, nonatomic) YBuyingDatePicker    *datePickV;
@property (strong, nonatomic) ZQChoosePickerView   *pickView;
@property (copy,   nonatomic) NSString             *veriyCode;        //验证码

@property (strong, nonatomic) NSTimer *sTimer;
@property (strong, nonatomic) UIButton *codeBtn;

@property (strong, nonatomic) NSArray *contentArray;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSArray *placeArray;
@end

@implementation ZQNewUpVioViewController

- (void)dealloc
{
    NSLog(@"打发斯蒂芬提现dealloc");
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.sTimer) {
        [self.sTimer invalidate];
        self.sTimer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    temp = 60;
    self.title = @"提现";
    [self setupData];
    [self initViews];
}

-(void)setupData {

    self.titleArray = @[@[@"持卡人",@"身份证号"],@[@"选择银行",@"卡号",@"银行预留手机号"],@[@"提现金额（元）",@"￥",@"可提现金额￥0"]];
    self.placeArray = @[@[@"持卡人姓名",@"持卡人身份证号"],@[@"选择银行",@"请输入银行卡号",@"请输入银行预留手机号"],@[@"",@"输入提现金额",@""]];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"appuser/reflectuser" withParameters:@{@"guide_id":[Utility getUserID]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSDictionary *dic = jsonDic[@"data"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                __strong typeof(self) strongSelf = weakSelf;

                 strongSelf.titleArray = @[@[@"持卡人",@"身份证号"],@[@"选择银行",@"卡号",@"银行预留手机号"],@[@"提现金额（元）",@"￥",[NSString stringWithFormat:@"可提现金额￥%@",strongSelf.maxMoney]]];
                NSMutableArray *mutArr1 = [NSMutableArray arrayWithCapacity:2];
                NSMutableArray *mutArr2 = [NSMutableArray arrayWithCapacity:3];
                NSString *dname = dic[@"dname"];
                if (![dname isKindOfClass:[NSString class]]) {
                    dname = @"";
                }
                [mutArr1 addObject:dname];
                NSString *dcode = dic[@"dcode"];
                if (![dcode isKindOfClass:[NSString class]]) {
                    dcode = @"";
                }
                [mutArr1 addObject:dcode];
                
                NSString *kaname = dic[@"kaname"];
                if (![kaname isKindOfClass:[NSString class]]) {
                    kaname = @"";
                }
                [mutArr2 addObject:kaname];
                NSString *kacode = dic[@"kacode"];
                if (![kacode isKindOfClass:[NSString class]]) {
                    kacode = @"";
                }
                [mutArr2 addObject:kacode];
                NSString *userpnone = dic[@"userpnone"];
                if (![userpnone isKindOfClass:[NSString class]]) {
                    userpnone = @"";
                }
                [mutArr2 addObject:userpnone];
                strongSelf.contentArray = @[mutArr1,mutArr2,[NSMutableArray arrayWithArray:@[@"",@"",@""]]];

//                 strongSelf.contentArray = @[[NSMutableArray arrayWithArray:@[dic[@"dname"],dic[@"dcode"]]],[NSMutableArray arrayWithArray:@[dic[@"kaname"],dic[@"kacode"],dic[@"userpnone"]]],[NSMutableArray arrayWithArray:@[@"",@"",@""]]];
                [strongSelf.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:NO];
    
    
}

-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
}

-(void)initViews {
 
    CGFloat spaceY = (kDevice_Is_iPhoneX ? 88: 64);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, spaceY, KWidth, self.view.bounds.size.height - 50) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"ZQVioUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZQVioUpTableViewCell_id"];

    
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.view.frame), 50)];
    _putBtn.backgroundColor = __MoneyColor;
    _putBtn.titleLabel.font = MFont(18);
    [_putBtn setTitle:@"提交申请" forState:BtnNormal];
    [_putBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [_putBtn addTarget:self action:@selector(applyForMoneyAction) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:_putBtn];
}
- (void)applyForMoneyAction
{
    NSString *ticketNumStr = _contentArray[0][0];
    if (!ticketNumStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入持卡人姓名" duration:SXLoadingTime];
        return;
    }
    NSString *carCodeStr = _contentArray[0][1];
    if (!carCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入持卡人身份证号" duration:SXLoadingTime];
        return;
    }
    NSString *punishMoneyStr = _contentArray[1][0];
    if (!punishMoneyStr.length) {
        [ZQLoadingView showAlertHUD:@"请选择银行" duration:SXLoadingTime];
        return;
    }
    NSString *punishDateStr = _contentArray[1][1];
    if (!punishDateStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入银行卡号" duration:SXLoadingTime];
        return;
    }
    NSString *phoneStr = _contentArray[1][2];
    if (phoneStr.length) {
        if (![phoneStr isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入银行手预留机号" duration:SXLoadingTime];
        return;
    }
    NSString *moneyNum = _contentArray[2][1];
    if (moneyNum.length)
    {
        if (!moneyNum.floatValue) {
            [ZQLoadingView showAlertHUD:@"请输入提现金额" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入提现金额" duration:SXLoadingTime];
        return;
    }
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"appuser/addreflect" withParameters:@{@"guide_id":[Utility getUserID],@"dname":ticketNumStr,@"dcode":carCodeStr,@"kacode":punishMoneyStr,@"kaname":punishDateStr,@"userpnone":phoneStr,@"expected_account":moneyNum} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        if (succe) {
            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf performSelector:@selector(backAction) withObject:nil afterDelay:SXLoadingTime];
            }
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
    } animated:NO];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
-(void)showChooseView {
    [self.view endEditing:YES];
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:[Utility getBankNameList] inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                strongSelf.contentArray[1][0] = selectedStr;
                [strongSelf.tableView reloadData];
            }
        }
    }];
    
}
// 提交订单
-(void)putOrder {

    NSString *ticketNumStr = [_contentArray[0][0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (ticketNumStr.length != 16) {
        [ZQLoadingView showAlertHUD:@"请输入持卡人姓名" duration:SXLoadingTime];
        return;
    }
    NSString *carCodeStr = [_contentArray[0][1] trimDoneString];
    if (carCodeStr.length!=6) {
        [ZQLoadingView showAlertHUD:@"请输入持卡人身份证号" duration:SXLoadingTime];
        return;
    }
    NSString *punishMoneyStr = [_contentArray[1][0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!punishMoneyStr.length) {
        [ZQLoadingView showAlertHUD:@"请选择银行" duration:SXLoadingTime];
        return;
    }
    NSString *punishDateStr = _contentArray[1][1];
    if (!punishDateStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入银行卡号" duration:SXLoadingTime];
        return;
    }
    NSString *phoneStr = [_contentArray[1][2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (phoneStr.length) {
        if (![phoneStr isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入银行手预留机号" duration:SXLoadingTime];
        return;
    }
    NSString *moneyNum = _contentArray[2][1];
    if (!moneyNum.floatValue)
    {
        [ZQLoadingView showAlertHUD:@"请输入提现金额" duration:SXLoadingTime];
        return;
    }
//    NSString *codeStr = [_contentArray[5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (!codeStr.length) {
//        [ZQLoadingView showAlertHUD:@"请输入验证码" duration:SXLoadingTime];
//        return;
//    }
   
//    if (!_chooseImage) {
//        [ZQLoadingView showAlertHUD:@"请上传处罚决定书" duration:SXLoadingTime];
//        return;
//    }
    //代缴罚款接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/payment_of_fines/u_id/%@/ticket_number/%@/car_card/%@/fine_money/%@/fine_date/%@/phone/%@",[Utility getUserID],ticketNumStr,carCodeStr,punishMoneyStr,punishDateStr,phoneStr];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr Params:nil NSData:[self imageData:_chooseImage] key:@"pic_path" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                YPayViewController *payVC = [[YPayViewController alloc] init];
                payVC.payMoney = [NSString stringWithFormat:@"%@",jsonDic[@"total"]];
//                payVC.payMoney = jsonDic[@"money"];
                payVC.orderNo = jsonDic[@"order_no"];
                payVC.aPayType = ZQPayAFineView;
                [strongSelf.navigationController pushViewController:payVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}
//获取验证码
- (void)getCode
{
    NSString *phoneStr = [_contentArray[4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (phoneStr.length) {
        if (![phoneStr isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入手机号码" duration:SXLoadingTime];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_phone_code/phone/%@",phoneStr];
    //    获取验证码接口
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSInteger code = [jsonDic[@"code"] integerValue];
            if (code != 400) {
                strongSelf.veriyCode = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
                //            [strongSelf.codeBtn setBackgroundColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1.0]];
                strongSelf.sTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:strongSelf selector:@selector(numTiming:) userInfo:nil repeats:YES];
            }
            else
            {
                [ZQLoadingView showAlertHUD:jsonDic[@"statusmsg"] duration:SXLoadingTime];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}
- (void)numTiming:(NSTimer *)sTimer
{
    if (temp == 0) {
        [sTimer invalidate];
        self.sTimer = nil;
        temp = 60;
        [_codeBtn setUserInteractionEnabled:YES];
        //        [_codeBtn setBackgroundColor:[UIColor colorWithRed:0x41/255.0 green:0xc9/255.0 blue:0xdc/255.0 alpha:1.0]];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)temp--] forState:UIControlStateNormal];
    }
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tFSecion==1&&textField.tag==0) {
        [self showChooseView];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ((textField.tFSecion==0&&textField.tag==1) || (textField.tFSecion==1&&(textField.tag==1||textField.tag==2)))
    {
        if ([string isEqualToString:@""])
        {
            if ((textField.text.length - 2) % 5 == 0)
            {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        }
        else
        {
            if (textField.text.length % 5 == 0)
            {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    }
  
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.contentArray[textField.tFSecion][textField.tag] = [textField.text noEmptyString];
    if (textField.tFSecion==1&&textField.tag==1) {
        char tempChar[256];
        NSString * tempString = textField.text;
        
        strcpy(tempChar,(char *)[tempString UTF8String]);
        
        NSString *bank = [BankCardSearch getBankNameByBin:tempChar count:(int)tempString.length];
        if ([bank isKindOfClass:[NSString class]]) {
            self.contentArray[textField.tFSecion][textField.tag-1] = bank;
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag-1 inSection:textField.tFSecion]] withRowAnimation:UITableViewRowAnimationNone];
    }
    return YES;
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
    cell.contentTf.delegate = self;
    if (indexPath.section == 1 && indexPath.row==0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
       cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString *title = _titleArray[indexPath.section][indexPath.row];
    NSString *palceText = _placeArray[indexPath.section][indexPath.row];
    NSString *contentText = self.contentArray[indexPath.section][indexPath.row];
    cell.contentTf.tFSecion = indexPath.section;
    cell.contentTf.tag = indexPath.row;
    if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                [cell setCellType:ZQVioUpCellType3 title:title placeText:palceText provinceCode:nil];
            }
            break;
            case 1:
            {
                [cell setCellType:ZQVioUpCellType2 title:title placeText:palceText provinceCode:nil];
                [cell changeTitleColor:nil];
            }
            break;
            case 2:
            {
                [cell setCellType:ZQVioUpCellType3 title:title placeText:palceText provinceCode:nil];
                [cell changeTitleColor:[UIColor lightGrayColor]];
            }
            break;
            default:
            break;
        }
    }
    else
    {
        [cell setCellType:ZQVioUpCellType2 title:title placeText:palceText provinceCode:nil];
    }
    if ((indexPath.section==0&&indexPath.row==1) || (indexPath.section==1&&(indexPath.row==1||indexPath.row==2))) {
        [cell.contentTf setText:[contentText dealWithString]];
    }
    else
    {
        [cell.contentTf setText:contentText];
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    return nil;
}
// 设置表尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
//    ZQvioFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ZQvioFooterView_headerId"];
//    if (!footerView) {
//
//    }
//    if (_chooseImage) {
//        footerView.image = _chooseImage;
//    }
////    footerView.delegate = self;
//    if (section == 0) {
//        return footerView;
//    }else{
//        return nil;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 1 && indexPath.row==0) {
//        [self.view endEditing:YES];
//        [self.view addSubview:self.datePickV];
//    }
    
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

-(void)chooseImageAction {
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    //想要知道选择的图片
    pickerVC.delegate = self;
    //开启编辑状态
    pickerVC.allowsEditing = YES;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //    [self.imgView setImage:info[UIImagePickerControllerOriginalImage]];
    _chooseImage = info[UIImagePickerControllerOriginalImage];
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 私有方法
- (NSArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = @[[NSMutableArray arrayWithArray:@[@"",@""]],[NSMutableArray arrayWithArray:@[@"",@"",@""]],[NSMutableArray arrayWithArray:@[@"",@"",@""]]];
    }
    return _contentArray;
}
-(YBuyingDatePicker *)datePickV{
    if (!_datePickV) {
        _datePickV = [[YBuyingDatePicker alloc]initWithFrame:CGRectMake(0, __kHeight-260, __kWidth, 260)];
        _datePickV.limitDate = YES;
//        _datePickV.delegate = self;
    }
    return _datePickV;
}
- (NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
            
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
            
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
            
        }    }
    return data;
    
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
