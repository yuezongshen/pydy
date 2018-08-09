//
//  ZQPayPasswordController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/18.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQPayPasswordController.h"
#import "NSString+Validation.h"

@interface ZQPayPasswordController ()<UITextFieldDelegate>
{
    NSInteger timeNum;
    BOOL isVerifyRight;
    BOOL isTheSameP;
}
@property (strong, nonatomic) UIScrollView *backScrollV;

@property (strong, nonatomic) NSString *pCode;

@property (strong, nonatomic) UIImageView *numIV;

@property (strong, nonatomic) NSTimer *temTimer;

@property (strong, nonatomic) UIButton *codeBtn;

@property (assign, nonatomic) NSInteger aPageType;

@property (copy, nonatomic) NSString *payPhone;
@property (copy, nonatomic) NSString *payVerifyCode;
@property (copy, nonatomic) NSString *payPassword;
@end

@implementation ZQPayPasswordController

- (instancetype)initWithType:(NSInteger)type
{
    self = [super init];
    if (self) {
        self.aPageType = type;
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.temTimer) {
        [self.temTimer invalidate];
        self.temTimer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.aPageType==1) {
        self.title = @"设置支付密码";
    }
    else
    {
        self.title = @"忘记支付密码";
    }
    _payPhone = [Utility getUserPhone];
    timeNum = 60;
    [self initView];
}
-(void)initView{
    
    _backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [self.view addSubview:_backScrollV];
    _backScrollV.backgroundColor = [UIColor whiteColor];
    [self.view sendSubviewToBack:_backScrollV];
    _backScrollV.contentSize = CGSizeMake(__kWidth, 606);
    
    //main
    //    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-221)/2, 75, 221, 28)];
    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-60)/2, 20, 60, 60)];
    [_backScrollV addSubview:loginIV];
    //    loginIV.image =MImage(@"CJWY");
    loginIV.image = MImage(@"appIcon");
    loginIV.contentMode = UIViewContentModeScaleAspectFit;
    NSArray *imageArr = nil;
    NSArray *placeholderArr = nil;
    if (self.aPageType==1) {
        imageArr = @[@"login_user",@"login_phone",@"login_password",@"login_password"];
        placeholderArr = @[@"已验证手机",@"短信验证码",@"请输入支付密码",@"请重新输入支付密码"];
    }
    else
    {
        imageArr = @[@"login_user",@"login_phone",@"login_password"];
        placeholderArr = @[@"已验证手机",@"短信验证码",@"请输入新支付密码"];
    }
    for (int i=0; i<imageArr.count; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, 30+CGRectYH(loginIV)+60*i, __kWidth-60, 46)];
        [_backScrollV addSubview:putV];
        putV.backgroundColor = MainBgColor;
        putV.layer.cornerRadius = 5;
        
        UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 24, 24)];
        headIV.contentMode = UIViewContentModeScaleAspectFit;
        [putV addSubview:headIV];
        headIV.image= MImage(imageArr[i]);
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 3, __kWidth-80, 40)];
        [putV addSubview:inputTF];
        inputTF.keyboardType = UIKeyboardTypeNumberPad;
        inputTF.font = MFont(14);
        inputTF.tag = i+33;
        inputTF.delegate = self;
        inputTF.textAlignment = NSTextAlignmentLeft;
        inputTF.placeholder = placeholderArr[i];

        switch (i) {
            case 0:
            {
                inputTF.text = _payPhone;
            }
                break;
            case 1:
            {
                headIV.frame = CGRectMake(11,11, 24, 24);
                inputTF.frame = CGRectMake(50, 3, __kWidth-210, 40);
                UIButton *codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-153, 3, 90, 40)];
                [putV addSubview:codeBtn];
                codeBtn.titleLabel.font = MFont(15);
                codeBtn.layer.cornerRadius =5;
                codeBtn.backgroundColor = [UIColor whiteColor];
                [codeBtn setTitle:@"获取验证码" forState:BtnNormal];
                [codeBtn setTitleColor:__TextColor forState:BtnNormal];
                [codeBtn addTarget:self action:@selector(getPayVerifyCode) forControlEvents:BtnTouchUpInside];
                self.codeBtn = codeBtn;
            }
                break;
            case 2:
            {
                //                putV.frame = CGRectMake(30, 20+70*i, __kWidth-190, 46);
                //                inputTF.frame = CGRectMake(50, 13, __kWidth-250, 20);
                //                inputTF.placeholder = @"图片验证码";
                inputTF.secureTextEntry = YES;
                
                //                _numIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(putV)+5, 172, 81, 32)];
                //                [_backV addSubview:_numIV];
                //                _numIV.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.yisu.cn/Home/Register/verify"]]];
                //
                //                UIButton *changeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectXW(_numIV), 172, 50, 32)];
                //                [_backV addSubview:changeBtn];
                //                changeBtn.titleLabel.font = MFont(14);
                //                [changeBtn setTitle:@"换一张" forState:BtnNormal];
                //                [changeBtn setTitleColor:LH_RGBCOLOR(153, 153, 153) forState:BtnNormal];
                //                [changeBtn addTarget:self action:@selector(change) forControlEvents:BtnTouchUpInside];
            }
                break;
                case 3:
            {
                inputTF.secureTextEntry = YES;
            }
                break;
            default:
                break;
        }
    }
    UIButton *foundBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectYH(loginIV)+imageArr.count*60+40, __kWidth-60, 56)];
    [_backScrollV addSubview:foundBtn];
    foundBtn.layer.cornerRadius =28;
    foundBtn.backgroundColor = __DefaultColor;
    foundBtn.titleLabel.font = BFont(18);
    if (self.aPageType==1) {
        [foundBtn setTitle:@"设置支付密码" forState:BtnNormal];
    }
    else
    {
        [foundBtn setTitle:@"找回支付密码" forState:BtnNormal];
    }
    [foundBtn addTarget:self action:@selector(payFoundPasswordBtn) forControlEvents:BtnTouchUpInside];
    
    
}
#pragma mark ==获取验证码==
-(void)getPayVerifyCode{
    [self.view endEditing:YES];
    if (_payPhone.length) {
        if (![_payPhone isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:SXLoadingTime];
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_phone_code/phone/%@",_payPhone];
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSInteger code = [jsonDic[@"code"] integerValue];
            if (code != 400) {
                strongSelf.payVerifyCode = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
                //            [strongSelf.codeBtn setBackgroundColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1.0]];
                strongSelf.temTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:strongSelf selector:@selector(numTiming:) userInfo:nil repeats:YES];
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
    if (timeNum == 0) {
        [sTimer invalidate];
        self.temTimer = nil;
        timeNum = 60;
        [_codeBtn setUserInteractionEnabled:YES];
        //        [_codeBtn setBackgroundColor:[UIColor colorWithRed:0x41/255.0 green:0xc9/255.0 blue:0xdc/255.0 alpha:1.0]];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    else
    {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)timeNum--] forState:UIControlStateNormal];
    }
}

