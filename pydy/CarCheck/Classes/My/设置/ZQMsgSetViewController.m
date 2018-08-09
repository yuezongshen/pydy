//
//  ZQMsgSetViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMsgSetViewController.h"
#import "ZQMsgFootView.h"

@interface ZQMsgSetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titleArray;
    NSArray *_contentArray;
}
@property (strong,nonatomic) UITableView *tableView;
@property (assign,nonatomic) BOOL isNoti;

@end

@implementation ZQMsgSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息通知设置";
    _titleArray = @[@[@"接受新消息通知"],@[@"通知显示消息详情"],@[@"声音"]];
    _contentArray = @[[NSString stringWithFormat:@"如果你要关闭或开启'%@'的新消息通知，请在iPhone的'设置'-'通知'功能中，找到应用程序'%@'进行更改",ZQPROJECTNAME,ZQPROJECTNAME],[NSString stringWithFormat:@"关闭后，当收到'%@'的违章信息时，通知提示将不显示通知内容",ZQPROJECTNAME]];
    _isNoti = YES;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO) { //iOS8以上包含iOS8
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types==UIRemoteNotificationTypeNone) {
            _isNoti = NO;
        }
    }else{ // ios7 一下
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]==UIRemoteNotificationTypeNone) {
            _isNoti = NO;
        }
    }
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height ) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
        _tableView.estimatedSectionHeaderHeight = 10;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
#pragma mark ==UITableViewDelegate==
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = _titleArray[section];
    return tempArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"YSettingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"YSettingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor darkTextColor];
    cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        if (_isNoti) {
            cell.detailTextLabel.text = @"已开启";
        }
        else
        {
            cell.detailTextLabel.text = @"已关闭";
        }
//        cell.accessoryView = nil;
    }else{
        UISwitch *switChoose = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 54, 31)];
        [switChoose addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        switChoose.tag = indexPath.section;
        switChoose.on= _isNoti;
        cell.accessoryView = switChoose;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section ==2) {
        return nil;
    }
    CGFloat height = 54;
    if (section==0) {
        height = 74;
    }
    ZQMsgFootView *footer = [[ZQMsgFootView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, height)];
    footer.title = _contentArray[section];
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 74;
    }
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)switchAction:(UISwitch *)sender
{
    if (_isNoti) {
        sender.on = !sender.on;
        [Utility storageAgreeReservationNotice:sender.on forKey:@"NotiSound"];
    }
    else
    {
        sender.on = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"检测到系统消息通知被关闭，请先打开系统的消息通知。请在'设置'-'通知'功能中，找到应用程序'%@',开启允许通知",ZQPROJECTNAME] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        }]];
        [self presentViewController:alert animated:YES completion:nil];
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
