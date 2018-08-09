//
//  ZQSmsLoginViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/12.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQSmsLoginViewController.h"
#import "ZQRegisterViewController.h"
#import "NSString+Validation.h"

@interface ZQSmsLoginViewController ()
{
    BOOL temp;
}
@property (strong, nonatomic) UIScrollView *backV;

@property (strong, nonatomic) NSString *mobile;

@property (strong, nonatomic) NSString *verify;

@property (strong, nonatomic) UIButton *codeBtn;

@property (strong, nonatomic) NSTimer *sTemTimer;

@end

@implementation ZQSmsLoginViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.sTemTimer) {
        [self.sTemTimer invalidate];
        self.sTemTimer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mobile = [Utility getUserPhone];
    temp = 60;
    [self initView];
    [self getNavis];
}
-(void)getNavis{
    UIView *NaviV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 64)];
    [self.view addSubview:NaviV];
    NaviV.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:NaviV];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 29, 30, 25)];
    [NaviV addSubview:cancelBtn];
    cancelBtn.titleLabel.font = MFont(14);
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:BtnNormal];
    [cancelBtn addTarget:self action:@selector(back) forControlEvents:BtnTouchUpInside];
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake((__kWidth-120)/2, 32, 120, 20)];
    [NaviV addSubview:titleLb];
    titleLb.textAlignment =NSTextAlignmentCenter;
    titleLb.font = BFont(16);
    titleLb.textColor = __DTextColor;
    titleLb.text = @"短信验证登录";
}

- (void)initView{
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor whiteColor];
    [self.view sendSubviewToBack:_backV];
    _backV.contentSize = CGSizeMake(__kWidth, 606);
    
    //main
    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-60)/2, 95, 60, 60)];
    [_backV addSubview:loginIV];
