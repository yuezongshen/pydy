//
//  ZQUpVioViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/31.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQUpVioViewController.h"
#import "YBuyingDatePicker.h"
#import "ZQChoosePickerView.h"
#import "ZQDeclarationCell.h"
#import "ZQPersonInfoCell.h"

#import "NSString+Validation.h"
#import "ZQUpPhotoController.h"
#import "UITextField+ZQProTextField.h"
#import "UIImageView+WebCache.h"
#import "ZQVoiceRecordController.h"
#import "ZQNewMyViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface ZQUpVioViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,YBuyingDatePickerDelegate>{
    NSArray        *_titleArray;
    NSArray        *_placeholderArr;
}

@property (strong, nonatomic) UITableView          *tableView;
@property (strong, nonatomic) YBuyingDatePicker    *datePickV;
@property (strong, nonatomic) ZQChoosePickerView   *pickView;
@property (copy,   nonatomic) NSString             *sayString;
@property (strong, nonatomic) NSMutableArray       *contentArray;
@property (strong, nonatomic) UIImage *chooseImage;
@end

@implementation ZQUpVioViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"完善个人信息";
    [self setupData];
    [self initViews];
}
- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    }
    return _contentArray;
}
-(void)setupData {
    _titleArray = @[@"上传证件照",@"姓名",@"性别",@"生日",@"籍贯",@"从业时间",@"联系电话",@"上传语音",@"上传生活照",@"导游宣言"];
    _placeholderArr = @[@"未上传",@"请填写用户名",@"请填写性别(男/女)",@"请填写生日(HHHH:MM:DD格式)",@"山西省平遥古城",@"2016年5月",@"请填写联系方式",@"未上传",@"未上传"];
    
    
//        UIImageJPEGRepresentation(_chooseImage, 0.5)
        __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"appuser/userinfo" withParameters:@{@"guide_id":[Utility getUserID]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSDictionary *dic = jsonDic[@"data"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                __strong typeof(self) strongSelf = weakSelf;
                NSString *voice = dic[@"guide_voice"];
                if ([voice isKindOfClass:[NSString class]]) {
                    if (voice.length) {
                        _placeholderArr = @[@"未上传",@"请填写用户名",@"请填写性别(男/女)",@"请填写生日(HHHH:MM:DD格式)",@"山西省平遥古城",@"2016年5月",@"请填写联系方式",@"已上传",@"已上传"];
                    }
                }
                NSArray *lift_img = dic[@"life_img"];
                if ([lift_img isKindOfClass:[NSArray class]]) {
                    if (lift_img.count) {
                        _placeholderArr = @[@"未上传",@"请填写用户名",@"请填写性别(男/女)",@"请填写生日(HHHH:MM:DD格式)",@"山西省平遥古城",@"2016年5月",@"请填写联系方式",@"已上传",@"已上传"];
                    }
                }
                NSString *sex = dic[@"sex"];
                if (![sex isEqualToString:@"男"]&&![sex isEqualToString:@"女"]) {
                    if (sex.integerValue==1) {
                        sex = @"男";
                    }
                    else
                    {
                        sex = @"女";
                    }
                }
                strongSelf.contentArray = [NSMutableArray arrayWithArray:@[dic[@"certificate_img"],dic[@"name"],sex,dic[@"birthday"],dic[@"native_place"],dic[@"work_time"],dic[@"phone"],dic[@"guide_voice"],dic[@"life_img"],dic[@"autograph"]]];
                [strongSelf.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}

-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
}

-(void)initViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 100)];
    bottomV.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:bottomV];
    _tableView.tableFooterView = bottomV;
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,20, CGRectGetWidth(_tableView.frame)-40, 40)];
    _putBtn.backgroundColor = HEXCOLOR(0xbc2c29);
    _putBtn.titleLabel.font = MFont(18);
    [_putBtn setTitle:@"确认修改" forState:BtnNormal];
    [_putBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [_putBtn addTarget:self action:@selector(saveInfoAction) forControlEvents:BtnTouchUpInside];
    [bottomV addSubview:_putBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_putBtn.frame), CGRectGetWidth(_tableView.frame), 20)];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [bottomV addSubview:label];
    
    NSString *totalStr = @"*为必填项";
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[totalStr rangeOfString:@"为必填项"]];
    [attri addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xbc2c29) range:[totalStr rangeOfString:@"*"]];
    [label setAttributedText:attri];

}
- (void)saveInfoAction
{
    [self.view endEditing:YES];
    NSString *ticketNumStr = _contentArray[1];
    if (!ticketNumStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入用户名" duration:SXLoadingTime];
        return;
    }
    NSString *carCodeStr = _contentArray[4];
    if (!carCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入籍贯" duration:SXLoadingTime];
        return;
    }
   
    NSString *phoneStr = _contentArray[6];
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
    NSString *imgStr = @"";
    if (_chooseImage) {
      imgStr = [[self imageData:_chooseImage] base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    }
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    NSString *sexStr = @"1";
    if ([_contentArray[2] isEqualToString:@"女"]) {
        sexStr = @"0";
    }
    [JKHttpRequestService POST:@"appuser/personinfo" withParameters:@{@"guide_id":[Utility getUserID],@"name":ticketNumStr,@"sex":sexStr,@"birthday":_contentArray[3],@"native_place":carCodeStr,@"work_time":_contentArray[5],@"phone":phoneStr,@"autograph":_contentArray[9],@"user_header":imgStr} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
            [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLoginNotication object:nil];
            if (strongSelf)
            {
                [strongSelf performSelector:@selector(backAc) withObject:nil afterDelay:SXLoadingTime];
            }
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        
    } animated:NO];

//    __weak typeof(self) weakSelf = self;
//    [JKHttpRequestService POST:@"appuser/personinfo" Params:@{@"guide_id":@"92",@"name":ticketNumStr,@"sex":_contentArray[2],@"birthday":_contentArray[3],@"native_place":carCodeStr,@"work_time":_contentArray[5],@"phone":phoneStr,@"autograph":_contentArray[9]} NSData:[self imageData:_chooseImage] key:@"user_header" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        [ZQLoadingView hideProgressHUD];
//        __strong typeof(self) strongSelf = weakSelf;
//        if (succe) {
//            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
//            if (strongSelf)
//            {
//                [strongSelf performSelector:@selector(backAc) withObject:nil afterDelay:SXLoadingTime];
//            }
//        }
//    } failure:^(NSError *error) {
//        [ZQLoadingView hideProgressHUD];
//
//    } animated:NO];
}
- (void)backAc
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ==YBuyingDatePickerDelegate==
-(void)chooseDateTime:(NSString *)sender{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd"];
    NSDate *coms = [NSDate dateWithTimeIntervalSince1970:[sender integerValue]];
    NSString *dates =[formatter stringFromDate:coms];
    
    _contentArray[3] = dates;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)hiddenView {
    if (_datePickV) {
        [self.datePickV removeFromSuperview];
        self.datePickV = nil;
    }
    if (_pickView) {
        [self.pickView removeFromSuperview];
        self.pickView = nil;
    }
}

