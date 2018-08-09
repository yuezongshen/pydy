//
//  PBMemberEduViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/19.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBMemberEduViewController.h"
#import "ZQHtmlViewController.h"
#import "PBMemberEduCell.h"
#import "PBActivityDetailController.h"

#import "PBPlayView.h"
#import "PBPlayListView.h"

#import "PBPlayViewController.h"

#import "UIViewController+MMDrawerController.h"

@interface PBMemberEduViewController ()<UITableViewDelegate,UITableViewDataSource,PBPlayViewControllerDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) NSMutableArray *eduList;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PBPlayView *playView;
@property (nonatomic, strong) PBPlayListView *playListView;
@property (nonatomic, assign) NSInteger playIndex;
@end

@implementation PBMemberEduViewController

-(void)NextUpBtnCallBackAction:(NSInteger)temp
{
    switch (temp) {
        case 0:
        {
            //                暂停
            [self.playView checkPlayBtnStatus:NO];
            return;
        }
            break;
        case 4:
        {
            //                开始
            [self.playView checkPlayBtnStatus:YES];
            return;
        }
            break;
        case 1:
        {
            //                        上篇
            
            self.playIndex--;
            
        }
            break;
        case 2:
        {
            //                        下篇
            self.playIndex++;
        }
        default:
            break;
    }
    NSDictionary *dic = self.eduList[self.playIndex];
    self.playView.titleLabel.text = [Utility verifyActionWithString:dic[@"InfoTitle"]];
}
- (void)dealloc
{
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.pageStyle) {
        [self.view addSubview:self.playView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.eduList = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.tableView];
    [self getEduListData];

    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getEduListData];
    }];
