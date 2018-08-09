//
//  ZQUpSubdataViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQUpSubdataViewController.h"
#import "ZQSubTimeViewController.h"
#import "UITextField+ZQTextField.h"
#import "ZQChoosePickerView.h"
#import "YBuyingDatePicker.h"
#import "ZQProCityView.h"
#import "ZQHtmlViewController.h"
//#import "ZQUpDataModel.h"
#import <Masonry.h>
#import "NSString+Validation.h"

@interface ZQUpSubdataViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextFieldDelegate,YBuyingDatePickerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeight;
@property (weak, nonatomic) IBOutlet UITextField  *nameTf;
@property (weak, nonatomic) IBOutlet UITextField  *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField  *carCodeTf;
@property (weak, nonatomic) IBOutlet UITextField  *carShapeTf;
@property (weak, nonatomic) IBOutlet UIImageView  *imageView;
@property (weak, nonatomic) IBOutlet UIImageView  *carFrontImg;
@property (weak, nonatomic) IBOutlet UIImageView  *carBackImg;
@property (weak, nonatomic) IBOutlet UIImageView  *insuranceImg;
@property (weak, nonatomic) IBOutlet UIScrollView *scollView;
@property (weak, nonatomic) IBOutlet UIButton     *ensureBtn;
@property (weak, nonatomic) IBOutlet UILabel      *proNumLabel;
@property (weak, nonatomic) IBOutlet UITextField  *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *visitTextField;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *visitLabel;
@property (weak, nonatomic) IBOutlet UILabel *carTypelabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceDateL;
@property (strong, nonatomic) ZQChoosePickerView  *pickView;
@property (strong, nonatomic) YBuyingDatePicker   *datePickV;
@property (strong, nonatomic) ZQProCityView       *proCityView;
@property (copy, nonatomic)   NSString            *shortNumString;

@property (strong, nonatomic) UIImageView        *tempImgView;
@property (strong, nonatomic) NSArray            *carTypeArray;

@property (strong, nonatomic) NSArray            *carMoneyArray;
@property (copy, nonatomic)   NSString           *carMoneStr;
@end

@implementation ZQUpSubdataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传预约资料";
    self.shortNumString = @"冀";
    [self setupViews];
    [self getCarTypeData];
}
-(void)setupViews {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView.image = [UIImage imageNamed:@"down2"];
    self.carShapeTf.rightView = imageView;
    self.carShapeTf.rightViewMode = UITextFieldViewModeAlways;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    imageView.image = [UIImage imageNamed:@"down2"];
    self.dateTextField.rightView = imageView;
    self.dateTextField.rightViewMode = UITextFieldViewModeAlways;
    
    if (self.bookingType==1) {
//        在线
        [self.carTypelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateTextField.mas_bottom).offset(15);
        }];
        [self.visitTextField setHidden:YES];
        [self.visitLabel setHidden:YES];
        [self.detailTextField setHidden:YES];
        [self.detailLabel setHidden:YES];
    }
    else
    {
        //上门
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"down2"];
        self.visitTextField.rightView = imageView;
        self.visitTextField.rightViewMode = UITextFieldViewModeAlways;
    }
   
    

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction:)];
    [self.imageView addGestureRecognizer:tap1];
    [self.carFrontImg addGestureRecognizer:tap2];
    [self.carBackImg addGestureRecognizer:tap3];
    [self.insuranceImg addGestureRecognizer:tap4];
    
    self.imageView.userInteractionEnabled = YES;
    self.carFrontImg.userInteractionEnabled = YES;
    self.carBackImg.userInteractionEnabled = YES;
    self.insuranceImg.userInteractionEnabled = YES;
    self.carCodeTf.keyboardType = UIKeyboardTypeASCIICapable;
    self.carCodeTf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.phoneTf.text = [Utility getUserPhone];
}

- (void)getCarTypeData
{
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"daf/get_car_type" withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"res"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:0];
                        NSMutableArray *moneyArr = [NSMutableArray arrayWithCapacity:0];
                        for (NSDictionary *dic in array) {
                            [muArray addObject:[NSString stringWithFormat:@"%@%@元",dic[@"car_name"],dic[@"money"]]];
                            [moneyArr addObject:dic[@"money"]];
                        }
                        strongSelf.carTypeArray = muArray;
                        strongSelf.carMoneyArray = moneyArr;
//                        strongSelf.carTypeArray = [ZQUpDataModel mj_objectArrayWithKeyValuesArray:array];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        
    } animated:NO];
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
    if (_proCityView) {
        [_proCityView removeFromSuperview];
        _proCityView = nil;
    }
}
-(YBuyingDatePicker *)datePickV{
    if (!_datePickV) {
        _datePickV = [[YBuyingDatePicker alloc]initWithFrame:CGRectMake(0, __kHeight-260, __kWidth, 260)];
        _datePickV.delegate = self;
    }
    return _datePickV;
}

