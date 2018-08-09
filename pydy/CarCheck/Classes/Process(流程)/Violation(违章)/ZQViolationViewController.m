//
//  ZQViolationViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQViolationViewController.h"
#import "ZQAreaView.h"
#import "ZQAreaModel.h"
#import "ZQLoadingView.h"
#import "ZQChoosePickerView.h"

#import "ZQProCityPickerV.h"

#import "ZQProvinceModel.h"
#import "ZQCityModel.h"

#import "ZQVioResultView.h"
#import "NSString+Validation.h"

@interface ZQViolationViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityCode;
@property (weak, nonatomic) IBOutlet UITextField *carCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *engineNewTf;
@property (weak, nonatomic) IBOutlet UIButton *carTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *engineCodeTf;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn1;
@property (weak, nonatomic) IBOutlet UITextField *cardCodeTf;
@property (weak, nonatomic) IBOutlet UITextField *driveCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn2;
@property (weak, nonatomic) IBOutlet UIScrollView *scollView;

@property (nonatomic, strong) ZQAreaView *areaView;
@property (nonatomic, strong) ZQAreaModel *provinceModel;

@property (strong, nonatomic) ZQChoosePickerView *pickView;
@property (strong, nonatomic) ZQProCityPickerV *proCityPickerV;
@property (strong, nonatomic) NSArray *provinceArray;

@property (strong, nonatomic) ZQCityModel *aCityModel;
@end

@implementation ZQViolationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

-(void)viewDidLayoutSubviews {
    self.scollView.contentSize = CGSizeMake(KWidth, 677);
}

