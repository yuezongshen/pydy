//
//  PBInfoViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/20.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBInfoViewController.h"

@interface PBInfoViewController ()

@property (nonatomic, strong) NSMutableArray *infoList;
@property (nonatomic, strong) NSDictionary *contentDic;

@end

@implementation PBInfoViewController

- (void)dealloc
{
    NSLog(@"PBInfoViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoList = [NSMutableArray arrayWithCapacity:0];
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 10)];
    self.tableView.tableFooterView = footV;
    self.tableView.backgroundColor = MainBgColor;
    [self getInfoListData];

}
- (void)getInfoListData
{
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"api/Ln/Myinformation" withParameters:@{@"token":[Utility getWalletPayPassword]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
//                [Utility saveUserInfo:jsonDic[@"data"]];
//                [_phoneLabel setText:[Utility getUserName]];
//                if ([Utility getUserHeadUrl]) {
//                    [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageBaseAPI,[Utility getUserHeadUrl]]] forState:UIControlStateNormal placeholderImage:MImage(@"user_head")];
//                }
//                else
//                {
//                    [_headBtn setBackgroundImage:MImage(@"user_head") forState:UIControlStateNormal];
//                }
                NSDictionary *dic = jsonDic[@"data"];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    [strongSelf.infoList addObject:@{@"name":@"在岗状态",@"des":dic[@"zaigangzt"]}];
                    [strongSelf.infoList addObject:@{@"name":@"人员类型",@"des":dic[@"renyuantype"]}];
                    [strongSelf.infoList addObject:@{@"name":@"党支部",@"des":dic[@"dangzhibu"]}];
                    [strongSelf.infoList addObject:@{@"name":@"党内职务",@"des":dic[@"dangneizhiwu"]}];
                    [strongSelf.infoList addObject:@{@"name":@"转为预备党员日期",@"des":dic[@"yubeitime"]}];
                    [strongSelf.infoList addObject:@{@"name":@"转为正式党员日期",@"des":dic[@"zhengshitime"]}];
                    strongSelf.contentDic = dic;
                }
                [self.tableView reloadData];
            }
        }
        else
        {
            [ZQLoadingView showAlertHUD:jsonDic[@"info"] duration:SXLoadingTime];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
    } animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        return self.infoList.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    view.backgroundColor = MainBgColor;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
         return 50;
    }
     return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PBMienCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.section) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.imageView.image = nil;
        NSDictionary *dic = self.infoList[indexPath.row];
        [cell.textLabel setText:dic[@"name"]];
        [cell.detailTextLabel setText:[Utility verifyActionWithString:dic[@"des"]]];
        cell.accessoryView = nil;
    }
    else
    {
       

        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        
        NSString *contentStr = [Utility verifyActionWithString:self.contentDic[@"MemberName"]];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
        if ([self.contentDic[@"MemberGender"] integerValue]==1) {
            attchImage.image = [UIImage imageNamed:@"man"];
        }
        else
        {
            attchImage.image = [UIImage imageNamed:@"woman"];
        }
        attchImage.bounds = CGRectMake(2, -2, 15, 15);
        NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
        [attriStr insertAttributedString:stringImage atIndex:contentStr.length];
        cell.textLabel.attributedText = attriStr;
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setTitle:@"修改头像" forState:UIControlStateNormal];
//        [btn setFrame:CGRectMake(0, 0, 72, 24)];
//        [btn setImage:[UIImage imageNamed:@"pen_image"] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:11];
//        [btn addTarget:self action:@selector(changeHeadImage) forControlEvents:UIControlEventTouchUpInside];
//        btn.layer.cornerRadius = 2;
//        btn.layer.masksToBounds = YES;
//        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        btn.layer.borderWidth = 0.5;
//        cell.accessoryView = btn;
    }
    return cell;
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