#pragma mark ZQVioUpTableViewCellDelegate
-(void)showChooseView {
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:@[@"男",@"女"] inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                strongSelf.contentArray[2] = selectedStr;
                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }];
//    __weak typeof(self) weakSelf = self;
//    [self.pickView showWithDataArray:[Utility getProvinceShortNum] inView:self.view chooseBackBlock:^(NSString *selectedStr) {
//        __strong typeof(self) strongSelf = weakSelf;
//        if (strongSelf) {
//            if (selectedStr) {
////                strongSelf.shortNumString = selectedStr;
////                [strongSelf.tableView reloadData];
//            }
//        }
//    }];
    
}


#pragma mark YSureOrderBottomViewDelegate
// 提交订单
-(void)putOrder {
    
    NSString *punishDateStr = [_contentArray[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!punishDateStr.length) {
        [ZQLoadingView showAlertHUD:@"请选择日期" duration:SXLoadingTime];
        return;
    }
  
    //代缴罚款接口
//    NSString *urlStr = nil;
//    [NSString stringWithFormat:@"daf/payment_of_fines/u_id/%@/ticket_number/%@/car_card/%@/fine_money/%@/fine_date/%@/phone/%@",[Utility getUserID],ticketNumStr,carCodeStr,punishMoneyStr,punishDateStr,phoneStr];
//    UIImageJPEGRepresentation(_chooseImage, 0.5)
//    __weak typeof(self) weakSelf = self;
//    [JKHttpRequestService POST:urlStr Params:nil NSData:[self imageData:_chooseImage] key:@"pic_path" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        if (succe) {
//            __strong typeof(self) strongSelf = weakSelf;
//            if (strongSelf)
//            {
//                YPayViewController *payVC = [[YPayViewController alloc] init];
//                payVC.payMoney = [NSString stringWithFormat:@"%@",jsonDic[@"total"]];
//                payVC.orderNo = jsonDic[@"order_no"];
//                payVC.aPayType = ZQPayAFineView;
//                [strongSelf.navigationController pushViewController:payVC animated:YES];
//            }
//        }
//    } failure:^(NSError *error) {
//
//    } animated:YES];
}

#pragma mark ==UITextFiledDelegate==

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hiddenView];

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _contentArray[textField.tag] = textField.text;
   
    return YES;
}