-(void)setupViews {
    
    self.title = @"违章查询";
    self.searchBtn1.layer.cornerRadius = 5;
    self.searchBtn2.layer.cornerRadius = 5;
    self.carCodeTf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.engineNewTf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.engineCodeTf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    UIImage *image = [UIImage imageNamed:@"downArrow"];
    [self.provinceBtn setImage:image forState:UIControlStateNormal];
    self.provinceBtn.layer.borderWidth = 1;
    self.provinceBtn.layer.cornerRadius = 4;
    [self.provinceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [self.provinceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
    
    [self.cityCode setImage:image forState:UIControlStateNormal];
    self.cityCode.layer.borderWidth = 1;
    self.cityCode.layer.cornerRadius = 4;
    [self.cityCode setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [self.cityCode setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
    
    self.carTypeBtn.layer.borderWidth = 1;
    self.carTypeBtn.layer.cornerRadius = 4;
    [self.carTypeBtn setImage:image forState:UIControlStateNormal];
    [self.carTypeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [self.carTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, -65)];
    
    [self getProvinceListData];
}
- (void)getProvinceListData
{
//获取可用城市接口接口
__weak typeof(self) weakSelf = self;
[JKHttpRequestService POST:@"daf/get_support_city" withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
     if ([jsonDic[@"resultcode"] integerValue] == 200)
    {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            strongSelf.provinceArray = [ZQProvinceModel mj_objectArrayWithKeyValuesArray:jsonDic[@"result"]];
            ZQCityModel *cityModel = [[ZQCityModel alloc] init];
            cityModel.city_code = @"HB_SJZ";
            strongSelf.aCityModel = cityModel;
        }
    }
} failure:^(NSError *error) {

} animated:NO];
}
//机动车违法信息查询
- (IBAction)vehicleAgainstTheLow:(id)sender {
//    NSDictionary *dic = @{@"date":@"2013-12-29 11:57:29",@"area":@"316省道53KM+200M",@"act":@"16362 : 驾驶中型以上载客载货汽车、校车、危险物品运输车辆以外的其他机动车在高速公路以外的道路上行驶超过规定时速20%以上未达50%的",@"fen":@"6",@"money":@"100"};
//    [self showvehicleAgainstResult:dic];
//    return;
    [self.view endEditing:YES];
    NSString *carCodeStr = [self.carCodeTf.text trimDoneString];
    if (carCodeStr.length !=6) {
        [ZQLoadingView showAlertHUD:@"请输入正确车牌号码" duration:SXLoadingTime];
        return;
    }
    carCodeStr = [NSString stringWithFormat:@"%@%@%@",self.provinceBtn.titleLabel.text,self.cityCode.titleLabel.text,carCodeStr];

    NSString *engineCodeStr = [self.engineCodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!engineCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入车辆识别码" duration:SXLoadingTime];
        return;
    }
    NSString *engineNewStr = [self.engineNewTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!engineNewStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入发动机号" duration:SXLoadingTime];
        return;
    }
    
//    $city= I ( "request.city", 'HB_SJZ');//城市编码
//    $hphm= I ( "request.hphm", '冀AL198S');//车牌号
//    $classno= I ( "request.classno", 'LFV2B25G6E5160018');//车辆识别码
//    $engineno= I ( "request.engineno", 'H14621');//    发动机号
    //机动车违法信息查询接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_violation_inquiry/city/%@/hphm/%@/classno/%@/engineno/%@",self.aCityModel.city_code,carCodeStr,engineCodeStr,engineNewStr];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            NSArray *array = jsonDic[@"lists"];
            if ([array isKindOfClass:[NSArray class]]) {
                if (array.count > 0) {
                    [strongSelf showvehicleAgainstResult:jsonDic];
                    return ;
                }
            }
            [ZQLoadingView showAlertHUD:@"无违章记录" duration:SXLoadingTime];
        }
    } failure:^(NSError *error) {
        
    } animated:YES];

}
- (void)showvehicleAgainstResult:(NSDictionary *)dic
{
    ZQVioResultView *alerView = [[ZQVioResultView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    alerView.contentDic = dic;
    [alerView show];
}
//驾驶证违法信息查询
- (IBAction)licenseAgainstTheLow:(id)sender {
    [self.view endEditing:YES];
    NSString *provinceStr = self.carTypeBtn.titleLabel.text;
    if ([provinceStr isEqualToString:@"请选择省"]) {
        [ZQLoadingView showAlertHUD:@"请选择省份" duration:SXLoadingTime];
        return;
    }
    if ([provinceStr rangeOfString:@"省"].location != NSNotFound || [provinceStr rangeOfString:@"市"].location != NSNotFound) {
        provinceStr = [provinceStr substringToIndex:provinceStr.length-1];
    }
    NSString *cardCodeStr = [self.cardCodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!cardCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入驾照号" duration:SXLoadingTime];
        return;
    }
    NSString *driveCodeStr = [self.driveCodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!driveCodeStr.length) {
        [ZQLoadingView showAlertHUD:@"请输入驾驶证档案编号" duration:SXLoadingTime];
        return;
    }
    //驾驶证违法信息查询get_driver_license
//    $province = I ( "request.province", 山西);//省份
//    $driving_license = I ( "request.driving_license", 142724199309090511);//驾照
//    $file_number = I ( "request.file_number", 142700883624);//驾照编号
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_driver_license/province/%@/driving_license/%@/file_number/%@/",provinceStr,cardCodeStr,driveCodeStr];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
            NSString *ss = jsonDic[@"reason"];
            if ([ss isEqualToString:@"success"]) {
                NSInteger rr = [jsonDic[@"result"] integerValue];
                if (rr >0) {
                    [ZQLoadingView showAlertHUD:[NSString stringWithFormat:@"扣除%ld分",(long)rr] duration:SXLoadingTime];
                    return ;
                }
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];

}
//选择简称
- (IBAction)shortNumBtnAction:(id)sender {
    
    [self removerAllPickerView];
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [self.proCityPickerV showWithProvinceArray:self.provinceArray inView:self.view chooseBackBlock:^(ZQCityModel *cityModel) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (cityModel) {
                strongSelf.aCityModel = cityModel;
                [strongSelf.provinceBtn setTitle:cityModel.abbr forState:UIControlStateNormal];
            }
        }
    }];
    /*
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
        [self.view endEditing:YES];
    }
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:[Utility getProvinceShortNum] inView:self.view chooseBackBlock:^(NSString *seletedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (seletedStr) {
                [strongSelf.provinceBtn setTitle:seletedStr forState:UIControlStateNormal];
            }
        }
    }];
     */
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//选择简称字母
- (IBAction)characterBtnAction:(id)sender {
    [self removerAllPickerView];
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [self.pickView showWithDataArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"] inView:self.view chooseBackBlock:^(NSString *seletedStr) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (seletedStr) {
                 [strongSelf.cityCode setTitle:seletedStr forState:UIControlStateNormal];
            }
        }
    }];
}

