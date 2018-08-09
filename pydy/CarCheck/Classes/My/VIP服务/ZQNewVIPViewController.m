//
//  ZQNewVIPViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/17.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNewVIPViewController.h"
#import "ZQBuyVipViewController.h"

@interface ZQNewVIPViewController ()

@end

@implementation ZQNewVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP会员服务";

}
- (IBAction)goBuyAction:(id)sender {
    ZQBuyVipViewController *buyVC = [[ZQBuyVipViewController alloc] init];
    [self.navigationController pushViewController:buyVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