#pragma mark ==找回密码==
-(void)payFoundPasswordBtn{
    
    if (_payPhone) {
        if (![_payPhone isValidMobilePhoneNumber]) {
            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
            return;
        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入手机号" duration:1.5];
        return;
    }
    if (!isVerifyRight) {
        [ZQLoadingView showAlertHUD:@"请输入正确的验证码" duration:1.5];
        return;
    }
    if (!_payPassword) {
        [ZQLoadingView showAlertHUD:@"请输入新密码" duration:1.5];
        return;
    }
    NSString *urlStr = nil;
    if (!isTheSameP) {
        [ZQLoadingView showAlertHUD:@"两次密码输入不一致" duration:1.5];
        return;
    }
    urlStr = [NSString stringWithFormat:@"daf/update_zfpassword/u_id/%@/zfpassword/%@",[Utility getUserID],_payPassword];
    /*
    if (self.aPageType==1) {
        if (!isTheSameP) {
            [ZQLoadingView showAlertHUD:@"两次密码输入不一致" duration:1.5];
            return;
        }
        urlStr = [NSString stringWithFormat:@"daf/password_recovery/phone/%@/password/%@",_payPhone,_payPassword];
//        urlStr = [NSString stringWithFormat:@"daf/password_recovery/phone/%@/password/%@",_payPhone,[_payPassword md5Encrypt]];
    }
    else
    {
//        urlStr = [NSString stringWithFormat:@"daf/update_zfpassword/u_id/%@/zfpassword/%@",[Utility getUserID],[_payPassword md5Encrypt]];
        urlStr = [NSString stringWithFormat:@"daf/update_zfpassword/u_id/%@/zfpassword/%@",[Utility getUserID],_payPassword];
    }
    */
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [Utility saveWalletPayPassword:strongSelf.payPassword];
                if (self.aPageType==1) {
        [ZQLoadingView showAlertHUD:@"设置支付密码成功" duration:SXLoadingTime];
                }
                else
                {
                    [ZQLoadingView showAlertHUD:@"修改支付密码成功" duration:SXLoadingTime];
                }
                [strongSelf performSelector:@selector(backAction) withObject:strongSelf afterDelay:2.6];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:NO];
    
}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ==UITextFiledDelegate==
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    switch (textField.tag-33) {
        case 0:
        {
            _payPhone = textField.text;
        }
            break;
        case 1:
        {
            isVerifyRight = [_payVerifyCode isEqualToString:textField.text];
            if (!isVerifyRight) {
                [ZQLoadingView showAlertHUD:@"验证码错误" duration:SXLoadingTime];
            }
        }
            break;
        case 2:
        {
            _payPassword = textField.text;
        }
            break;
        case 3:
        {
            isTheSameP = [_payPassword isEqualToString:textField.text];
            if (!isTheSameP) {
                [ZQLoadingView showAlertHUD:@"两次密码输入不一致" duration:SXLoadingTime];
            }
        }
            break;
        default:
            break;
    }
    return YES;
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
