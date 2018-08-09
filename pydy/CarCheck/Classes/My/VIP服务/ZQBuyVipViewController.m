//
//  ZQBuyVipViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/17.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQBuyVipViewController.h"
#import "ZQVIPBuyCardView.h"
#import "ZQVIPContentCell.h"
#import "ZQVIPFootView.h"

#import "YPayViewController.h"
#import "ZQHtmlViewController.h"
#import "ZQVIPDetailController.h"
//#import "ZQVIPModel.h"

#import "NSDictionary+propertyCode.h"
@interface ZQBuyVipViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_dataArray;
    NSArray *_imagePpointArray;
    NSArray *_appointArray;;
    
    BOOL isAgreen;
}
@property (strong, nonatomic) UICollectionView *mainView;
@property (strong, nonatomic) ZQVIPModel *aVipModel;
@property (strong, nonatomic) UIButton *putBtn;

@property (strong, nonatomic) ZQVIPBuyCardView *aheadView;
@end

@implementation ZQBuyVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIP会员服务";
    [self getDataAnimated:NO];
    [self initViews];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccessNotifacation) name:@"enterSuccessView" object:nil];
}
- (void)initViews {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-40) collectionViewLayout:flowLayout];
//    self.mainView.backgroundColor = HEXCOLOR(0xcccccc);
    self.mainView.backgroundColor = LH_RGBCOLOR(241,239,235);
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    [self.view addSubview:self.mainView];
    
    [self.mainView registerClass:[ZQVIPContentCell class] forCellWithReuseIdentifier:@"ZQVIPContentCell"];
    [self.mainView registerClass:[ZQVIPBuyCardView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQVIPBuyCardView"];
    
     [self.mainView registerClass:[ZQVIPFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ZQVIPFootView"];
    
    self.putBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame), 40)];
    _putBtn.backgroundColor = LH_RGBCOLOR(62,61,68);
    _putBtn.titleLabel.font = MFont(18);
    if ([Utility getIs_vip]) {
        [_putBtn setTitle:@"VIP到期日:" forState:BtnNormal];
    }
    else
    {
        [_putBtn setTitle:@"￥99/年 我要开卡" forState:BtnNormal];
        [_putBtn addTarget:self action:@selector(buyCardAction) forControlEvents:BtnTouchUpInside];
    }
    [_putBtn setTitleColor:[UIColor brownColor] forState:BtnNormal];
    [self.view addSubview:_putBtn];
    
    // 注册
//    [self.mainView registerClass:[ZQHeaderViewScoll class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScrollPageView"];
    //    [self.mainView registerClass:[ZQAppointmentHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQAppointmentHeaderView"];
    
}
- (void)buyCardAction
{
    if (isAgreen) {
        YPayViewController *payVC = [[YPayViewController alloc] init];
        payVC.payMoney = self.aVipModel.current_price;
        payVC.aPayType = ZQPayVIPView;
        __weak typeof(self) weakSelf = self;
        payVC.paySuccess = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                 [strongSelf paySuccessNotifacation];
            }
        };
        [self.navigationController pushViewController:payVC animated:YES];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先阅读并同意相关须知 !" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)paySuccessNotifacation
{
    [self.putBtn setTitle:@"VIP到期日:" forState:BtnNormal];
    [self.putBtn setUserInteractionEnabled:NO];
    [self getDataAnimated:NO];
//    [self.mainView reloadData];
}
-(void)getDataAnimated:(BOOL)animate {
    //    _dataArray = @[@{@"title":@"违章查询",@"subtitle":@"weizhang"},@{@"title":@"检车机构",@"subtitle":@"jianche"},@{@"title":@"保险服务",@"subtitle":@"baoxian"},@{@"title":@"车辆维修",@"subtitle":@"weixiu"},@{@"title":@"代缴罚款",@"subtitle":@"fakuan"},@{@"title":@"常见问题",@"subtitle":@"wenti"},@{@"title":@"法律咨询",@"subtitle":@"falv"},@{@"title":@"加油充值",@"subtitle":@"jiayou"}];
    //VIP会员接口
    NSString *urlStr = [NSString stringWithFormat:@"daf/get_vip_member/u_id/%@",[Utility getUserID]];
    _dataArray = @[@{@"title":@"机动车年检",@"price":@"价值69元",@"image":@"myMoney"},@{@"title":@"保险服务",@"price":@"价值70元",@"image":@"myMoney"},@{@"title":@"代缴罚款",@"price":@"价值30元",@"image":@"myMoney"},@{@"title":@"年检代办",@"price":@"价值30元",@"image":@"myMoney"},@{@"title":@"法律援助",@"price":@"价值100元",@"image":@"myMoney"},@{@"title":@"头等舱服务",@"price":@"价值99元",@"image":@"myMoney"}];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:urlStr withParameters:nil success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                NSDictionary *dic = jsonDic[@"res"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    strongSelf.aVipModel = [ZQVIPModel mj_objectWithKeyValues:dic];
                    [strongSelf.aheadView configBuyCardViewWithModel:strongSelf.aVipModel];
                    if (strongSelf.aVipModel.is_vip.integerValue == 2) {
                        NSTimeInterval time= [strongSelf.aVipModel.remaining_time doubleValue];
                        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
                         [strongSelf.putBtn setTitle:[NSString stringWithFormat:@"VIP到期日: %@",currentDateStr] forState:BtnNormal];
                        [strongSelf.putBtn setUserInteractionEnabled:NO];
                        [Utility storageInteger:2 forKey:@"is_vip"];
//                         [strongSelf.mainView reloadData];
                    }
                    else
                    {
                        [strongSelf.putBtn setTitle:@"￥99/年 我要开卡" forState:BtnNormal];
                        [strongSelf.putBtn setUserInteractionEnabled:YES];
                    }

                }
            }
        }
    } failure:^(NSError *error) {
        
    } animated:animate];
}

