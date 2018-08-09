//
//  ZQInsuranceVController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/15.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQInsuranceVController.h"
#import "ZQVioUpTableViewCell.h"
#import "ZQChoosePickerView.h"
//#import "ZQHtmlViewController.h"
//#import "YPayViewController.h"
#import "NSString+Validation.h"
#import "YBuyingDatePicker.h"

@interface ZQInsuranceVController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZQVioUpTableViewCellDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *titleArray;
@property (strong,nonatomic) NSArray *placeArray;
@property (strong,nonatomic) ZQChoosePickerView *pickView;
@property (strong, nonatomic) YBuyingDatePicker *datePickV;

@property (copy, nonatomic) NSString *shortNumStr;
@property (copy, nonatomic) NSString *i_name;
@property (copy, nonatomic) NSString *i_phone;
@property (copy, nonatomic) NSString *i_car_card;
@property (copy, nonatomic) NSString *endTime;

@end

@implementation ZQInsuranceVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保险服务";
    self.i_phone = [Utility getUserPhone];
    self.shortNumStr = @"冀";
    self.endTime = @"";
    [self setupData];
    [self initViews];
}
-(void)setupData {
    _titleArray = @[@"车主姓名",@"手机号码",@"保险到期日",@"车辆号码"];
    _placeArray = @[@"请输入车主姓名",@"请输入手机号码",@"请选择时间",@"请输入车辆号码"];
}
-(void)initViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height-50) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ZQVioUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZQVioUpTableViewCell_id"];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 140)];
    self.tableView.tableFooterView = footView;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = __DTextColor;
//    label.textColor = [UIColor lightTextColor];
    label.text = @"*资料提交后工作人员将会及时电话回访";
//    self.tableView.tableFooterView = label;
    [footView addSubview:label];
    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, CGRectGetMaxY(label.frame)+10, 80, 30)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor darkTextColor];
    label.text = @"服务热线: ";
    [footView addSubview:label];
    
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),CGRectGetMinY(label.frame),120, 30)];
    phoneBtn.titleLabel.font = MFont(18);
    [phoneBtn setTitle:[Utility getServerPhone] forState:BtnNormal];
    [phoneBtn setTitleColor:LH_RGBCOLOR(17,149,232) forState:BtnNormal];
//    [phoneBtn setTitleColor:[UIColor blueColor] forState:BtnNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnAction) forControlEvents:BtnTouchUpInside];
    [footView addSubview:phoneBtn];
    
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-50, CGRectGetWidth(self.view.frame), 50)];
    _putBtn.backgroundColor = __DefaultColor;
    _putBtn.titleLabel.font = MFont(18);
    [_putBtn setTitle:@"提交资料" forState:BtnNormal];
    [_putBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [_putBtn addTarget:self action:@selector(commitInformation) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:_putBtn];
}
//提交订单
- (void)commitInformation
{
    NSString *nameStr = [self.i_name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!nameStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入车主姓名" duration:SXLoadingTime];
        return;
    }
    NSString *phoneStr = [self.i_phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
    if (!self.endTime.length) {
        [ZQLoadingView showAlertHUD:@"请选择保险到期日" duration:SXLoadingTime];
        return;
    }
    NSString *carCardStr = [self.i_car_card trimDoneString];
    if (carCardStr.length !=6) {
        [ZQLoadingView showAlertHUD:@"请输入正确车牌号码" duration:SXLoadingTime];
        return;
    }
    carCardStr = [NSString stringWithFormat:@"%@%@",self.shortNumStr,carCardStr];
    //保险服务接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/insurance_service/u_id/%@/i_name/%@/i_phone/%@/i_car_card/%@/endtime/%@",[Utility getUserID],nameStr,phoneStr,carCardStr,self.endTime];
//    api/daf/insurance_service/u_id/62/i_name/哈哈/i_phone/18764117706/i_car_card/冀M12345/endtime/2017-12-29
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf performSelector:@selector(backAction) withObject:nil afterDelay:3.0];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)phoneBtnAction
{
    [Utility phoneCallAction];
}
- (void)hiddenView {
    
    if (_datePickV) {
        [_datePickV removeFromSuperview];
        _datePickV = nil;
    }
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
}
#pragma mark ZQVioUpTableViewCellDelegate
-(void)showChooseView {
    [self.view endEditing:YES];
    [self hiddenView];
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:[Utility getProvinceShortNum] inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                strongSelf.shortNumStr = selectedStr;
                [strongSelf.tableView reloadData];
            }
        }
    }];
    
}
#pragma mark ==YBuyingDatePickerDelegate==
-(void)chooseDateTime:(NSString *)sender{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *coms = [NSDate dateWithTimeIntervalSince1970:[sender integerValue]];
    self.endTime =[formatter stringFromDate:coms];
    [self.tableView reloadData];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //    self.tableView.reloadData;
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 2) {
        //            self.endTime = textField.text;
        [self.view endEditing:YES];
        [self hiddenView];
        [self.view addSubview:self.datePickV];
        return NO;
    }
    [self hiddenView];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
        {
            self.i_name = textField.text;
            break;
        }
        case 1:
        {
            self.i_phone = textField.text;
        }
            break;
        case 3:
        {
            self.i_car_card = textField.text;
        }
            break;
        default:
            break;
    }
    return YES;
}
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
    ZqCellType type;
    if (indexPath.row==(_titleArray.count-1)) {
        type = ZQVioUpCellType1;
    }
    else
    {
        type = ZQVioUpCellType2;
    }
    cell.contentTf.delegate = self;
    cell.contentTf.tag = indexPath.row;
    switch (indexPath.row) {
        case 1:
            cell.contentTf.text = self.i_phone;
            break;
        case 2:
            cell.contentTf.text = self.endTime;
            break;
        default:
            break;
    }
    
    //        cell.contentTf.text = _contentArray[indexPath.row];
    cell.delegate = self;
    NSString *title = _titleArray[indexPath.row];
    cell.contentTf.tag = indexPath.row;
    [cell setCellType:type title:title placeText:_placeArray[indexPath.row] provinceCode:self.shortNumStr];
    return cell;
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(ZQChoosePickerView *)pickView {
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
}
-(YBuyingDatePicker *)datePickV{
    if (!_datePickV) {
        _datePickV = [[YBuyingDatePicker alloc]initWithFrame:CGRectMake(0, __kHeight-260, __kWidth, 260)];
        _datePickV.delegate = self;
    }
    return _datePickV;
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