#pragma mark UITableViewDataSource,UITableViewDelegate
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return _titleArray.count;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==_titleArray.count-1) {
        ZQDeclarationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQDeclarationCell"];
        if (!cell) {
            cell = [[ZQDeclarationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZQDeclarationCell"];
            __weak __typeof(self)weakSelf = self;
            cell.dTextBack = ^(NSString *sayStr) {
                __strong typeof(self) strongSelf = weakSelf;
                strongSelf.contentArray[_titleArray.count-1] = sayStr;
//                [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_titleArray.count  inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            };
        }
        [cell configTextFeildText:_contentArray[indexPath.row]];
        return cell;
    }
    NSInteger showType = [self showTFCondition:indexPath];
    if (showType) {
        ZQPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQPersonInfoCell"];
        if (!cell) {
            cell = [[ZQPersonInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZQPersonInfoCell"];
            cell.detailTF.delegate = self;
        }
        if (showType==1) {
            [cell setTitle:_titleArray[indexPath.row] attributedString:@"*" placeholderText:_placeholderArr[indexPath.row]];
        }
        else
        {
             [cell setTitle:_titleArray[indexPath.row] placeholderText:_placeholderArr[indexPath.row]];
        }
        cell.detailTF.tag = indexPath.row;
        [cell.detailTF setText:_contentArray[indexPath.row]];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_person_info"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell_person_info"];
        cell.textLabel.textColor = __TestOColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = __TestGColor;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    if (indexPath.row==0) {
        if (_chooseImage) {
            cell.detailTextLabel.text = nil;
            UIImageView *hImagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            hImagev.layer.cornerRadius = 20;
            hImagev.layer.masksToBounds = YES;
            cell.accessoryView = hImagev;
            [hImagev setImage:_chooseImage];
        }
       else
       {
           NSString *str = _contentArray[indexPath.row];
           if ([str isKindOfClass:[NSString class]]) {
               if (str.length) {
                   if ([str rangeOfString:@"http"].location == NSNotFound) {
                       str = [NSString stringWithFormat:@"%@%@",ImageBaseAPI,str];
                   }
                   cell.detailTextLabel.text = nil;
                   UIImageView *hImagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                   hImagev.layer.cornerRadius = 20;
                   hImagev.layer.masksToBounds = YES;
                   cell.accessoryView = hImagev;
                   [hImagev sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"user_head"]];
               }
               else
               {
                   cell.detailTextLabel.text = _placeholderArr[indexPath.row];
               }
           }
           else{
               cell.detailTextLabel.text = _placeholderArr[indexPath.row];
           }
       }
    }
    else
    {
        if ([self showContentDetail:indexPath]) {
            NSString *str = _contentArray[indexPath.row];
            if ([str isKindOfClass:[NSString class]]) {
                if (str.length) {
                    cell.detailTextLabel.text = str;
                }
                else
                {
                    cell.detailTextLabel.text = _placeholderArr[indexPath.row];
                }
            }
            else
            {
                cell.detailTextLabel.text = _placeholderArr[indexPath.row];
            }
        }
        else
        {
            cell.detailTextLabel.text = _placeholderArr[indexPath.row];
        }
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self hiddenView];
   
    switch (indexPath.row) {
        case 0:
        {
            [self chooseImageAction];
            break;
        }
        case 2:
        {
            [self.view endEditing:YES];
            [self showChooseView];
        }
            break;
        case 3:
        {
            [self.view endEditing:YES];
            [self.view addSubview:self.datePickV];
        }
            break;
        case 7:
        {
            [self uploadVoiceData];
        }
            break;
        case 8:
        {
            NSArray *imageArr = self.contentArray[8];
            if ([imageArr isKindOfClass:[NSArray class]]) {
                if (!imageArr.count) {
                    imageArr = nil;
                }
            }
            else
            {
                imageArr = nil;
            }
            ZQUpPhotoController *upVc = [[ZQUpPhotoController alloc] initWithUrls:imageArr];
            [self.navigationController pushViewController:upVc animated:YES];
        }
            break;
            
        default:
            break;
    }
//    switch (indexPath.section) {
//        case 0:
//        {
//            switch (indexPath.row) {
//                case 3:
//                    {
//                        [self.view endEditing:YES];
//                        [self.view addSubview:self.datePickV];
//                    }
//                    break;
//
//                default:
//                    break;
//            }
//        }
//            break;
//         case 3:
//        {
//
//        }
//            break;
//
//        default:
//            break;
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==_titleArray.count-1)
        return 100;
    return 50;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
   
        return 0.1;
}
- (BOOL)showContentDetail:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
        case 3:
            return YES;
            break;
            
        default:
            break;
    }
    return NO;
}
- (NSInteger)showTFCondition:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        case 4:
        case 6:
        {
            return 1;
        }
