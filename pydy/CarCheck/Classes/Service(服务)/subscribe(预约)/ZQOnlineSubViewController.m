//
//  ZQOnlineSubViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/6.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQOnlineSubViewController.h"
#import "ZQOnlineAlertView.h"
#import "ZQSuccessAlerView.h"
#import "ZQUpSubdataViewController.h"
#import "ZQInspectionListController.h"
#import "ZQHtmlViewController.h"

@interface ZQOnlineSubViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataArray;
}
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *onlineList;
@end

@implementation ZQOnlineSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线预约";
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

-(void)getData {
    
//    _dataArray = @[@"自行开车到检车机构上线检测",@"上门接送检车"];
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_Id"];
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.onlineList = @[@"自行上线检车",@"上门接送检车"];
    [self.view addSubview:self.tableView];
    
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.onlineList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ZQOnLineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    cell.textLabel.text = self.onlineList[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageType) {
        if (indexPath.section) {
//            NSString *htmlStr = @"reservationNotice2.html";
//            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr testId:self.o_testing_id andShowBottom:3];
            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.6" testId:self.o_testing_id andShowBottom:3];
            Vc.title = @"机动车上门接送检车须知";
            if ([Utility getIs_vip])
            {
                Vc.charge = [Utility getDoorToDoorOutlay_VIP].floatValue;
            }
            else
            {
                Vc.charge = [Utility getDoorToDoorOutlay].floatValue;
            }
            Vc.classString = NSStringFromClass([ZQUpSubdataViewController class]);
            Vc.dSubType = 2;
            [self.navigationController pushViewController:Vc animated:YES];
        }
        else
        {
//            NSString *htmlStr = @"reservationNotice3.html";
//            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:htmlStr testId:self.o_testing_id andShowBottom:3];
            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.2" testId:self.o_testing_id andShowBottom:3];
            Vc.title = @"预约须知";
            Vc.classString = NSStringFromClass([ZQUpSubdataViewController class]);
            Vc.dSubType = 0;
            [self.navigationController pushViewController:Vc animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

//        ZQUpSubdataViewController *subVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
//        [self.navigationController pushViewController:subVC animated:YES];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        return;
    }
    if (indexPath.section) {
      
//        ZQOnlineAlertView *alerView = [[ZQOnlineAlertView alloc] initWithFrame:CGRectMake(0, 0, __kWidth, __kHeight)];
//        alerView.handler = ^(NSArray *contenArr)
//        {
//            [contenArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSLog(@"上门接送车提交内容:%@",obj);
//            }];
//            //                    [ZQLoadingView makeSuccessfulHudWithTips:@"上传完成" parentView:nil];
//
//            [ZQSuccessAlerView showCommitSuccess];
//        };
//        [alerView show];
        
        ZQSubScType type = ZQSubScTypeVisit;
        ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
        inspectionVC.subType = type;
        [self.navigationController pushViewController:inspectionVC animated:YES];
    }else{
//        ZQUpSubdataViewController *subVC = [[ZQUpSubdataViewController alloc] initWithNibName:@"ZQUpSubdataViewController" bundle:nil];
//        [self.navigationController pushViewController:subVC animated:YES];
        
        ZQSubScType type = ZQSubScTypeDefailt;
        ZQInspectionListController *inspectionVC = [[ZQInspectionListController alloc] init];
        inspectionVC.subType = type;
        [self.navigationController pushViewController:inspectionVC animated:YES];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.backgroundColor = MainBgColor;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView = tableView;
    }
    return _tableView;
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
