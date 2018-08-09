//
//  ZQMyBookingViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyBookingViewController.h"
#import "ZQMyBooingCell.h"

#import "ZQHtmlViewController.h"
@interface ZQMyBookingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *bookingList;
@end

@implementation ZQMyBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的预约";
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAgencyListData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)getAgencyListData
{
    __weak __typeof(self) weakSelf = self;
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (weakSelf.bookingList.count) {
            [weakSelf.bookingList removeAllObjects];
            [weakSelf.bookingList addObject:@{@"name":@"自行开车到检车机构上线检测",@"time":@"2017-09-01  14:30",@"contact":@"高先生",@"phone":@"18120732580",@"money":@"￥50.00"}];
        }
        else
        {
            weakSelf.bookingList = [NSMutableArray arrayWithObject:@{@"name":@"自行开车到检车机构上线检测",@"time":@"2017-09-01  14:30",@"contact":@"高先生",@"phone":@"18120732580",@"money":@"￥50.00"}];
        }
        for (int i = 0; i<5; i++) {
            NSDictionary *dic = @{@"name":@"自行开车到检车机构上线检测",@"time":@"2017-09-01  14:30",@"contact":@"高先生",@"phone":@"18120732580",@"money":@"￥50.00"};
            [self.bookingList addObject:dic];
        }
        if (weakSelf.bookingList.count<3) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [tableView.mj_header endRefreshing];
    });
}
- (void)loadMoreData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        NSDictionary *dic = @{@"name":@"自行开车到检车机构上线检测",@"time":@"2017-09-01  14:30",@"contact":@"高先生",@"phone":@"18120732580",@"money":@"￥50.00"};
        [self.bookingList addObject:dic];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    __weak UITableView *tableView = self.tableView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [tableView.mj_footer endRefreshing];
    });
}
#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookingList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ZQMyBooingCell";
    ZQMyBooingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ZQMyBooingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell.agencyDetailBtn addTarget:self action:@selector(agencyDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.endorseBtn addTarget:self action:@selector(endorseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
//    cell.agencyDetailBtn.tag = indexPath.row;
    cell.orderModel = self.bookingList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZQMyBooingCell myBooingCellHeight];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf1/255.0 blue:0xf4/255.0 alpha:1.0];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView = tableView;
    }
    return _tableView;
}

//机构详情
- (void)agencyDetailBtnAction:(UIButton *)sender
{
//    ZQOrderModel *model = self.dataArr[sender.tag];
    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"agency.html" andShowBottom:YES];
    Vc.title = @"机构详情";
    [self.navigationController pushViewController:Vc animated:YES];
}
//改签订单
- (void)endorseBtnAction:(UIButton *)sender
{
    
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
