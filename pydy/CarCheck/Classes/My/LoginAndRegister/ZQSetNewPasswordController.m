//
//  ZQSetNewPasswordController.m
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/3.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQSetNewPasswordController.h"
#import "ZQLoadingView.h"
#import "NSString+Validation.h"

@interface ZQSetNewPasswordController ()<UITextFieldDelegate>

@property (strong,nonatomic) UIScrollView *backV;

@property (strong,nonatomic) NSString *mobile;//手机

@property (strong,nonatomic) NSString *passWord;//密码

@end

@implementation ZQSetNewPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置新密码";
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageV.image = [UIImage imageNamed:@"info_bg"];
    [self.view addSubview:bgImageV];
    self.mobile = [Utility getUserPhone];

    [self initView];
}

-(void)initView
{
    _backV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor clearColor];
    _backV.contentSize = CGSizeMake(__kWidth, 667+70);
    
    //main
//    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-60)/2, 74, 60, 60)];
//    [_backV addSubview:loginIV];
//    //    loginIV.image =MImage(@"CJWY");
//    loginIV.image = MImage(@"appIcon");
//    loginIV.contentMode = UIViewContentModeScaleAspectFit;
    
    NSArray *imageArr =@[@"login_password",@"login_password"];
    for (int i=0; i<imageArr.count; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, 74+30+70*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor= [UIColor colorWithWhite:1.0 alpha:0.6];
        putV.layer.cornerRadius = 23;
        putV.clipsToBounds = YES;
        
        UIImageView *headIV = [[UIImageView alloc] init];
        headIV.contentMode = UIViewContentModeScaleAspectFit;
        [putV addSubview:headIV];
        headIV.image =MImage(imageArr[i]);
        
        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 13, __kWidth-180, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i;
        inputTF.secureTextEntry = YES;
        inputTF.delegate = self;
        inputTF.textColor = [UIColor whiteColor];
        switch (i) {
            case 0:{
                headIV.frame = CGRectMake(15, 12, 15, 23);
                inputTF.placeholder = @"输入密码";
                inputTF.text = self.mobile;
            }
                break;
            case 1:{
                headIV.frame = CGRectMake(15, 11, 18, 24);
                inputTF.placeholder = @"请再次输入新密码";
            }
                break;
            case 2:{
                inputTF.placeholder = @"请输入您的密码";
                inputTF.secureTextEntry = YES;
                break;
            }
            default:
                break;
        }
    }
    UIButton *registerBtn= [[UIButton alloc]initWithFrame:CGRectMake(100, 76+230, __kWidth-200, 56)];
    [_backV addSubview:registerBtn];
    registerBtn.backgroundColor = __MoneyColor;
    registerBtn.layer.cornerRadius = 28;
    registerBtn.titleLabel.font = BFont(18);
    [registerBtn setTitle:@"提交新密码" forState:BtnNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [registerBtn addTarget:self action:@selector(regiSter) forControlEvents:BtnTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-30, CGRectGetWidth(self.view.frame), 30)];
    label.text = @"版权所有: 平遥古城景区旅游发展有限公司";
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

#pragma mark ==注册==
-(void)regiSter{
    [self.view endEditing:YES];
   
    if (!_passWord) {
        [ZQLoadingView showAlertHUD:@"请输入密码" duration:1.5];
        return;
    }
    //注册接口
    //    NSString *urlStr = [NSString stringWithFormat:@"daf/my_userInsert/phone/%@/password/%@",_mobile,_passWord];
    __weak __typeof(self)weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/modifyPassword" withParameters:@{@"phone":_mobile,@"password":_passWord} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [Utility storageObject:strongSelf.mobile forKey:@"userPhone"];
                [strongSelf.navigationController popViewControllerAnimated:YES];
                //保存用户名
                //                [UdStorage storageObject:strongSelf.mobile forKey:@"User_phone"];
            }
        }
        else
        {
            [ZQLoadingView showProgressHUD:jsonDic[@"info"] duration:SXLoadingTime];
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
    
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
          _passWord = textField.text;
            break;
        }
        case 1:
        {
            if ([textField.text isEqualToString:_passWord]) {
                _passWord = nil;
            }
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
