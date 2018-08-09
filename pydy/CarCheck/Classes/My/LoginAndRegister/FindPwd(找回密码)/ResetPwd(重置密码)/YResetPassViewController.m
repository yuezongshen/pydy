//
//  YResetPassViewController.m
//  shopsN
//
//  Created by imac on 2017/2/14.
//  Copyright © 2017年 联系QQ:1084356436. All rights reserved.
//

#import "YResetPassViewController.h"
#import "ZQLoginViewController.h"

@interface YResetPassViewController ()<UITextFieldDelegate>

@property (strong,nonatomic) UIView *backV;
/**新密码*/
@property (strong,nonatomic) NSString *passWord;
/**验证密码*/
@property (strong,nonatomic) NSString *rePassWord;

@end

@implementation YResetPassViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
    [cancelBtn setTitle:@"返回" forState:BtnNormal];
    [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:BtnNormal];
    [cancelBtn addTarget:self action:@selector(back) forControlEvents:BtnTouchUpInside];

    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake((__kWidth-120)/2, 32, 120, 20)];
    [NaviV addSubview:titleLb];
    titleLb.textAlignment =NSTextAlignmentCenter;
    titleLb.font = BFont(16);
    titleLb.textColor = __DTextColor;
    titleLb.text = @"重置密码";
}

-(void)initView{
    _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 65, __kWidth, __kHeight-65)];
    [self.view addSubview:_backV];
    _backV.backgroundColor = [UIColor whiteColor];

    for (int i=0; i<2; i++) {
        UIView *putV = [[UIView alloc]initWithFrame:CGRectMake(30, 20+70*i, __kWidth-60, 46)];
        [_backV addSubview:putV];
        putV.backgroundColor = MainBgColor;
        putV.layer.cornerRadius = 5;

        UIImageView *headIV = [[UIImageView alloc]initWithFrame:CGRectMake(11, 11, 24, 24)];
        [putV addSubview:headIV];
        headIV.image = MImage(@"login_password");

        UITextField *inputTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 13, __kWidth-210, 20)];
        [putV addSubview:inputTF];
        inputTF.font = MFont(14);
        inputTF.tag = i+23;
        inputTF.delegate = self;

        switch (i) {
            case 0:
            {
                inputTF.placeholder = @"请输入新密码...";
            }
                break;

            case 1:{
                inputTF.placeholder = @"请再次输入新密码...";
            }
            default:
                break;
        }
    }

    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 180, __kWidth-60, 6)];
    [_backV addSubview:saveBtn];
    saveBtn.layer.cornerRadius =28;
    saveBtn.backgroundColor = __DefaultColor;
    saveBtn.titleLabel.font = BFont(18);
    [saveBtn setTitle:@"确定修改" forState:BtnNormal];
    [saveBtn addTarget:self action:@selector(sureSave) forControlEvents:BtnTouchUpInside];


}



- (void)sureSave{
//    [JKHttpRequestService POST:@"Register/resetPassword" withParameters:@{@"app_user_id":[UdStorage getObjectforKey:Userid],@"newPassword1":_passWord,@"newPassword2":_rePassWord} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        if (succe) {
//            NSArray *vcs = self.navigationController.viewControllers;
//            for (UIViewController *vc in vcs) {
//                if ([vc isKindOfClass:[ZQLoginViewController class]]) {
//                    [self.navigationController popToViewController:vc animated:YES];
//                }
//            }
//        }
//    } failure:^(NSError *error) {
//
//    } animated:YES];



}

#pragma mark ==UITextfiledDelegate==
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    switch (textField.tag-23) {
        case 0:
        {
            _passWord = textField.text;
        }
            break;
        case 1:
        {
            _rePassWord = textField.text;
        }
            break;
        default:
            break;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
