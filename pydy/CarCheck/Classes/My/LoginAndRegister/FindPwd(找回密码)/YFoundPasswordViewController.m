//
//  YFoundPasswordViewController.m
//  shopsN
//
//  Created by imac on 2016/12/6.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "YFoundPasswordViewController.h"
//#import "YFoundEmailViewController.h"
#import "YResetPassViewController.h"
#import "ZQLoadingView.h"

#import "NSString+Validation.h"
#import "ZQSetNewPasswordController.h"

@interface YFoundPasswordViewController ()<UITextFieldDelegate>
{
//    BOOL isRight;
    NSInteger temp;
}
@property (strong, nonatomic) UIScrollView *backV;

@property (strong, nonatomic) NSString *mobile;

@property (strong, nonatomic) NSString *code;

@property (strong, nonatomic) NSString *picCode;
@property (strong, nonatomic) NSString *rPicCode;

@property (strong, nonatomic) UIImageView *numIV;

@property (strong, nonatomic) NSTimer *temTimer;

@property (strong, nonatomic) UIButton *codeBtn;
@end

@implementation YFoundPasswordViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
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
    self.title = @"修改密码";
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageV.image = [UIImage imageNamed:@"info_bg"];
    [self.view addSubview:bgImageV];
    
    self.mobile = [Utility getUserPhone];
    temp = 60;
    [self initView];
}


-(void)initView{
//    UIImageView *lineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, 1)];
//    [self.view addSubview:lineIV];
//    lineIV.backgroundColor = HEXCOLOR(0xcbcbcb);

//    _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 65, __kWidth, __kHeight-65)];
//    [self.view addSubview:_backV];
//    _backV.backgroundColor = [UIColor clearColor];
    
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor clearColor];
    _backV.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 606);

//    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-60)/2, 74, 60, 60)];
//    [_backV addSubview:loginIV];
//    loginIV.image = MImage(@"appIcon");
//    loginIV.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *loginIV = [[UILabel alloc] initWithFrame:CGRectMake(0, (__kWidth == 320 ? 25:125), CGRectGetWidth(self.view.frame), 80)];
    loginIV.text = @"平遥古城导游\n管理APP";
    loginIV.font = [UIFont boldSystemFontOfSize:26];
    loginIV.numberOfLines = 2;
    loginIV.textColor = __MoneyColor;
    loginIV.textAlignment = NSTextAlignmentCenter;
    [_backV addSubview:loginIV];
    
    NSArray *imageArr = @[@"login_phone",@"login_password",@"login_password",@"login_password"];
    for (int i=0; i<imageArr.count; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, CGRectYH(loginIV)+20+70*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];;
        putV.layer.cornerRadius = 23;
        putV.clipsToBounds = YES;

        UIImageView *headIV = [[UIImageView alloc]init];
        headIV.contentMode = UIViewContentModeScaleAspectFit;
        [putV addSubview:headIV];
        headIV.image= MImage(imageArr[i]);

        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 13, __kWidth-120, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i+33;
        inputTF.delegate = self;
        inputTF.textAlignment = NSTextAlignmentLeft;
        inputTF.textColor = [UIColor whiteColor];
        switch (i) {
            case 0:
            {
                headIV.frame = CGRectMake(15, 12, 15, 23);
                inputTF.placeholder = @"输入手机号";
                inputTF.text = self.mobile;
            }
                break;
            case 1:
            {
                headIV.frame = CGRectMake(15, 11, 18, 24);
                inputTF.placeholder = @"请输入密码";
                inputTF.secureTextEntry = YES;
            }
                break;
            case 2:
            {
                headIV.frame = CGRectMake(15, 11, 18, 24);
                inputTF.placeholder = @"请再次输入新密码";
                inputTF.secureTextEntry = YES;
                break;
            }
            case 3:
            {
                headIV.frame = CGRectMake(15, 11, 18, 24);
                UIButton *codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-158, 0, 100, 46)];
                [putV addSubview:codeBtn];
                codeBtn.titleLabel.font = MFont(15);
                codeBtn.backgroundColor = __MoneyColor;
                [codeBtn setTitle:@"获取验证码" forState:BtnNormal];
                [codeBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
                [codeBtn addTarget:self action:@selector(getCode) forControlEvents:BtnTouchUpInside];
                self.codeBtn = codeBtn;
                inputTF.placeholder = @"输入验证码";
            }
                break;
            default:
                break;
        }
    }
    UIButton *foundBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, CGRectYH(loginIV)+70*imageArr.count+(__kWidth == 320 ?20:40), __kWidth-200, 50)];
    [_backV addSubview:foundBtn];
    foundBtn.layer.cornerRadius = 25;
    foundBtn.backgroundColor = __MoneyColor;
    foundBtn.titleLabel.font = BFont(18);
//    [foundBtn setTitle:@"下一步" forState:BtnNormal];
    [foundBtn setTitle:@"提交新密码" forState:BtnNormal];
    [foundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [foundBtn addTarget:self action:@selector(found) forControlEvents:BtnTouchUpInside];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-60, CGRectGetWidth(self.view.frame), 60)];
    label.text = @"版权所有: 平遥古城景区旅游发展有限公司";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

#pragma mark ==获取验证码==
-(void)getCode{
    [self.view endEditing:YES];
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
             strongSelf.temTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:strongSelf selector:@selector(numTiming:) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        
    } animated:YES];

}
- (void)numTiming:(NSTimer *)sTimer
{
    if (temp == 0) {
        [sTimer invalidate];
        self.temTimer = nil;
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
#pragma mark ==换一张==
-(void)change{
   _numIV.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.yisu.cn/Home/Register/verify"]]];
}
#pragma mark ==找回密码==
-(void)found{
//    ZQSetNewPasswordController *setNewPVC = [[ZQSetNewPasswordController alloc] init];
//    [self.navigationController pushViewController:setNewPVC animated:YES];
//    return;
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
    if (!_code) {
        [ZQLoadingView showAlertHUD:@"请输入正确的验证码" duration:1.5];
        return;
    }
    if (!_picCode) {
        [ZQLoadingView showAlertHUD:@"请输入新密码" duration:1.5];
        return;
    }
    if (!_rPicCode) {
        [ZQLoadingView showAlertHUD:@"请再次输入新密码" duration:1.5];
        return;
    }
    if (![_picCode isEqualToString:_rPicCode]) {
        [ZQLoadingView showAlertHUD:@"两次输入的密码不一致" duration:1.5];
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/modifyPassword" withParameters:@{@"phone":_mobile,@"password":_picCode,@"code":_code} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
            [strongSelf performSelector:@selector(backAction) withObject:nil afterDelay:SXLoadingTime];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView showProgressHUD:@"网络错误"];
    } animated:YES];

}
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
//#pragma mark ==邮箱找回密码==
//-(void)chooseEmail{
//    NSLog(@"邮箱找回");
//    YFoundEmailViewController *vc = [[YFoundEmailViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            _mobile = textField.text;
        }
            break;
        case 1:
        {
            _picCode = textField.text;
        }
            break;
        case 2:
        {
            _rPicCode = textField.text;
        }
            break;
            case 3:
        {
          _code = textField.text;
        }
            break;
        default:
            break;
    }
    return YES;
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return  UIStatusBarStyleDefault;
//}

- (void)dealloc {
    _numIV =nil;
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