-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, __kHeight - 200, KWidth, 200)];
    }
    return _pickView;
}
- (ZQProCityView *)proCityView
{
    if (!_proCityView) {
        _proCityView = [[ZQProCityView alloc] initWithFrame:CGRectMake(0, __kHeight-200, __kWidth, 200)];
        __weak typeof(self) weakSelf = self;
        _proCityView.handler = ^(NSString *proCityStr) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                if (proCityStr) {
                    [strongSelf.visitTextField setText:proCityStr];
                }
            }
        };
    }
    return _proCityView;
}
-(void)viewWillLayoutSubviews {
    self.contentSizeHeight.constant = 647+330+135;
    self.contentSizeWidth.constant = KWidth;
    self.scollView.contentSize = CGSizeMake(KWidth, 647+330+135);
}

- (IBAction)sendAction:(id)sender {
    NSString *carOwner = [self.nameTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!carOwner.length) {
        [ZQLoadingView showAlertHUD:@"请输入机动车所有人" duration:SXLoadingTime];
        return;
    }
    NSString *phoneStr = [self.phoneTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (phoneStr.length) {
        if (![phoneStr isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:SXLoadingTime];
        return;
    }
    NSString *carCodeStr = [self.carCodeTf.text trimDoneString];
    if (carCodeStr.length!=6) {
        [ZQLoadingView showAlertHUD:@"请输入正确车牌号码" duration:SXLoadingTime];
        return;
    }
    carCodeStr = [NSString stringWithFormat:@"%@%@",self.shortNumString,carCodeStr];
    NSString *dateInsurance = self.dateTextField.text;
    if (!dateInsurance) {
        [ZQLoadingView showAlertHUD:@"请选择保险到期日" duration:SXLoadingTime];
        return;
    }
    NSString *carShapeStr = self.carShapeTf.text;
    if (!carShapeStr.length) {
        [ZQLoadingView showAlertHUD:@"请选择车型" duration:SXLoadingTime];
        return;
    }
    UIImage *licenseImage = self.imageView.image;
    if ([licenseImage isEqual:[UIImage imageNamed:@"guarantee"]]) {
//        [ZQLoadingView showAlertHUD:@"请选择行驶本照片" duration:SXLoadingTime];
        [ZQLoadingView showAlertHUD:@"请上传交强险保单(副本)" duration:SXLoadingTime];
        return;
    }
    UIImage *frontImage = self.carFrontImg.image;
    if ([frontImage isEqual:[UIImage imageNamed:@"drivingLicense0"]]) {
//        [ZQLoadingView showAlertHUD:@"请选择身份证正面照片" duration:SXLoadingTime];
        [ZQLoadingView showAlertHUD:@"请上传行驶本(正本)" duration:SXLoadingTime];
        return;
    }
    UIImage *backImage = self.carBackImg.image;
    if ([backImage isEqual:[UIImage imageNamed:@"drivingLicense"]]) {
        [ZQLoadingView showAlertHUD:@"请上传行驶本(副本)" duration:SXLoadingTime];
        return;
    }
    UIImage *insuranceImg = self.insuranceImg.image;
    if ([insuranceImg isEqual:[UIImage imageNamed:@"carLicense"]]) {
        [ZQLoadingView showAlertHUD:@"请上传行驶证车辆照片" duration:SXLoadingTime];
        return;
    }
    
    NSString *moneyStr = @"0";
    if (self.carMoneStr.floatValue) {
        moneyStr = self.carMoneStr;
    }
//    if (self.carShapeTf.text) {
//        if (self.carShapeTf.text.length) {
//            moneyStr = [[self.carShapeTf.text componentsSeparatedByString:@"-"] lastObject];
//            moneyStr = [[moneyStr substringToIndex:moneyStr.length-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        }
//    }
    //上传预约资料接口
    NSString *urlStr = nil;
    if (self.bookingType==1) {
        //在线
      urlStr = [NSString stringWithFormat:@"daf/file_upload/u_id/%@/u_name/%@/u_phone/%@/u_car_card/%@/u_car_type/%@/testing_id/%@/type/%ld/inspection_fee/%@/service_charge/%.0f/insurance/%@",[Utility getUserID],carOwner,phoneStr,carCodeStr,carShapeStr,self.b_testing_id,(long)self.bookingType,moneyStr,_serviceCharge,dateInsurance];
    }
    else
    {
//        上门
        NSString *visitStr = self.visitTextField.text;
        if (!visitStr) {
            [ZQLoadingView showAlertHUD:@"请选择上门地址" duration:SXLoadingTime];
            return;
        }
        NSString *detailStr = self.detailTextField.text;
        if (!detailStr) {
            [ZQLoadingView showAlertHUD:@"请输入详细地址" duration:SXLoadingTime];
            return;
        }
        visitStr = [NSString stringWithFormat:@"%@%@",visitStr,detailStr];
      urlStr = [NSString stringWithFormat:@"daf/file_upload/u_id/%@/u_name/%@/u_phone/%@/u_car_card/%@/u_car_type/%@/testing_id/%@/type/%ld/inspection_fee/%@/service_charge/%.0f/insurance/%@/saddress/%@",[Utility getUserID],carOwner,phoneStr,carCodeStr,carShapeStr,self.b_testing_id,(long)self.bookingType,moneyStr,_serviceCharge,dateInsurance,visitStr];
    }
    
//    NSArray *imageArr = @[UIImageJPEGRepresentation(licenseImage, 0.5),UIImageJPEGRepresentation(frontImage, 0.5),UIImageJPEGRepresentation(backImage, 0.5),UIImageJPEGRepresentation(insuranceImg, 0.5)];
    ZQSubTimeViewController *subVC = [[ZQSubTimeViewController alloc] initWithNibName:@"ZQSubTimeViewController" bundle:nil];
    subVC.requestUrl = urlStr;
//    subVC.uploadImageArr = imageArr;
//    subVC.uploadImageArr = @[UIImageJPEGRepresentation(licenseImage, 0.5),UIImageJPEGRepresentation(frontImage, 0.5),UIImageJPEGRepresentation(backImage, 0.5),UIImageJPEGRepresentation(insuranceImg, 0.5)];
    subVC.uploadImageArr = @[[self imageData:licenseImage],[self imageData:frontImage],[self imageData:backImage],[self imageData:insuranceImg]];

    if (self.serviceCharge>0) {
        subVC.serviceChargeMoney = _serviceCharge;
    }
    subVC.costMoney = moneyStr;
    subVC.time_tes_id = self.b_testing_id;
    [self.navigationController pushViewController:subVC animated:YES];
}
#pragma mark ==YBuyingDatePickerDelegate==
-(void)chooseDateTime:(NSString *)sender{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *coms = [NSDate dateWithTimeIntervalSince1970:[sender integerValue]];
    NSString *dates =[formatter stringFromDate:coms];
    [self.dateTextField setText:dates];
}
#pragma mark 私有方法

-(void)chooseImageAction:(UITapGestureRecognizer *)sender {
    
    _tempImgView = (UIImageView *)sender.view;
    
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.tabBarController presentViewController:pickerVC animated:YES completion:nil];
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
    
    /*
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    //想要知道选择的图片
    pickerVC.delegate = self;
    //开启编辑状态
    pickerVC.allowsEditing = YES;
    (void)(pickerVC.videoQuality = UIImagePickerControllerQualityTypeLow),           // 最低的质量,适合通过蜂窝网络传输
    [self presentViewController:pickerVC animated:YES completion:nil];
    */
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//    NSLog(@"%@",info);
//    [_tempImgView setImage:info[UIImagePickerControllerOriginalImage]];
    
    [_tempImgView setImage:info[UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.carShapeTf) {
        [self showChooseCarshapeView];
        return NO;
    }
    else if (textField == self.dateTextField) {
        [self.view endEditing:YES];
        [self hiddenView];
        [self.view addSubview:self.datePickV];
        return NO;
    }
    else if (textField == self.visitTextField)
    {
        [self.view endEditing:YES];
        [self hiddenView];
        [self.view addSubview:self.proCityView];
        return NO;
    }
    else{
        [self hiddenView];
        return YES;
    }
}

-(void)showChooseCarshapeView {
    [self.view endEditing:YES];
    [self hiddenView];
    if (self.carTypeArray) {
        if (self.carTypeArray.count) {
            __weak typeof(self) weakSelf = self;
            [self.pickView showDataArray:self.carTypeArray inView:self.view chooseBackBlock:^(NSInteger seletedIndex) {
                __strong typeof(self) strongSelf = weakSelf;
                if (strongSelf) {
                    strongSelf.carShapeTf.text = strongSelf.carTypeArray[seletedIndex];
                    strongSelf.carMoneStr = strongSelf.carMoneyArray[seletedIndex];
                }
            }];
//            [self.pickView showWithDataArray:self.carTypeArray inView:self.view chooseBackBlock:^(NSString *seletedStr) {
//                __strong typeof(self) strongSelf = weakSelf;
//                if (strongSelf) {
//                    if (seletedStr) {
//                        strongSelf.carShapeTf.text = seletedStr;
//                    }
//                }
//            }];
        }
    }
    else
    {
        [self getCarTypeData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [textField resignFirstResponder];
    
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}
- (IBAction)showProNumBtnAction:(id)sender {
    [self hiddenView];
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:[Utility getProvinceShortNum] inView:self.view chooseBackBlock:^(NSString *selectedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (selectedStr) {
                strongSelf.shortNumString = selectedStr;
                strongSelf.proNumLabel.text = selectedStr;
            }
        }
    }];
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    for (UITouch *touch in touches) {
//        NSLog(@"--------%@",NSStringFromCGPoint([touch locationInView:self.scollView]));
//    }
//    NSLog(@"+++++++++%@",NSStringFromCGRect(self.ensureBtn.frame));
//
//}

//-(void)back{
//    UIViewController *htmlVc = self.navigationController.viewControllers[1];
//    if ([htmlVc isKindOfClass:[ZQHtmlViewController class]]) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

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
