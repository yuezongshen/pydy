//
//  ZQVIPViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/17.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQVIPViewController.h"

@interface ZQVIPViewController ()

@end

@implementation ZQVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP会员服务";
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    [imageV setImage:[UIImage imageNamed:@"icon29"]];
    [self.view addSubview:imageV];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, 30, 30, 30)];
    [imageV setImage:[UIImage imageNamed:@"icon29"]];
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame),CGRectGetMinY(imageV.frame),180, 30)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor darkTextColor];
    label.text = @" 您还没有购买会员卡，赶紧行动吧";
    [self.view addSubview:label];
}

- (void)createCard
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 260)];
    imageV.layer.cornerRadius = 6;
    imageV.layer.masksToBounds = YES;
    [imageV setBackgroundColor:[UIColor brownColor]];
    [imageV setUserInteractionEnabled:YES];
    [self.view addSubview:imageV];
    
    
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
