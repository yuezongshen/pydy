//
//  YSLoginViewController.m
//  shopsN
//
//  Created by imac on 2016/12/5.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "ZQLoginViewController.h"
#import "ZQRegisterViewController.h"
#import "YFoundPasswordViewController.h"
#import "ZQSmsLoginViewController.h"

#import "YshareChooseView.h"

#import "JPUSHService.h"
#import "NSString+Validation.h"

@interface  ZQLoginViewController()<UITextFieldDelegate,YshareChooseViewDelegate>

@property (strong,nonatomic) UIScrollView *backV;

@property (strong,nonatomic) NSString *name;

@property (strong,nonatomic) NSString *passWord;

@property (strong,nonatomic) UITextField *phoneTextField;
@end

@implementation ZQLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (_name.length) {
        if (self.phoneTextField) {
            [self.phoneTextField setText:_name];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageV.image = [UIImage imageNamed:@"info_bg"];
    [self.view addSubview:bgImageV];
//    _name = @"18810555989";
//    _passWord = @"123456";
    [self initView];
}


- (void)initView{
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor clearColor];
//    [self.view sendSubviewToBack:_backV];
    _backV.contentSize = CGSizeMake(__kWidth, 606);
    
    //main
//    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-60)/2, 75, 60, 60)];
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
    
    NSArray *imageArr = @[@"login_phone",@"login_password"];
    for (int i=0; i<2; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, 20+CGRectYH(loginIV)+70*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        putV.layer.cornerRadius = 23;
        
        UIImageView *headIV = [[UIImageView alloc]init];
        [putV addSubview:headIV];
        headIV.image = MImage(imageArr[i]);
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 13, __kWidth-140, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i;
        inputTF.delegate = self;
        inputTF.textColor = [UIColor whiteColor];
        if (!i) {
            headIV.frame = CGRectMake(15, 12, 15, 23);
            inputTF.placeholder = @"输入手机号";
            self.phoneTextField = inputTF;
            if (_name.length) {
             [inputTF setText:_name];
            }
//            else
//            [inputTF setText:@"18810555989"];
        }else{
            headIV.frame = CGRectMake(15, 11, 18, 24);
            inputTF.placeholder = @"输入密码";
            inputTF.secureTextEntry = YES;
        }
    }
    
    CGFloat btnWidth = 100;
    CGFloat space = (__kWidth-btnWidth*2)/2;
    UIButton *logonBtn = [[UIButton alloc]initWithFrame:CGRectMake(space, CGRectYH(loginIV)+165, btnWidth, 20)];
    [_backV addSubview:logonBtn];
    logonBtn .titleLabel.font = MFont(16);
    logonBtn.backgroundColor =[UIColor clearColor];
    [logonBtn setTitle:@"导游注册" forState:BtnNormal];
    [logonBtn setTitleColor:__MoneyColor forState:BtnNormal];
    [logonBtn addTarget:self action:@selector(Logon) forControlEvents:BtnTouchUpInside];
    
    UIButton *cannotBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logonBtn.frame), CGRectGetMinY(logonBtn.frame), btnWidth, 20)];
    [_backV addSubview:cannotBtn];
    cannotBtn.titleLabel.font = MFont(16);
    cannotBtn.backgroundColor = [UIColor clearColor];
    [cannotBtn setTitle:@"忘记密码" forState:BtnNormal];
    [cannotBtn setTitleColor:[UIColor lightGrayColor] forState:BtnNormal];
    [cannotBtn addTarget:self action:@selector(cannotLogin) forControlEvents:BtnTouchUpInside];
    
    UIImageView *lineIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-2)/2, CGRectGetMinY(logonBtn.frame)+2, 2, 13)];
    [_backV addSubview:lineIV];
    lineIV.backgroundColor = [UIColor whiteColor];
    
   
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectYH(logonBtn)+60, __kWidth-60, 40)];
    [_backV addSubview:loginBtn];
    loginBtn.backgroundColor = __MoneyColor;
    loginBtn.layer.cornerRadius = 20;
    loginBtn.titleLabel.font = MFont(18);
    [loginBtn setTitle:@"登陆" forState:BtnNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [loginBtn addTarget:self action:@selector(Login) forControlEvents:BtnTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-60, CGRectGetWidth(self.view.frame), 60)];
    label.text = @"版权所有: 平遥古城景区旅游发展有限公司";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

