//
//  ZQMaintainViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMaintainViewController.h"

#import "ZQMaintainCell.h"

#import "ZQHtmlViewController.h"
#import "ZQAlerInputView.h"

#import "PBPlayView.h"
#import "PBPlayListView.h"


#import "PBPlayViewController.h"

@interface ZQMaintainViewController ()<UITableViewDelegate,UITableViewDataSource,PBPlayViewControllerDelegate>
{
    NSInteger page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *agencyList;

@property (nonatomic, strong) PBPlayView *playView;
@property (nonatomic, strong) PBPlayListView *playListView;
@property (nonatomic, assign) NSInteger playIndex;
@end

@implementation ZQMaintainViewController

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
    NSDictionary *dic = self.agencyList[self.playIndex];
    self.playView.titleLabel.text = [Utility verifyActionWithString:dic[@"InfoTitle"]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.styleIndex !=111) {
        [self.view addSubview:self.playView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.agencyList = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.tableView];
    [self getAgencyListData];

    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getAgencyListData];
    }];
//    [self.tableView.mj_header beginRefreshing];

    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)getAgencyListData
{
    NSString *url = nil;
    NSDictionary *param = nil;
    switch (self.styleIndex) {
        case 100:
        {
//          http://dangj.sztd123.com/api/Ln/mylearning
            url = @"api/index/zx";
            param = @{@"page":@"1"};
        }
            break;
        case 111:
        {
            //          http://dangj.sztd123.com/api/
//            我的学习
            url = @"api/Ln/mylearning";
            param = @{@"page":@"1",@"token":[Utility getWalletPayPassword]};
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
            break;
        default:
        {
            url = @"api/index/typelist";
            param = @{@"page":@"1",@"type":[self getPostType]};
        }
            break;
    }
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:url withParameters:param success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.agencyList = [NSMutableArray arrayWithArray:array];
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView.mj_header endRefreshing];
                        if (weakSelf.agencyList.count<10) {
                            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                        }

                        NSDictionary *dic = strongSelf.agencyList.firstObject;
                        weakSelf.playView.playString = dic[@"InfoContent"];
                        [weakSelf.playView.titleLabel setText:dic[@"InfoTitle"]];
                    }
                }
            }
        }
        else
        {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        [weakSelf.tableView.mj_header endRefreshing];
    } animated:NO];
