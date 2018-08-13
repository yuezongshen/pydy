//
//  ZQNewCarCheckController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNewCarCheckController.h"
#import "ZQVioUpTableViewCell.h"

#import "NSString+Validation.h"
#import "ZQPaidImageL.h"
#import "ZQOrderObject.h"
#import "ZQDeclarationCell.h"

@interface ZQNewCarCheckController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UILabel *orderNumLabel;
@property (nonatomic, strong) UILabel *orderStatusLabel;
@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray *contentArray;

@property (nonatomic, strong) UILabel *timesLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) ZQPaidImageL *paidImageV;
@end

@implementation ZQNewCarCheckController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    
//    [self setupData];

}
- (void)setOrderObj:(ZQOrderObject *)orderObj
{
    if (_orderObj != orderObj) {
        _orderObj = orderObj;
        [self initViews];
        self.moneyLabel.text = @"80元";
        self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号:%@",_orderObj.order_sn];
        
        self.titleArray = @[[NSString stringWithFormat:@"距离服务开始还有%@",_orderObj.appoint_time],@"游客姓名",@"联系方式",@"景点项目",@"服务类型",@"预约时间",@"备注信息"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:@""];
        if (_orderObj.name) {
            [array addObject:_orderObj.name];
        }
        else
        {
            [array addObject:@""];
        }
        if (_orderObj.guestphone) {
            [array addObject:_orderObj.guestphone];
        }
        else
        {
            [array addObject:@""];
        }
        if (_orderObj.project) {
            [array addObject:_orderObj.project];
        }
        else
        {
            [array addObject:@""];
        }
        if (_orderObj.type) {
            [array addObject:_orderObj.type];
        }
        else
        {
            [array addObject:@""];
        }
        if (_orderObj.appointment_time) {
            [array addObject:_orderObj.appointment_time];
        }
        else
        {
            [array addObject:@""];
        }
        if (_orderObj.remarks) {
            [array addObject:_orderObj.remarks];
        }
        else
        {
            [array addObject:@""];
        }
        self.contentArray = array;
        [self.tableView reloadData];
        switch (_orderObj.is_confirm.integerValue) {
            case 0:
                {
                    self.orderStatusLabel.text = @"   待确认";
                    self.timesLabel.text = @"支付时间:2018-03-01 17:22:26";
                }
                break;
            case 1:
            {
                self.orderStatusLabel.text = @"   未服务";
                self.timesLabel.text = @"支付时间:2018-03-01 17:22:26";
            }
                break;
            case 2:
            {
                self.orderStatusLabel.text = @"   进行中";
                self.timesLabel.text = @"支付时间:2018-03-01 17:22:26";
                break;
            }
            case 3:
            {
                self.orderStatusLabel.text = @"   已完成";
                NSString *textStr = [NSString stringWithFormat:@"结束时间:2018-03-03 17:22:26\n接单时间:2018-03-02 17:22:26\n支付时间:2018-03-01 17:22:26"];
                NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:textStr];
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:6];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [textStr length])];
                [self.timesLabel setAttributedText:attributedString1];
                break;
            }
            default:
                break;
        }
        
        self.paidImageV.desLabel.text = @"已支付";
    }
}
-(void)setupData {

    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/orderdetails" withParameters:@{@"id":@"1",@"user_id":@"75"} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSDictionary *conDic = jsonDic[@"data"];
                if ([conDic isKindOfClass:[NSDictionary class]]) {
                    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号:%@",conDic[@"order_sn"]];
                    strongSelf.titleArray = @[@"距离服务开始还有14小时",@"游客姓名",@"联系方式",@"景点项目",@"服务类型",@"预约时间",@"备注信息"];
                    strongSelf.contentArray = [NSMutableArray arrayWithArray: @[@"",conDic[@"name"],conDic[@"guestphone"],conDic[@"project"],conDic[@"type"],conDic[@"start_time"],conDic[@"remarks"]]];
                    [strongSelf.tableView reloadData];
                    if ([conDic[@"is_confirm"] integerValue] == 0) {
                        strongSelf.orderStatusLabel.text = @"   待确认";
                        strongSelf.timesLabel.text = @"支付时间:2018-03-01 17:22:26";
                    }
                    else
                    {
                        strongSelf.orderStatusLabel.text = @"   已完成";
                        NSString *textStr = [NSString stringWithFormat:@"结束时间:2018-03-03 17:22:26\n接单时间:2018-03-02 17:22:26\n支付时间:2018-03-01 17:22:26"];
                        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:textStr];
                        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle1 setLineSpacing:6];
                        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [textStr length])];
                        [strongSelf.timesLabel setAttributedText:attributedString1];
                    }
                }
            }
        }
        else
            [ZQLoadingView showAlertHUD:@"暂无数据" duration:SXLoadingTime];
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        
    } animated:NO];