-(void)goBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configRegMobile:(NSString *)regMobile
{
    if (regMobile) {
        self.name = regMobile;
    }
    else
    {
        self.name = @"18510860087";
    }
}
#pragma mark ==登录==
-(void)Login{
    [self.view endEditing:YES];
    if (_name.length) {
//        if (![_name isValidMobilePhoneNumber]) {
//            [ZQLoadingView showAlertHUD:@"手机号格式不正确" duration:SXLoadingTime];
//            return;
//        }
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"请输入您的手机号/账号" duration:2.0];
        return;
    }
    if (!_passWord.length) {
        [ZQLoadingView showAlertHUD:@"请输入密码" duration:2.0];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/login" withParameters:@{@"phone":_name,@"password":_passWord,@"myphoneim":@"789561"} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            [Utility saveUserInfo:jsonDic[@"data"][@"userInfo"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLoginNotication object:nil];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {

    } animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZQdidLoginNotication object:nil];
}
-(void)getUserinfo {
    
//    NSMutableDictionary *tepDict = [NSMutableDictionary dictionary];
//    [tepDict setObject:_name forKey:@"username"];
//    NSString *dict = [YSParseTool jsonDict:tepDict];
//    NSString *controller = @"User";
//    NSString *method = @"getUserInfoByUsername";
//    NSString *common_param = dict;
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:controller forKey:@"controller"];
//    [param setObject:method forKey:@"method"];
//    [param setObject:common_param forKey:@"common_param"];
//
//    [JKHttpRequestService POST:@"?" withParameters:param success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        NSDictionary *dic = jsonDic[@"data"][@"niu_reponse"];
//        if ([jsonDic[@"message"] isEqualToString:@"success"]) {
//
//            [UdStorage storageObject:dic[@"user_name"] forKey:UserName];
//            [UdStorage storageObject:dic[@"app_user_type"] forKey:UserType];
//            [UdStorage storageObject:[NSString stringWithFormat:@"%@",dic[@"uid"]] forKey:Userid];
//            //            [SXLoadingView showAlertHUD:message duration:SXLoadingTime];
//        }else{
//            [SXLoadingView showAlertHUD:[jsonDic[@"data"] valueForKey:@"message"] duration:SXLoadingTime];
//        }
//    } failure:^(NSError *error) {
//
//    } animated:NO];
    
}

#pragma mark ==无法登录==
-(void)cannotLogin{
    YFoundPasswordViewController *vc = [[YFoundPasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==注册==
-(void)Logon{
    ZQRegisterViewController *vc = [[ZQRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==YshareChooseViewDelegate==
-(void)chooseShare:(NSInteger)sender{
//    switch (sender) {
//        case 0:
//        {
//            [ShareSDK getUserInfo:SSDKPlatformTypeQQ
//                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//             {
//                 if (state == SSDKResponseStateSuccess)
//                 {
//
//                     NSLog(@"uid=%@",user.uid);
//                     NSLog(@"%@",user.credential);
//                     NSLog(@"token=%@",user.credential.token);
//                     NSLog(@"nickname=%@",user.nickname);
//                     [self threeLogin:@{@"type":@"1",@"accout":user.uid}];
//                 }
//
//                 else
//                 {
//                     NSLog(@"%@",error);
//                 }
//
//             }];
//        }
//            break;
//        case 1:
//        {
//            [ShareSDK getUserInfo:SSDKPlatformTypeWechat
//                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//             {
//                 if (state == SSDKResponseStateSuccess)
//                 {
//
//                     NSLog(@"uid=%@",user.uid);
//                     NSLog(@"%@",user.credential);
//                     NSLog(@"token=%@",user.credential.token);
//                     NSLog(@"nickname=%@",user.nickname);
//                     [self threeLogin:@{@"type":@"2",@"accout":user.uid}];
//                 }
//
//                 else
//                 {
//                     NSLog(@"%@",error);
//                 }
//
//             }];
//        }
//            break;
//            //        case 2:
//            //        {
//            //            [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
//            //                   onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
//            //             {
//            //                 if (state == SSDKResponseStateSuccess)
//            //                 {
//            //
//            //                     NSLog(@"uid=%@",user.uid);
//            //                     NSLog(@"%@",user.credential);
//            //                     NSLog(@"token=%@",user.credential.token);
//            //                     NSLog(@"nickname=%@",user.nickname);
//            //                     #pragma mark ==该处新浪微博登录需要后台根据API重写接口==
//            //                     [self threeLogin:@{@"type":@"3",@"accout":@""}];
//            //                 }
//            //
//            //                 else
//            //                 {
//            //                     NSLog(@"%@",error);
//            //                 }
//            //
//            //             }];
//            //        }
//            //            break;
//        default:
//            break;
//    }
}


#pragma mark ==UITextFiledDelegate==
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag) {
        _passWord = textField.text;
    }else{
        _name = textField.text;
    }
    return YES;
}

#pragma mark ==跳转第三方==
- (void)threeLogin:(NSDictionary*)paramas{
//    [JKHttpRequestService POST:@"Register/otherLogin" withParameters:paramas success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        if (succe) {
//            NSDictionary *dic =jsonDic[@"data"];
//            EMError *error = nil;
//            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:dic[@"mobile"] password:dic[@"mobile"] completion:^(NSDictionary *loginInfo, EMError *error) {
//                if (!error.errorCode) {
//                    NSLog(@"登录成功");
//                    [UdStorage storageObject:dic[@"mobile"] forKey:UserName];
//                    [UdStorage storageObject:dic[@"app_user_id"] forKey:Userid];
//                    [UdStorage storageObject:dic[@"app_user_type"] forKey:UserType];
//                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }else{
//                    NSLog(@"%@%ld",error.description,(long)error.errorCode);
//                }
//                
//            } onQueue:nil];
//        }else{
//            YSThreePinlessViewController *vc = [[YSThreePinlessViewController alloc]init];
//            vc.type =paramas[@"type"];
//            vc.accout = paramas[@"accout"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    } failure:^(NSError *error) {
//        
//    } animated:NO];
}


//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return  UIStatusBarStyleDefault;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

