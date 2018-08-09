//
//  ZQGoViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/7/3.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQGoViewController.h"
#import "ZQLoginViewController.h"
#import "ZQRegisterViewController.h"

@interface ZQGoViewController ()

@end

@implementation ZQGoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"平遥古城导游管理";
    
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageV.image = [UIImage imageNamed:@"info_bg"];
    [self.view addSubview:bgImageV];
    
    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 160, 160)];
    loginIV.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    loginIV.image = MImage(@"appIcon");
    loginIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:loginIV];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(loginIV.frame), CGRectGetWidth(self.view.frame), 30)];
    label.text = @"平遥古城导游管理APP";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = __MoneyColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    CGFloat btnWidth = 120;
    CGFloat space = (CGRectGetWidth(self.view.frame)-btnWidth*2)/3;
    UIButton *regBtn = [[UIButton alloc]initWithFrame:CGRectMake(space, CGRectYH(self.view)-170, btnWidth, 40)];
    [self.view addSubview:regBtn];
    regBtn.backgroundColor = HEXCOLOR(0xbebebe);
    regBtn.layer.cornerRadius = 20;
    regBtn.titleLabel.font = MFont(18);
    [regBtn setTitle:@"注册" forState:BtnNormal];
    [regBtn setTitleColor:[UIColor darkGrayColor] forState:BtnNormal];
    [regBtn addTarget:self action:@selector(regBtnAction) forControlEvents:BtnTouchUpInside];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(regBtn.frame)+space, CGRectGetMinY(regBtn.frame), btnWidth, 40)];
    [self.view addSubview:loginBtn];
    loginBtn.backgroundColor = __MoneyColor;
    loginBtn.layer.cornerRadius = 20;
    loginBtn.titleLabel.font = MFont(18);
    [loginBtn setTitle:@"登陆" forState:BtnNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:BtnTouchUpInside];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-60, CGRectGetWidth(self.view.frame), 60)];
    label.text = @"版权所有: 平遥古城景区旅游发展有限公司";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}
- (void)loginAction
{
    ZQLoginViewController *login = [[ZQLoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}
- (void)regBtnAction
{
    ZQRegisterViewController *regVc = [[ZQRegisterViewController alloc] init];
    [self.navigationController pushViewController:regVc animated:YES];
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
