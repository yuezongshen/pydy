//
//  PBPayListViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/21.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBPayListViewController.h"
#import "PBPayListCell.h"
#import "YPayViewController.h"

@interface PBPayListViewController ()

@property (nonatomic, strong) NSMutableArray *payList;
@end

@implementation PBPayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"党员缴费";
    self.payList = [NSMutableArray arrayWithCapacity:0];
    [self getPayListData];
}
- (void)getPayListData
{
    for (int i = 0; i<15; i++) {
        if (i%2) {
            [self.payList addObject:@{@"name":@"10月党费缴纳"}];
        }
        else
        {
            [self.payList addObject:@{@"name":@"心系灾区，爱心传递"}];
        }
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.payList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PBPayListCell PayListCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PBMienCell";
    PBPayListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[PBPayListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        [cell.payBtn addTarget:self action:@selector(goToPayVcAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.payBtn setTag:indexPath.row];
    NSDictionary *dic = self.payList[indexPath.row];
    [cell setPayListContent:dic];
    return cell;
}
- (void)goToPayVcAction:(UIButton *)sender
{
    YPayViewController *payVC = [[YPayViewController alloc] init];
    payVC.payMoney = @"100";
    payVC.aPayType = ZQPayVIPView;
    __weak typeof(self) weakSelf = self;
    payVC.paySuccess = ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf)
        {
        }
    };
    [self.navigationController pushViewController:payVC animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