//    return;
//    __weak __typeof(self) weakSelf = self;
//    __weak UITableView *tableView = self.tableView;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        if (weakSelf.agencyList.count) {
//            [weakSelf.agencyList removeAllObjects];
//            [weakSelf testgogo];
//        }
//        else
//        {
//            [weakSelf testgogo];
//
//        }
//
//        if (weakSelf.agencyList.count<3) {
//            [tableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        [tableView reloadData];
//
//        // 拿到当前的下拉刷新控件，结束刷新状态
//        [tableView.mj_header endRefreshing];
//    });
}
- (NSString *)getPostType
{
   
    switch (self.styleIndex) {
         case 0:
        {
            //重要言论
            return @"57";
        }
        case 1:
        {
            //基层党建
            return @"58";
        }
        case 2:
        {
            //            干部工作
            return @"59";
        }
             break;
        case 4:
        {
            //            工作动态
            return @"67";
        }
            break;
        case 6:
        {
            //            人才工作
            return @"60";
        }
            break;
        case 7:
        {
            //            队伍建设
            return @"64";
        }
        case 111:
        {
            //            我的学习
            for (int i = 0; i<15; i++) {
                NSDictionary *dic = @{@"image":@"gzdt2.jpg",@"name":@"相山区委中心组召开理论学习会议市委理论学习...",@"time":@"2018-03-21"};
                [self.agencyList addObject:dic];
            }
        }
            break;
            case 100:
        {
            return @"api/index/zx";
        }
        default:
        {
//            //            队伍建设
//            for (int i = 0; i<15; i++) {
//                NSDictionary *dic = @{@"image":@"gzdt0.jpg",@"name":@"党建资讯党建资讯党建资讯党建资讯党建资讯",@"time":@"2018-03-02"};
//                [self.agencyList addObject:dic];
//            }
            return @"api/index/typelist";
        }
            break;
    }
    return @"";
}
- (void)loadMoreData
{
    page++;
    NSString *url = nil;
    NSDictionary *param = nil;
    switch (self.styleIndex) {
        case 100:
        {
            //          http://dangj.sztd123.com/api/Ln/mylearning
            url = @"api/index/zx";
            param = @{@"page":[NSString stringWithFormat:@"%ld",(long)page]};
        }
            break;
        case 111:
        {
            //          http://dangj.sztd123.com/api/
            //            我的学习
            url = @"api/Ln/mylearning";
            param = @{@"page":[NSString stringWithFormat:@"%ld",(long)page],@"token":[Utility getWalletPayPassword]};
        }
            break;
        default:
        {
            url = @"api/index/typelist";
            param = @{@"page":[NSString stringWithFormat:@"%ld",(long)page],@"type":[self getPostType]};
        }
            break;
    }
//    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    
    [JKHttpRequestService POST:url withParameters:param success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        [ZQLoadingView hideProgressHUD];
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
                        [strongSelf.agencyList addObjectsFromArray:array];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.agencyList.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ZQMaintainCell";
    ZQMaintainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[ZQMaintainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.styleIndex==111) {
        NSArray *array = self.agencyList[indexPath.row][@"info"];
        if ([array isKindOfClass:[NSArray class]]) {
            cell.infoDict = array[0];
        }
        else
        {
            cell.infoDict = nil;
        }
    }
    else
    {
        cell.infoDict = self.agencyList[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZQMaintainCell MaintainCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    http://inanshan.sznews.com/zhuanti/content/2017-11/02/content_17645915.htm
    NSDictionary *dic = self.agencyList[indexPath.row];

//    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"agency" testId:[Utility verifyActionWithString:dic[@"InfoID"]] andShowBottom:0];
    switch (self.styleIndex) {
        case 111:
        {
            NSArray *array = self.agencyList[indexPath.row][@"info"];
            if ([array isKindOfClass:[NSArray class]]) {
                dic = array[0];
                PBPlayViewController *playVc = [[PBPlayViewController alloc] init];
                playVc.pPlayIndex = indexPath.row;
                playVc.isMyData = 1;
                playVc.playContentDic = dic;
                playVc.playContentArray = self.agencyList;
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
            break;
        case 100:
        {
            PBPlayViewController *playVc = [[PBPlayViewController alloc] init];
            playVc.pPlayIndex = indexPath.row;
            playVc.playContentDic = dic;
            playVc.playContentArray = self.agencyList;
            playVc.isShouldStop = YES;
            [self.navigationController pushViewController:playVc animated:YES];
            return;
        }
            break;
        default:
            break;
    }
    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:[NSString stringWithFormat:@"http://dangj.sztd123.com/api/index/xiangqing?infoid=%@",[Utility verifyActionWithString:dic[@"InfoID"]]] andShowBottom:0];
    Vc.title = @"详情页";
    [self.navigationController pushViewController:Vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (self.styleIndex==100) {
//        PBDetailViewController *detailVc = [[PBDetailViewController alloc] init];
//        detailVc.title = @"详情页";
//        detailVc.detailContent = dic;
//        [self.navigationController pushViewController:detailVc animated:YES];
//    }
//    else
//    {
//        PBPlayViewController *playVc = [[PBPlayViewController alloc] init];
//        playVc.playContentDic = dic;
//        playVc.playContentArray = self.agencyList;
//        [self.navigationController pushViewController:playVc animated:YES];
//    }
//    [Utility speakActionWithString:dic[@"InfoContent"]];
    [Utility requestAlreadyReadWithId:dic[@"InfoID"]];
}

//预约
- (void)bookingBtnAction:(UIButton *)sender
{
    [Utility phoneCallAction];
}
- (void)nextBtnAction
{
    if (self.agencyList.count>self.playIndex) {
        self.playIndex++;
        [self playWithSting:self.agencyList[_playIndex][@"InfoContent"] title:self.agencyList[_playIndex][@"InfoTitle"]];
    }
    else
    {
        [ZQLoadingView showAlertHUD:@"没有更多了" duration:SXLoadingTime];
    }
}
- (void)listBtnAction
{
    if (!self.agencyList.count) {
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
        if (self.styleIndex==100) {
            rect.size.height -=50;
        }
        else
        {
            if (self.styleIndex !=111) {
                rect.size.height -=50;
            }
        }
//        if (kDevice_Is_iPhoneX) {
//            rect.size.height -= 88;
//        }
//        else
//        {
//            rect.size.height -= 64;
//        }
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
        _playView = [[PBPlayView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), CGRectGetWidth(self.view.frame), 50)];
        [_playView.nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_playView.listBtn addTarget:self action:@selector(listBtnAction) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        _playView.viewAction = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                PBPlayViewController *playVc = [[PBPlayViewController alloc] init];
                playVc.pPlayIndex = strongSelf.playIndex;
                playVc.playContentDic = strongSelf.agencyList[strongSelf.playIndex];
                playVc.playContentArray = strongSelf.agencyList;
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
        _playListView.playListArr = self.agencyList;
        [_playListView.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        WK(weakSelf);
        _playListView.cellAction = ^(NSInteger index) {
            weakSelf.playIndex = index;
            [weakSelf playWithSting:weakSelf.agencyList[index][@"InfoContent"] title:weakSelf.agencyList[index][@"InfoTitle"]];
        };
    }
    return _playListView;
}
- (void)playWithSting:(NSString *)string title:(NSString *)tStr
{
    [self.playView.titleLabel setText:tStr];
    [self.playView playActionWithString:string];
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
