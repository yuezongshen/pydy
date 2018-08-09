//
//  ZQRegisterViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/11.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQRegisterViewController.h"
#import "ZQLoadingView.h"
#import "NSString+Validation.h"
#import "ZQLoginViewController.h"

@interface ZQRegisterViewController ()<UITextFieldDelegate>
{
    int  temp;
//    BOOL rIsVerify;
}
@property (strong,nonatomic) UIScrollView *backV;

@property (strong,nonatomic) NSString *mobile;//手机

@property (strong,nonatomic) NSString *passWord;//密码

@property (strong,nonatomic) NSString *verify;//验证码

@property (strong,nonatomic) NSTimer *tempTimer;

@property (strong,nonatomic) UIButton *codeBtn;
@end

@implementation ZQRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册账号";
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageV.image = [UIImage imageNamed:@"info_bg"];
    [self.view addSubview:bgImageV];
    
    [self initView];
    self.mobile = [Utility getUserPhone];
    temp = 60;
//    rIsVerify = NO;
}

-(void)initView
{
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor clearColor];
//    [self.view sendSubviewToBack:_backV];
    _backV.contentSize = CGSizeMake(__kWidth, 606);
    
    //main
//    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-60)/2, 74, 60, 60)];
//    [_backV addSubview:loginIV];
////    loginIV.image =MImage(@"CJWY");
//    loginIV.image = MImage(@"appIcon");
//    loginIV.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *loginIV = [[UILabel alloc] initWithFrame:CGRectMake(0, (__kWidth == 320 ? 65:125), __kWidth, 80)];
    loginIV.text = @"平遥古城导游\n管理APP";
    loginIV.font = [UIFont boldSystemFontOfSize:26];
    loginIV.numberOfLines = 2;
    loginIV.textColor = __MoneyColor;
    loginIV.textAlignment = NSTextAlignmentCenter;
    [_backV addSubview:loginIV];
    
    NSArray *imageArr =@[@"login_phone",@"login_password",@"login_password"];
    for (int i=0; i<imageArr.count; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectYH(loginIV)+20+70*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor= [UIColor colorWithWhite:1.0 alpha:0.6];
        putV.layer.cornerRadius = 23;
        putV.clipsToBounds = YES;
        
        UIImageView *headIV = [[UIImageView alloc] init];
        headIV.contentMode = UIViewContentModeScaleAspectFit;
        [putV addSubview:headIV];
        headIV.image =MImage(imageArr[i]);
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, __kWidth-180, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i;
        inputTF.secureTextEntry = NO;
        inputTF.delegate = self;
        inputTF.textColor = [UIColor whiteColor];
        switch (i) {
            case 0:{
                headIV.frame = CGRectMake(15, 12, 15, 23);
                inputTF.placeholder = @"输入手机号";
                inputTF.text = self.mobile;
            }
                break;
            case 1:{
                headIV.frame = CGRectMake(15, 11, 18, 24);
                self.codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-158, 0, 100, 46)];
                _codeBtn.titleLabel.font = MFont(13);
                _codeBtn.backgroundColor = __MoneyColor;
                [_codeBtn setTitle:@"获取验证码" forState:BtnNormal];
                [_codeBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
                [_codeBtn addTarget:self action:@selector(getCode) forControlEvents:BtnTouchUpInside];
                [putV addSubview:_codeBtn];
                inputTF.placeholder = @"输入验证码";
            }
                break;
            case 2:{
                headIV.frame = CGRectMake(15, 11, 18, 24);
                inputTF.placeholder = @"请输入您的密码";
                inputTF.secureTextEntry = YES;
                break;
            }
            default:
                break;
        }
    }
    UIButton *registerBtn= [[UIButton alloc]initWithFrame:CGRectMake(100, CGRectYH(loginIV)+260, __kWidth-200, 44)];
    [_backV addSubview:registerBtn];
    registerBtn.backgroundColor = __MoneyColor;
    registerBtn.layer.cornerRadius = 22;
    registerBtn.titleLabel.font = BFont(18);
    [registerBtn setTitle:@"注册" forState:BtnNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [registerBtn addTarget:self action:@selector(regiSter) forControlEvents:BtnTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-60, CGRectGetWidth(self.view.frame), 60)];
    label.text = @"版权所有: 平遥古城景区旅游发展有限公司";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

#pragma mark ==注册==
-(void)regiSter{
    [self.view endEditing:YES];
    if (_mobile) {
        if (![_mobile isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:1.5];
        return;
    }
    if (!_verify) {
        [ZQLoadingView showAlertHUD:@"请输入正确的验证码" duration:1.5];
        return;
    }
    if (!_passWord) {
        [ZQLoadingView showAlertHUD:@"请输入密码" duration:1.5];
        return;
    }
    //注册接口
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/register" withParameters:@{@"phone":_mobile,@"password":_passWord,@"code":self.verify} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
                [strongSelf performSelector:@selector(backAction) withObject:nil afterDelay:SXLoadingTime];
            }
        }
    } failure:^(NSError *error) {

    } animated:YES];
    
}
- (void)backAction
{
    ZQLoginViewController *loginVc = [[ZQLoginViewController alloc] init];
    [loginVc configRegMobile:_mobile];
    [self.navigationController pushViewController:loginVc animated:YES];
}

#pragma mark ==获取验证码==
-(void)getCode{
    [self.view endEditing:YES];
    if (self.tempTimer) {
        [ZQLoadingView showAlertHUD:@"请稍后获取" duration:SXLoadingTime];
        return;
    }
    if (_mobile.length) {
        if (![_mobile isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:SXLoadingTime];
        return;
    }

    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/verificationCode" withParameters:@{@"phone":_mobile} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.tempTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:strongSelf selector:@selector(numTiming:) userInfo:nil repeats:YES];
        }
        else
        {
            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView showAlertHUD:@"请求失败" duration:2.0];

    } animated:YES];
}
- (void)numTiming:(NSTimer *)sTimer
{
    if (temp == 0) {
        [sTimer invalidate];
        self.tempTimer = nil;
        temp = 60;
        [_codeBtn setUserInteractionEnabled:YES];
//        [_codeBtn setBackgroundColor:[UIColor colorWithRed:0x41/255.0 green:0xc9/255.0 blue:0xdc/255.0 alpha:1.0]];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重发",temp--] forState:UIControlStateNormal];
    }
}
#pragma mark ==UITextFiledDelegate==
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 0:
        {
            _mobile = textField.text;
            if (![self checkPhone]) {
                [ZQLoadingView showAlertHUD:@"手机号码格式不对，请重新输入" duration:1.5];
            }
            break;
        }
        case 1:
        {
            _verify = textField.text;
//            rIsVerify = [_verify isEqualToString:textField.text];
//            if (!rIsVerify) {
//                [ZQLoadingView showAlertHUD:@"验证码输入错误" duration:2.5];
//            }
        }
            break;
        case 2:
        {
            _passWord = textField.text;

        }
            break;
        default:
            break;
    }
    return YES;
}

-(void)changeFrame:(CGFloat)height{
    _backV.transform = CGAffineTransformMakeTranslation(0, height);
}


- (BOOL)checkPhone {
    NSString *phoneTest = @"^1[0-9]{10}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneTest];
    if ([mobileTest evaluateWithObject:_mobile]) {
        return YES;
    }else{
        return NO;
    }
}


//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return  UIStatusBarStyleDefault;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.tempTimer) {
        [self.tempTimer invalidate];
        self.tempTimer = nil;
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
