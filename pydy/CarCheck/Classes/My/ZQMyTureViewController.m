//
//  ZQMyTureViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/11/2.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMyTureViewController.h"
#import "YBuyingDatePicker.h"
#import "ZQVioUpTableViewCell.h"

#import "ZQFeedBackViewController.h"
//#import "ZQRechargeViewController.h"
#import "ZQHtmlViewController.h"
#import "ZQAreaView.h"

@interface ZQMyTureViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YBuyingDatePickerDelegate>{
    NSArray *_titleArray;
    NSArray *_placeArray;
    NSMutableArray *_contentArray;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) YBuyingDatePicker *datePickV;
@property (strong, nonatomic) ZQAreaView *areaView;

@property (copy, nonatomic) NSString *sexStr;
@property (copy, nonatomic) NSString *birthdayStr;
@property (copy, nonatomic) NSString *descStr;
@end

@implementation ZQMyTureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.birthdayStr = @"";
    self.sexStr = @"";
    self.descStr = @"";
    [self setupData];
    [self initViews];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupData {
    
    _titleArray = @[@"头像:",@"性别:",@"注册日期:",@"个人说明:",@"充值:",@"清楚缓存:",@"意见反馈:",@"平台介绍:",@"APP分享:"];
    _placeArray = @[@"男",@"2017-09-01",@"请输入"];
    _contentArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    
}

-(void)initViews {
    
    self.title = @"我的";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height - 50) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = HEXCOLOR(0xeeeeee);
    [self.view addSubview:self.tableView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 80)];
    UIButton *cannotBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 20, (__kWidth-80), 40)];
    [footView addSubview:cannotBtn];
    cannotBtn.titleLabel.font = BFont(15);
    cannotBtn.layer.cornerRadius = 6;
    [cannotBtn setTitle:@"退出登录" forState:BtnNormal];
    [cannotBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [cannotBtn setBackgroundColor:__DefaultColor];
    [cannotBtn addTarget:self action:@selector(logOutAction) forControlEvents:BtnTouchUpInside];
    self.tableView.tableFooterView = footView;
    // 注册cell
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"ZQVioUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZQVioUpTableViewCell_id"];

}
- (void)logOutAction
{
    [Utility setLoginStates:NO];
    self.tabBarController.selectedIndex = 0;
}
#pragma mark 私有方法
-(YBuyingDatePicker *)datePickV{
    if (!_datePickV) {
        _datePickV = [[YBuyingDatePicker alloc]initWithFrame:CGRectMake(0, __kHeight-260, __kWidth, 260)];
        _datePickV.delegate = self;
    }
    return _datePickV;
}

#pragma mark ==YBuyingDatePickerDelegate==
-(void)chooseDateTime:(NSString *)sender{
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *coms = [NSDate dateWithTimeIntervalSince1970:[sender integerValue]];
    NSString *dates =[formatter stringFromDate:coms];
    //    _placeArray = dates;
//    _contentArray[2] = dates;
    self.birthdayStr = dates;
    [self.tableView reloadData];
}

- (void)hiddenView {
    
    [self.datePickV removeFromSuperview];
    self.datePickV = nil;
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell_id1"];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                UIImageView *_headIV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 40, 40)];
                _headIV.layer.cornerRadius = 20;
                _headIV.layer.borderColor = LH_RGBCOLOR(244, 150, 130).CGColor;
                _headIV.layer.borderWidth = 1;
                _headIV.image =MImage(@"user_head");
                _headIV.clipsToBounds = YES;
                _headIV.contentMode =UIViewContentModeScaleAspectFill;
                cell.accessoryView = _headIV;
            }
            break;
        case 1:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (self.sexStr.length) {
                cell.detailTextLabel.text = _sexStr;
            }
            else
            {
                cell.detailTextLabel.text = _placeArray[indexPath.row-1];
            }
        }
            break;
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (self.birthdayStr.length) {
                cell.detailTextLabel.text = _birthdayStr;
            }
            else{
                cell.detailTextLabel.text = _placeArray[indexPath.row-1];
            }
        }
            break;
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KWidth-120, 30)];
//            textField.borderStyle = UITextBorderStyleNone;
//            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.textAlignment = NSTextAlignmentRight;
            textField.placeholder = @"请输入";
            textField.delegate = self;
            textField.font = [UIFont systemFontOfSize:15];
            textField.textColor = [UIColor darkGrayColor];
            textField.returnKeyType = UIReturnKeyDone;
            if (self.descStr.length) {
                textField.text = _descStr;
            }
            cell.accessoryView = textField;
        }
            break;
        default:
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
    /*
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell_id1"];
        cell.textLabel.text = _placeArray[indexPath.row];
        return cell;
    }else if ((indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3)){
        ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
        [cell setCellType:ZQVioUpCellType2 title:_titleArray[indexPath.row] placeText:_placeArray[indexPath.row]];
        
        return cell;
    }else{
        ZQVioUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQVioUpTableViewCell_id" forIndexPath:indexPath];
        [cell setCellType:ZQVioUpCellType3 title:_titleArray[indexPath.row] placeText:_placeArray[indexPath.row]];
        return cell;
    }
     */
}
// 设置表尾
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    return nil;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datePickV) {
        [self hiddenView];
    }
    if (self.areaView) {
        [self.areaView removeFromSuperview];
        self.areaView = nil;
    }
    switch (indexPath.row) {
        case 0:
            {
                //修改头像
            }
            break;
        case 1:{
            //性别
            [self.view endEditing:YES];
            __weak __typeof(self) weakSelf = self;
            self.areaView = [[ZQAreaView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-230, __kWidth, 230) provinceId:@"-2"];
            _areaView.handler = ^(ZQAreaModel *areaModel)
            {
                if (areaModel) {
                    weakSelf.sexStr = areaModel.areaName;
                    [weakSelf.tableView reloadData];
                }
            };
            [self.view addSubview:self.areaView];
        }
            break;
        case 2:
        {
            //注册日期
            [self.view endEditing:YES];
            [self.view addSubview:self.datePickV];
        }
            break;
        case 3:
        {
            //个人说明
        }
            break;
        case 4:
        {
            //充值
//            ZQRechargeViewController *Vc = [[ZQRechargeViewController alloc] init];
//            [Vc setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:Vc animated:YES];
        }
            break;
        case 5:
        {
            //清除缓存
        }
            break;
        case 6:
        {
            //意见反馈
            ZQFeedBackViewController *vc = [[ZQFeedBackViewController alloc]init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 7:
        {
         //平台介绍
//            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"platformIntroduction.html" andShowBottom:NO];
            ZQHtmlViewController *Vc = [[ZQHtmlViewController alloc] initWithUrlString:@"notice.3" andShowBottom:NO];
            Vc.title = @"平台介绍";
            [Vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:Vc animated:YES];
        }
            break;
        case 8:
        {
            //APP分享
        }
            break;
        default:
            break;
    }
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//    if (section == 0) {
//        return 70.0;
//    }else{
//        return 0.1;
//    }
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.descStr = textField.text;
    return YES;
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