//    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}
- (void)getEduListData
{
    NSString *url = nil;
    NSDictionary *dic = nil;
    switch (self.pageStyle) {
        case 1:
            {
//                我的支部
                url =@"api/Ln/myzhibu";
                dic = @{@"page":@"1",@"token":[Utility getWalletPayPassword]};
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            break;
            case 2:
        {
            
//        我的活动
            url =@"api/Ln/myhuodong";
            dic = @{@"page":@"1",@"token":[Utility getWalletPayPassword]};
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
            break;
        default:
        {
            url =@"api/index/typelist";
            dic = @{@"page":@"1",@"type":@"61"};
        }
            break;
    }
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:url withParameters:dic success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.eduList = [NSMutableArray arrayWithArray:array];
                        
                        [strongSelf.tableView reloadData];
                        [strongSelf.tableView.mj_header endRefreshing];
                        if (strongSelf.eduList.count<10) {
                            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        if (self.pageStyle) {
//                            if (self.pageStyle==1) {
//                                NSDictionary *dic = strongSelf.eduList.firstObject;
//                                NSArray *cArr = dic[@"info"];
//                                if ([cArr isKindOfClass:[NSArray class]]) {
//                                    weakSelf.playView.playString = cArr[0][@"InfoContent"];
//                                    [weakSelf.playView.titleLabel setText:cArr[0][@"InfoTitle"]];
//                                }
//                            }
                        }
                        else
                        {
                            NSDictionary *dic = strongSelf.eduList.firstObject;
                            weakSelf.playView.playString = dic[@"InfoContent"];
                            [weakSelf.playView.titleLabel setText:dic[@"InfoTitle"]];
                        }
                    }
                }
            }
        }
        else
        {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        [weakSelf.tableView.mj_header endRefreshing];
    } animated:NO];
}
- (void)loadMoreData
{
    page++;
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    
    [JKHttpRequestService POST:@"api/index/typelist" withParameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)page],@"type":@"61"} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        if (array.count<10) {
                            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                        }
                        [strongSelf.eduList addObjectsFromArray:array];
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                }
            }
        }
        else
        {
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            [ZQLoadingView showAlertHUD:jsonDic[@"info"] duration:SXLoadingTime];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        [weakSelf.tableView.mj_footer endRefreshing];
    } animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)playActionWithPlayIndexDic
{
    if (self.pageStyle) {
        NSDictionary *dic = nil;
        NSArray *cArr = self.eduList[_playIndex][@"info"];
        if ([cArr isKindOfClass:[NSArray class]]) {
            if (cArr.count) {
                dic = cArr[0];
            }
        }
        [self.playView.titleLabel setText:dic[@"InfoTitle"]];
        [self.playView playActionWithString:dic[@"InfoContent"]];
    }
    else
    {
        [self.playView.titleLabel setText:self.eduList[_playIndex][@"InfoTitle"]];
        [self.playView playActionWithString:self.eduList[_playIndex][@"InfoContent"]];
    }
}
- (void)nextBtnAction
{
    if (self.eduList.count>self.playIndex) {
        self.playIndex++;
        [self playActionWithPlayIndexDic];
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"没有更多了" duration:SXLoadingTime];
    }
}
- (void)listBtnAction
{
    if (!self.eduList.count) {
        [ZQLoadingView showAlertHUD:@"没有播放内容" duration:SXLoadingTime];
    }
    [self.view addSubview:self.playListView];
    CGRect rect = self.playListView.frame;
    rect.origin.y = CGRectGetHeight(self.view.bounds)-CGRectGetHeight(rect);
    [UIView animateWithDuration:0.35 animations:^{
        self.playListView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)closeBtnAction
{
    CGRect rect = self.playListView.frame;
    rect.origin.y = KHeight;
    [UIView animateWithDuration:0.35 animations:^{
        self.playListView.frame = rect;
    } completion:^(BOOL finished) {
        [self.playListView removeFromSuperview];
        self.playListView = nil;
    }];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect rect = self.view.bounds;
        //        if (kDevice_Is_iPhoneX) {
        //            rect.size.height -= 88;
        //        }
        //        else
        //        {
        //            rect.size.height -= 64;
        //        }
        if (!self.pageStyle) {
            rect.size.height -=50;
        }
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
        tableView.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf1/255.0 blue:0xf4/255.0 alpha:1.0];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView = tableView;
    }
    return _tableView;
}
- (PBPlayView *)playView
{
    if (!_playView) {
        _playView = [[PBPlayView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.view.frame), 50)];
        [_playView.nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_playView.listBtn addTarget:self action:@selector(listBtnAction) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        _playView.viewAction = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
//                NSDictionary *dic = strongSelf.eduList[strongSelf.playIndex];
//                if (strongSelf.pageStyle==1)
//                {
//                    NSArray *cArr = dic[@"info"];
//                    if ([cArr isKindOfClass:[NSArray class]]) {
//                        if (cArr.count) {
//                            dic = cArr[0];
//                        }
//                    }
//                }
                PBPlayViewController *playVc = [[PBPlayViewController alloc] init];
                playVc.pPlayIndex = strongSelf.playIndex;
                playVc.isMyData = strongSelf.pageStyle;
                playVc.playContentDic = strongSelf.eduList[strongSelf.playIndex];
                playVc.playContentArray = strongSelf.eduList;
                playVc.pDelegate = strongSelf;
                playVc.isStop = strongSelf.playView.playBtn.selected;
                [strongSelf.navigationController pushViewController:playVc animated:YES];
            }
        };
    }
    return _playView;
}
- (PBPlayListView *)playListView
{
    if (!_playListView) {
        _playListView = [[PBPlayListView alloc] initWithFrame:CGRectMake(0, KHeight, CGRectGetWidth(self.view.frame), 400)];
        _playListView.isMyDataList = self.pageStyle;
        _playListView.seletedIndex = self.playIndex;
        _playListView.playListArr = self.eduList;
        [_playListView.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        WK(weakSelf);
        _playListView.cellAction = ^(NSInteger index) {
            weakSelf.playIndex = index;
            [weakSelf playActionWithPlayIndexDic];
//            [weakSelf.playView.titleLabel setText:weakSelf.eduList[index][@"InfoTitle"]];
//            [weakSelf.playView playActionWithString:weakSelf.eduList[index][@"InfoContent"]];
        };
    }
    return _playListView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eduList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PBMemberEduCell EduCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"PBMemberEduCell";
    PBMemberEduCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[PBMemberEduCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (self.pageStyle==2) {
        NSArray *array = self.eduList[indexPath.row][@"info"];
        if ([array isKindOfClass:[NSArray class]]) {
            NSDictionary *dic = array[0];
            [cell setEduContent:dic type:0];
        }
        else
        {
            [cell setEduContent:nil type:0];
        }
        [cell.markLabel removeFromSuperview];
        [cell.attachLabel setText:@"20人已参与"];
    }
    else
    {
        if (self.pageStyle == 1) {
            NSArray *array = self.eduList[indexPath.row][@"info"];
            if ([array isKindOfClass:[NSArray class]]) {
                NSDictionary *dic = array[0];
                [cell setEduContent:dic type:1];
            }
            else
            {
                [cell setEduContent:nil type:1];
            }
        }
        else
        {
            NSDictionary *dic = self.eduList[indexPath.row];
            [cell setEduContent:dic type:1];
        }
        [cell.attachLabel removeFromSuperview];
        if (indexPath.row%2) { 
            [cell.markLabel setBackgroundColor:HEXCOLOR(0xf23939)];
        }
        else
        {
            [cell.markLabel setBackgroundColor:HEXCOLOR(0x68b84c)];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageStyle==2) {
//
        NSDictionary *dic = self.eduList[indexPath.row];
        PBActivityDetailController *Vc = [[PBActivityDetailController alloc] init];
        Vc.title = @"活动详情";
        Vc.activityId = dic[@"id"];
        [self.navigationController pushViewController:Vc animated:YES];

    }
    else
    {
        NSDictionary *dic = self.eduList[indexPath.row];
        if (self.pageStyle==1) {
            NSArray *array = self.eduList[indexPath.row][@"info"];
            if ([array isKindOfClass:[NSArray class]]) {
                dic = array[0];
                PBPlayViewController *playVc = [[PBPlayViewController alloc] init];
                playVc.pPlayIndex = indexPath.row;
                playVc.isMyData = YES;
                playVc.playContentDic = dic;
                playVc.playContentArray = self.eduList;
                playVc.isShouldStop = YES;
                [self.navigationController pushViewController:playVc animated:YES];
                return;
            }
            else
            {
                [ZQLoadingView showAlertHUD:@"数据为空" duration:SXLoadingTime];
                return;
            }
        }
        ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:[NSString stringWithFormat:@"http://dangj.sztd123.com/api/index/xiangqing?infoid=%@",[Utility verifyActionWithString:dic[@"InfoID"]]] andShowBottom:0];
        Vc.title = @"详情页";
        [self.navigationController pushViewController:Vc animated:YES];
//        [Utility speakActionWithString:dic[@"InfoContent"]];
        [Utility requestAlreadyReadWithId:dic[@"InfoID"]];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