//        case 2:
//        case 3:
        case 5:
        {
            return 2;
        }
            break;
        default:
            return 0;
            break;
    }
}
-(void)chooseImageAction {
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerVC.allowsEditing = YES;
        (void)(pickerVC.videoQuality = UIImagePickerControllerQualityTypeLow),           // 最低的质量,适合通过蜂窝网络传输
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        //想要知道选择的图片
        pickerVC.delegate = self;
        //开启编辑状态
        pickerVC.allowsEditing = YES;
        (void)(pickerVC.videoQuality = UIImagePickerControllerQualityTypeLow),           // 最低的质量,适合通过蜂窝网络传输
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheetController addAction:cameraAction];
    [actionSheetController addAction:albumAction];
    [actionSheetController addAction:cancelAction];
    [self presentViewController:actionSheetController animated:YES completion:nil];
//    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
//    //想要知道选择的图片
//    pickerVC.delegate = self;
//    //开启编辑状态
//    pickerVC.allowsEditing = YES;
//    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//    [self.imgView setImage:info[UIImagePickerControllerOriginalImage]];
//    _chooseImage = info[UIImagePickerControllerOriginalImage];
    _chooseImage = info[UIImagePickerControllerEditedImage];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 私有方法
-(YBuyingDatePicker *)datePickV{
    if (!_datePickV) {
        _datePickV = [[YBuyingDatePicker alloc]initWithFrame:CGRectMake(0, __kHeight-260, __kWidth, 260)];
//        _datePickV.limitDate = YES;
        _datePickV.delegate = self;
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
- (void)uploadVoiceData
{
    ZQVoiceRecordController *test = [[ZQVoiceRecordController alloc] init];
    __weak typeof(self) weakSelf = self;

    test.updateRecordUrl = ^(NSString *urlStr) {
        __strong typeof(self) strongSelf = weakSelf;
         ZQNewMyViewController *newMyVc = (ZQNewMyViewController *)strongSelf.mm_drawerController.leftDrawerViewController;
        [newMyVc changeAudioUrl:urlStr];
    };
    self.definesPresentationContext = YES;
    test.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    test.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:test animated:NO completion:nil];
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