//    _titleArray = @[@"距离服务开始还有14小时",@"游客姓名",@"联系方式",@"景点项目",@"服务类型",@"预约时间",@"备注信息"];
//    _contentArray = [NSMutableArray arrayWithArray: @[@"",@"王二狗",@"187****9807",@"平遥古城讲解",@"私人订制",@"2018-02-09 14:00-16:00",@"暂无"]];
//    [_tableView reloadData];
//
//    self.orderNumLabel.text = @"订单编号:sdsdfasdfasdfsadf";
//    if (self.detailOrderType==0) {
//       self.orderStatusLabel.text = @"   待确认";
//        self.timesLabel.text = @"支付时间:2018-03-01 17:22:26";
//    }
//    else
//    {
//      self.orderStatusLabel.text = @"   已完成";
//        NSString *textStr = [NSString stringWithFormat:@"结束时间:2018-03-03 17:22:26\n接单时间:2018-03-02 17:22:26\n支付时间:2018-03-01 17:22:26"];
//        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:textStr];
//        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle1 setLineSpacing:6];
//        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [textStr length])];
//        [self.timesLabel setAttributedText:attributedString1];
//    }
    
//    self.moneyLabel.text = @"80元";
//
//    self.paidImageV.desLabel.text = @"已支付";
}
-(void)initViews {
    
    CGFloat spaceY = (kDevice_Is_iPhoneX ? 88 :64);
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, spaceY, CGRectGetWidth(self.view.frame), 50)];
     hView.backgroundColor = __HeaderBgColor;
    [self.view addSubview:hView];
    [hView addSubview:self.orderNumLabel];
    [self.orderNumLabel setFrame:CGRectMake(10, 0, 260, CGRectGetHeight(hView.frame))];
    [hView addSubview:self.orderStatusLabel];
    [self.orderStatusLabel setFrame:CGRectMake(CGRectGetWidth(hView.frame)-60, 13, 110, 24)];
    self.orderStatusLabel.layer.cornerRadius = 12;
    self.orderStatusLabel.layer.masksToBounds = YES;

    CGFloat bottomH = 150;
    if (self.orderObj.is_confirm.integerValue != 2) {
        bottomH = 120;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hView.frame), CGRectGetWidth(self.view.frame), self.view.bounds.size.height-bottomH-CGRectGetMaxY(hView.frame)) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = MainBgColor;
    [self.view addSubview:self.tableView];
 
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    footV.backgroundColor = MainBgColor;
    self.tableView.tableFooterView = footV;
    
    
    UIView *bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-bottomH, CGRectGetWidth(self.view.frame), bottomH-40)];
    bottomV.backgroundColor = HEXCOLOR(0xf7f7f7);
    [self.view addSubview:bottomV];
    
    [bottomV addSubview:self.timesLabel];
    [self.timesLabel setFrame:CGRectMake(12, 0, 200, bottomH-80)];
   UILabel *chargeL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_timesLabel.frame), CGRectGetWidth(self.view.frame), 40)];
    chargeL.font = [UIFont systemFontOfSize:14];
    chargeL.textColor = __TestOColor;
    chargeL.backgroundColor = [UIColor whiteColor];
    chargeL.text = @"    费用合计:";
    [bottomV addSubview:chargeL];
    [bottomV addSubview:self.moneyLabel];
    
    [self.moneyLabel addSubview:self.paidImageV];
    
    UIView *startView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40, CGRectGetWidth(self.view.frame), 40)];
    startView.backgroundColor = __HeaderBgColor;
    [self.view addSubview:startView];
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(startView.frame)-100,8, 80, 24)];
    _putBtn.backgroundColor = __MoneyColor;
    _putBtn.titleLabel.font = MFont(12);
    _putBtn.layer.cornerRadius = 12;
    _putBtn.layer.masksToBounds = YES;
    [_putBtn setTitle:@"联系游客" forState:BtnNormal];
    [_putBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [_putBtn addTarget:self action:@selector(contactVisitorAction) forControlEvents:BtnTouchUpInside];
    [startView addSubview:_putBtn];
}
- (void)contactVisitorAction
{
    [Utility callTraveller:self.orderObj.guestphone];
}
- (void)phoneBtnAction
{
    [Utility phoneCallAction];
}

