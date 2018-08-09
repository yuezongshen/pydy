//
//  PBMienViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/16.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBMienViewController.h"
#import "ZQHtmlViewController.h"

#import "PBPlayView.h"
#import "PBPlayListView.h"

#import "PBPlayViewController.h"

@interface PBMienViewController ()<UITableViewDelegate,UITableViewDataSource,PBPlayViewControllerDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) NSMutableArray *mienList;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) PBPlayView *playView;
@property (nonatomic, strong) PBPlayListView *playListView;
@property (nonatomic, assign) NSInteger playIndex;
@end

@implementation PBMienViewController

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
    NSDictionary *dic = self.mienList[self.playIndex];
    self.playView.titleLabel.text = [Utility verifyActionWithString:dic[@"InfoTitle"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mienList = [NSMutableArray arrayWithCapacity:0];
    page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.playView];
     [self getMienListData];
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getMienListData];
    }];
//    [self.tableView.mj_header beginRefreshing];
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
   
}
- (void)getMienListData
{
    
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"api/index/typelist" withParameters:@{@"page":@"1",@"type":@"62"} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.mienList = [NSMutableArray arrayWithArray:array];
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView.mj_header endRefreshing];
                        if (weakSelf.mienList.count<10) {
                            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                        }

                        NSDictionary *dic = strongSelf.mienList.firstObject;
                        weakSelf.playView.playString = dic[@"InfoContent"];
                        [weakSelf.playView.titleLabel setText:dic[@"InfoTitle"]];
                    }
                }
            }
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
    
    [JKHttpRequestService POST:@"api/index/typelist" withParameters:@{@"page":[NSString stringWithFormat:@"%ld",(long)page],@"type":@"62"} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
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
                        [strongSelf.mienList addObjectsFromArray:array];
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                }
            }
        }
        else
        {
            [weakSelf.tableView.mj_footer endRefreshing];
            
            [ZQLoadingView showAlertHUD:jsonDic[@"info"] duration:SXLoadingTime];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        [weakSelf.tableView.mj_footer endRefreshing];

    } animated:NO];
}
- (void)nextBtnAction
{
    if (self.mienList.count>self.playIndex) {
        self.playIndex++;
        [self.playView.titleLabel setText:self.mienList[_playIndex][@"InfoTitle"]];
        [self.playView playActionWithString:self.mienList[_playIndex][@"InfoContent"]];
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"没有更多了" duration:SXLoadingTime];
    }
}
- (void)listBtnAction
{
    if (!self.mienList.count) {
        [ZQLoadingView showAlertHUD:@"没有播放内容" duration:SXLoadingTime];
    }
    [self.view addSubview:self.playListView];
    CGRect rect = self.playListView.frame;
    rect.origin.y = CGRectGetHeight(self.view.bounds) -CGRectGetHeight(rect);
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
        rect.size.height -=50;
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
                PBPlayViewController *playVc = [[PBPlayViewController alloc] init];
                playVc.pPlayIndex = strongSelf.playIndex;
                playVc.playContentDic = strongSelf.mienList[strongSelf.playIndex];
                playVc.playContentArray = strongSelf.mienList;
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
        _playListView.seletedIndex = self.playIndex;
        _playListView.playListArr = self.mienList;
        [_playListView.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        WK(weakSelf);
        _playListView.cellAction = ^(NSInteger index) {
            weakSelf.playIndex = index;
            [weakSelf.playView.titleLabel setText:weakSelf.mienList[index][@"InfoTitle"]];
            [weakSelf.playView playActionWithString:weakSelf.mienList[index][@"InfoContent"]];
        };
    }
    return _playListView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mienList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PBMienCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    NSDictionary *dic = self.mienList[indexPath.row];
    [cell.textLabel setText:dic[@"InfoTitle"]];
    [cell.detailTextLabel setText:dic[@"InfoTime"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.mienList[indexPath.row];
    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:[NSString stringWithFormat:@"http://dangj.sztd123.com/api/index/xiangqing?infoid=%@",[Utility verifyActionWithString:dic[@"InfoID"]]] andShowBottom:0];
    Vc.title = @"详情页";
    [self.navigationController pushViewController:Vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [Utility speakActionWithString:dic[@"InfoContent"]];

    [Utility requestAlreadyReadWithId:dic[@"InfoID"]];
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