//    loginIV.image =MImage(@"CJWY");
    loginIV.image = MImage(@"appIcon");
    loginIV.contentMode = UIViewContentModeScaleAspectFit;
    
    NSArray *imageArr = @[@"login_user",@"login_phone"];
    for (int i=0; i<2; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, 30+CGRectYH(loginIV)+60*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor = MainBgColor;
        putV.layer.cornerRadius = 5;
        
        UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 24, 24)];
        headIV.contentMode = UIViewContentModeScaleAspectFit;
        [putV addSubview:headIV];
        headIV.image = MImage(imageArr[i]);
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, __kWidth-180, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i;
//        inputTF.delegate = self;
        if (!i) {
            inputTF.placeholder = @"请输入验证手机";
            inputTF.text = self.mobile;
        }else{
            UIButton *codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-148, 3, 85, 40)];
            [putV addSubview:codeBtn];
            codeBtn.titleLabel.font = MFont(15);
            codeBtn.layer.cornerRadius =5;
            codeBtn.backgroundColor = [UIColor whiteColor];
            [codeBtn setTitle:@"获取验证码" forState:BtnNormal];
            [codeBtn setTitleColor:__TextColor forState:BtnNormal];
            [codeBtn addTarget:self action:@selector(getCode) forControlEvents:BtnTouchUpInside];
            self.codeBtn = codeBtn;
            inputTF.placeholder = @"请输入短信验证码...";
        }
    }
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectYH(loginIV)+200, __kWidth-60, 56)];
    [_backV addSubview:loginBtn];
    loginBtn.backgroundColor = __DefaultColor;
    loginBtn.layer.cornerRadius = 28;
    loginBtn.titleLabel.font = MFont(18);
    [loginBtn setTitle:@"登录" forState:BtnNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [loginBtn addTarget:self action:@selector(Login) forControlEvents:BtnTouchUpInside];
    
    //    UIButton *ViploginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectYH(loginBtn)+5, __kWidth-60, 56)];
    //    [_backV addSubview:ViploginBtn];
    //    ViploginBtn.backgroundColor = [UIColor whiteColor];
    //    ViploginBtn.layer.cornerRadius = 28;
    //    ViploginBtn.titleLabel.font = MFont(16);
    //    ViploginBtn.layer.borderColor =__BackColor.CGColor;
    //    ViploginBtn.layer.borderWidth = 1;
    //    [ViploginBtn setTitle:@"VIP合约客户登录" forState:BtnNormal];
    //    [ViploginBtn setTitleColor:__TextColor forState:BtnNormal];
    //    [ViploginBtn addTarget:self action:@selector(Login) forControlEvents:BtnTouchUpInside];
    //    [ViploginBtn setImage:MImage(@"login_vip") forState:BtnNormal];
    //    ViploginBtn.imageEdgeInsets = UIEdgeInsetsMake(18, 0, 18, 10);
    //    ViploginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    UIButton *cannotBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectYH(loginBtn)+10, (__kWidth-80)/2, 20)];
    [_backV addSubview:cannotBtn];
    cannotBtn.titleLabel.font = MFont(15);
    cannotBtn.backgroundColor = [UIColor clearColor];
    [cannotBtn setTitle:@"账户登录" forState:BtnNormal];
    [cannotBtn setTitleColor:__TextColor forState:BtnNormal];
    [cannotBtn addTarget:self action:@selector(cannotLogin) forControlEvents:BtnTouchUpInside];
    
    UIImageView *lineIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-2)/2, CGRectYH(loginBtn)+15, 2, 14)];
    [_backV addSubview:lineIV];
    lineIV.backgroundColor = __BackColor;
    
    UIButton *logonBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth/2+20, CGRectYH(loginBtn)+10, (__kWidth-80)/2, 20)];
    [_backV addSubview:logonBtn];
    logonBtn .titleLabel.font = MFont(15);
    logonBtn.backgroundColor =[UIColor clearColor];
    [logonBtn setTitle:@"现在注册 >" forState:BtnNormal];
    [logonBtn setTitleColor:__DefaultColor forState:BtnNormal];
    [logonBtn addTarget:self action:@selector(Logon) forControlEvents:BtnTouchUpInside];
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ==获取验证码==
-(void)getCode{
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
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_phone_code/phone/%@",_mobile];
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            NSInteger code = [jsonDic[@"code"] integerValue];
            if (code != 400) {
                strongSelf.verify = [NSString stringWithFormat:@"%@",jsonDic[@"code"]];
                //            [strongSelf.codeBtn setBackgroundColor:[UIColor colorWithRed:0xbb/255.0 green:0xbb/255.0 blue:0xbb/255.0 alpha:1.0]];
                strongSelf.sTemTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:strongSelf selector:@selector(numTiming:) userInfo:nil repeats:YES];
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
        self.sTemTimer = nil;
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
#pragma mark ==登录==
-(void)Login{
    [self.view endEditing:YES];
    if (IsNilString(_mobile)||IsNilString(_verify)) {
        return;
    }
    [JKHttpRequestService POST:@"Register/short_login" withParameters:@{@"mobile":_mobile,@"verify":_verify} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSDictionary*dic = jsonDic[@"data"];
            NSString *name =dic[@"mobile"];
//            [UdStorage storageObject:dic[@"app_user_type"] forKey:UserType];
//            [UdStorage storageObject:dic[@"app_user_id"] forKey:Userid];
//
            if (YES) {
//                [UdStorage storageObject:name forKey:UserName];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
//                NSLog(@"%@%ld",error.description,(long)error.errorCode);
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}

#pragma mark ==VIP登录==
-(void)vipLogin{
    NSLog(@"VIP登录");
}

#pragma mark ==无法登录==
-(void)cannotLogin{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ==注册==
-(void)Logon{
    ZQRegisterViewController *vc= [[ZQRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==UITextFiledDelegate==
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag) {
        _verify = textField.text;
    }else{
        _mobile = textField.text;
    }
    return YES;
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return  UIStatusBarStyleDefault;
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