#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *detailString = _contentArray[indexPath.row];
    if (indexPath.row == 6) {
        if (detailString.length) {
            ZQDeclarationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQNoteCell"];
            if (!cell) {
                cell = [[ZQDeclarationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZQNoteCell"];
            }
            [cell configTitle:@"备注信息"];
            [cell configTextFeild:detailString];
            return cell;
        }
        else
        {
            detailString = @"暂无";
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_order_detail"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell_order_detail"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:@"front_point"];
        cell.textLabel.textColor = __TestGColor;
        cell.textLabel.text = _titleArray[indexPath.row];
    }
    else
    {
        cell.textLabel.textColor = __DesGreenColor;
        cell.textLabel.text = [NSString stringWithFormat:@"*   %@",_titleArray[indexPath.row]];
    }
    if (indexPath.row ==5) {
        cell.detailTextLabel.textColor = __MoneyColor;
    }
    else
    {
        cell.detailTextLabel.textColor = __TestOColor;
    }
    cell.detailTextLabel.text = detailString;
    return cell;
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        NSString *string = self.contentArray[indexPath.row];
        if (string.length) {
            return 100;
        }
    }
    return 40;
}

- (UILabel *)timesLabel
{
    if (!_timesLabel) {
        _timesLabel = [[UILabel alloc] init];
        _timesLabel.font = [UIFont systemFontOfSize:12];
        _timesLabel.textColor = [UIColor lightGrayColor];
        _timesLabel.numberOfLines = 3;
    }
    return _timesLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-120, CGRectGetMaxY(_timesLabel.frame), 80, 40)];
        _moneyLabel.font = [UIFont systemFontOfSize:18];
        _moneyLabel.textColor = __TestRedColor;
    }
    return _moneyLabel;
}
- (UILabel *)orderStatusLabel
{
    if (!_orderStatusLabel) {
        _orderStatusLabel = [[UILabel alloc] init];
        _orderStatusLabel.text = @"";
        _orderStatusLabel.font = [UIFont systemFontOfSize:14];
        _orderStatusLabel.textColor = [UIColor whiteColor];
        _orderStatusLabel.backgroundColor =__MoneyColor;
    }
    return _orderStatusLabel;
}

- (UILabel *)orderNumLabel
{
    if (!_orderNumLabel) {
        _orderNumLabel = [[UILabel alloc] init];
        _orderNumLabel.text = @"";
        _orderNumLabel.font = [UIFont systemFontOfSize:14];
        _orderNumLabel.textColor = __MoneyColor;
    }
    return _orderNumLabel;
}
- (ZQPaidImageL *)paidImageV
{
    if (!_paidImageV) {
        _paidImageV = [[ZQPaidImageL alloc] initWithFrame:CGRectMake(45, 0, 0, 0)];
    }
    return _paidImageV;
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