//选择省份
- (IBAction)carTypeBtnAction:(id)sender {
    
    [self removerAllPickerView];
    [self.view endEditing:YES];
        __weak __typeof(self) weakSelf = self;
    _areaView = [[ZQAreaView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-230, __kWidth, 230) provinceId:nil];
    _areaView.handler = ^(ZQAreaModel *areaModel)
    {
        if (areaModel) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                if (areaModel) {
                    NSString *str = areaModel.areaName;
                    CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
                    [strongSelf.carTypeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, size.width+10, 0, -10-size.width)];
                    [strongSelf.carTypeBtn setTitle:areaModel.areaName forState:UIControlStateNormal];
                }
            }
        }
    };
    [self.view addSubview:_areaView];
    
//    if (_pickView) {
//        [_pickView removeFromSuperview];
//        _pickView = nil;
//        [self.view endEditing:YES];
//    }
//    __weak typeof(self) weakSelf = self;
//    [self.pickView showWithDataArray:@[@"小型汽车",@"中型汽车",@"大型汽车"] inView:self.view chooseBackBlock:^(NSString *seletedStr) {
//        __strong typeof(self) strongSelf = weakSelf;
//        if (strongSelf) {
//            if (seletedStr) {
//                [strongSelf.carTypeBtn setTitle:seletedStr forState:UIControlStateNormal];
//            }
//        }
//    }];
}

/*
- (void)showPickViewWithTextField:(UITextField *)textField
{
    if (_areaView) {
        [_areaView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_areaView removeFromSuperview];
        self.areaView = nil;
    }
    [self.view endEditing:YES];
    NSString *pId = nil;
    if ([textField isEqual:self.carCodeTf]) {
        pId = @"-1"; //展示省的简称
    }
    else
    {
//        if (self.provinceModel&&[textField isEqual:self.cityTf]) {
//            pId = self.provinceModel.areaId;
//        }
    }
//    __weak __typeof(self) weakSelf = self;
    __weak UITextField *wTextField = textField;
    _areaView = [[ZQAreaView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-230, __kWidth, 230) provinceId:pId];
    _areaView.handler = ^(ZQAreaModel *areaModel)
    {
        if (areaModel) {
            wTextField.text = areaModel.areaName;
//            if ([wTextField isEqual:weakSelf.provinceTf]) {
//                weakSelf.provinceModel = areaModel;
//            }
        }
    };
    [self.view addSubview:_areaView];
}
 */
#pragma mark -UITextFieldDelegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self removerAllPickerView];
//    if ([textField isEqual:self.provinceTf]) {
//        [self showPickViewWithTextField:textField];
//        return NO;
//    }
//    if ([textField isEqual:self.cityTf]) {
//        if (self.provinceModel) {
//            [self showPickViewWithTextField:textField];
//        }
//        else
//        {
//            [ZQLoadingView showAlertHUD:@"请选择省份" duration:SXLoadingTime];
//            
//        }
//        return NO;
//    }
//    if ([textField isEqual:self.carProvinceTf]) {
//        if (textField.text.length) {
//            return YES;
//        }
//        [self showPickViewWithTextField:textField];
//        return NO;
//    }
    return YES;
}

- (void)removerAllPickerView
{
    if (_pickView) {
        [_pickView removeFromSuperview];
        _pickView = nil;
    }
    if (_proCityPickerV) {
        [_proCityPickerV removeFromSuperview];
        _proCityPickerV = nil;
    }
    if (_areaView) {
        [_areaView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_areaView removeFromSuperview];
        _proCityPickerV = nil;
    }
}
-(ZQChoosePickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[ZQChoosePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _pickView;
}
-(ZQProCityPickerV *)proCityPickerV {
    
    if (_proCityPickerV == nil) {
        _proCityPickerV = [[ZQProCityPickerV alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, KWidth, 200)];
    }
    return _proCityPickerV;
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
