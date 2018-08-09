//
//  ZQSettingViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQSettingViewController.h"
#import "ZQMsgSetViewController.h"
#import "ZQAboutUsViewController.h"
#import "JPUSHService.h"

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "SDImageCache.h"

@interface ZQSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titleArray;
}
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ZQSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
//    _titleArray = @[@[@"分享",@"鼓励一下"],@[@"新消息通知"],@[@"关于我们"]];
    _titleArray = @[@[@"清除缓存"],@[@"关于我们"]];
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
        
        if ([Utility isLogin]) {
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-180)];
            _tableView.tableFooterView = footView;
            UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,CGRectGetHeight(footView.frame)-80, CGRectGetWidth(self.view.frame)-40, 40)];
            _putBtn.backgroundColor = __DefaultColor;
            _putBtn.titleLabel.font = MFont(18);
            [_putBtn setTitle:@"退出登录" forState:BtnNormal];
            [_putBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            [_putBtn.layer setCornerRadius:6];
            //        [_putBtn.layer setMasksToBounds:YES];
            [_putBtn addTarget:self action:@selector(logoutAction) forControlEvents:BtnTouchUpInside];
            [footView addSubview:_putBtn];
        }
    }
    return _tableView;
}
- (void)logoutAction
{
    [Utility setLoginStates:NO];
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLogoutNotication object:nil];
//   注销推送
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        
//    } seq:5];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = _titleArray[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id1"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell_id1"];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
    if (indexPath.row==0&&indexPath.section==0) {
//        [cell.detailTextLabel setTextColor:[UIColor brownColor]];
//        [cell.detailTextLabel setTextColor:LH_RGBCOLOR(17,149,232)];
//        [cell.detailTextLabel setText:@"奖励20积分"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.detailTextLabel setText:[self calculateCacheSize]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //分享
//                    [self shareAction];
//                    [self requestShareData];
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您确定要清除缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                            
                        }];
                        [[SDImageCache sharedImageCache] clearMemory];
                        [self.tableView reloadData];

                    }];
                    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertVC addAction:alert2];
                    [alertVC addAction:alert1];
                    [self presentViewController:alertVC animated:YES completion:nil];

                }
                    break;
                case 1:{
                    ZQAboutUsViewController *aboutUsVc = [[ZQAboutUsViewController alloc] init];
                    [self.navigationController pushViewController:aboutUsVc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            ZQAboutUsViewController *aboutUsVc = [[ZQAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVc animated:YES];
            //新消息通知
//            ZQMsgSetViewController *msgSetVc = [[ZQMsgSetViewController alloc] init];
//            [self.navigationController pushViewController:msgSetVc animated:YES];
        }
            break;
        case 2:
        {
            //关于我们
            ZQAboutUsViewController *aboutUsVc = [[ZQAboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsVc animated:YES];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (NSString *)calculateCacheSize
{
    double tmpSize = [[SDImageCache sharedImageCache] getSize];
    
    CGFloat cacheSize = 0;
    if (tmpSize>1) {
        cacheSize = tmpSize/1024/1024;
        return [NSString stringWithFormat:@"%.2fM",cacheSize];
    }
    else
    {
        if (tmpSize>0) {
            cacheSize = tmpSize*1024;
            return [NSString stringWithFormat:@"%.2fK",cacheSize];
        }
        return @"0.0";
    }
}
- (void)shareAction
{
////     （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"icon29"]];
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
////
//        [shareParams SSDKSetupShareParamsByText:@"新概念检车联盟依托互联网+，整合优化各方资源，为广大车主提供省时省力省心的一站式全方位服务" images:imageArray url:[NSURL URLWithString:@"http://mob.com"] title:@"新概念检车联盟" type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//            switch (state) {
//                case SSDKResponseStateSuccess:
//                {
//                    [ZQLoadingView showAlertHUD:@"分享成功" duration:SXLoadingTime];
//                    break;
//                }
//                case SSDKResponseStateFail:
//                {
//                    [ZQLoadingView showAlertHUD:@"分享失败" duration:SXLoadingTime];
//
//                    break;
//                }
//                default:
//                    break;
//            }
//        }];
//    }
}

- (void)requestShareData
{
    NSString *urlStr = [NSString stringWithFormat:@"daf/update_share/u_id/%@",[Utility getUserID]];
//    NSLog(@"分享回调接口:%@",urlStr);
    //我的消息接口
//    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
//            __strong typeof(self) strongSelf = weakSelf;
//            if (strongSelf)
//            {
//
//            }
        }
    } failure:^(NSError *error) {
        
    } animated:NO];
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