#pragma mark UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZQVIPContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZQVIPContentCell" forIndexPath:indexPath];
    [cell writDataWithModel:_dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZQVIPDetailController *Vc = [[ZQVIPDetailController alloc] init];
    Vc.vipModel = self.aVipModel;
    [self.navigationController pushViewController:Vc animated:YES];
}
#pragma mark headerAndFooter
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reuseV = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            ZQVIPBuyCardView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQVIPBuyCardView" forIndexPath:indexPath];
            [headView.introduceBtn addTarget:self action:@selector(introductBtnAction) forControlEvents:UIControlEventTouchUpInside];
            self.aheadView = headView;
            reuseV = headView;
            // 轮播图
//            ZQHeaderViewScoll *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScrollPageView" forIndexPath:indexPath];
//            headView.imageStrArray = @[@"adp",@"adp",@",adp"];
//            headView.backgroundColor = [UIColor redColor];
//            [headView startWithBlock:^(NSInteger index) {
//
//            }];
//            reuseV = headView;
        }else{
            UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ScrollPageView" forIndexPath:indexPath];
            reuseV = headView;
            // 预约
            /*
             ZQAppointmentHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZQAppointmentHeaderView" forIndexPath:indexPath];
             __weak __typeof(self) weakSelf = self;
             headView.handler = ^{
             ZQMyBookingViewController *bookingVC = [[ZQMyBookingViewController alloc] init];
             [bookingVC setHidesBottomBarWhenPushed:YES];
             [weakSelf.navigationController pushViewController:bookingVC animated:YES];
             //                ZQSubTimeViewController *subVC = [[ZQSubTimeViewController alloc] initWithNibName:@"ZQSubTimeViewController" bundle:nil];
             //                [subVC setHidesBottomBarWhenPushed:YES];
             //                [weakSelf.navigationController pushViewController:subVC animated:YES];
             };
             reuseV = headView;
             */
//            UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"defaultHeaderView" forIndexPath:indexPath];
//            reuseV = headView;
        }
        
    }else {
        ZQVIPFootView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ZQVIPFootView" forIndexPath:indexPath];
        [headView.agreenBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (![Utility getIs_vip]) {
            isAgreen = [Utility isAgreeReservationNoticeForKey:@"VIP_Notice"];
             [headView.agreenBtn setSelected:isAgreen];
        }
        else
        {
            [headView.agreenBtn setSelected:YES];
        }
        [headView.aButton addTarget:self action:@selector(footAgreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        reuseV = headView;
    }
    return reuseV;
    
}

#pragma mark flowlayout
//x 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}
//y 间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((__kWidth-1*2)/3.0, (__kWidth-1*2)/3.0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(__kWidth, 240);
    }else if(section == 1){
        //        return CGSizeMake(__kWidth, 40);
        return CGSizeMake(0, 0);
    }else{
        return CGSizeMake(0, 0);
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(__kWidth, 56);
}
//详细介绍
- (void)introductBtnAction
{
    ZQVIPDetailController *Vc = [[ZQVIPDetailController alloc] init];
    Vc.vipModel = self.aVipModel;
    [self.navigationController pushViewController:Vc animated:YES];
}
- (void)clickAction:(UIButton *)sender
{
    if ([Utility getIs_vip]) {
        return;
    }
    sender.selected = !sender.selected;
    [Utility storageAgreeReservationNotice:sender.selected forKey:@"VIP_Notice"];
    isAgreen = sender.selected;
}
- (void)footAgreeBtnAction
{
//    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"vip_detail.html" andShowBottom:NO];
    ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.1" andShowBottom:NO];
    Vc.title = @"VIP用户服务须知";
    [self.navigationController pushViewController:Vc animated:YES];
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
