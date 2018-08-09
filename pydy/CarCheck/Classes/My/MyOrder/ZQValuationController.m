//
//  ZQValuationController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/18.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQValuationController.h"
#import "ZQValuationCell.h"
#import "ZQValuationModel.h"

@interface ZQValuationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableV;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation ZQValuationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部评价";
    
    [self initView];
    [self getValuationData];
}
- (void)getValuationData
{
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/comments" withParameters:@{@"guide_id":[Utility getUserID]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                NSArray *array = jsonDic[@"data"][@"comments"];
                if ([array isKindOfClass:[NSArray class]]) {
                    if (array.count) {
                        strongSelf.listArray = [ZQValuationModel mj_objectArrayWithKeyValuesArray:array];
                        [strongSelf.tableV reloadData];
                        [strongSelf.countLabel setText:[NSString stringWithFormat:@"游客点评（%@条）",jsonDic[@"data"][@"count"]]];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        
    } animated:NO];
}

-(void)initView{
    CGFloat spaceY = (kDevice_Is_iPhoneX ? 88 :64);
    [self.view addSubview:self.countLabel];
    [self.countLabel setFrame:CGRectMake(0, spaceY, CGRectGetWidth(self.view.frame), 40)];
    _tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_countLabel.frame), __kWidth, __kHeight-spaceY-CGRectGetHeight(_countLabel.frame))];
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.backgroundColor = [UIColor whiteColor];
    _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableV];

}

#pragma mark ==UITableViewDelegate==
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZQValuationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZQValuationCell"];
    if (!cell) {
        cell = [[ZQValuationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YEvaluteOrderCell"];
         [cell.openUpBtn addTarget:self action:@selector(openUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.openUpBtn.tag = indexPath.row;
    [cell configValuationCell:self.listArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    ZQValuationModel *vModel = self.listArray[indexPath.row];
    if (vModel.isOpenUp) {
        cellHeight = vModel.desTextSize+[ZQValuationCell getValuationCellHeight]-60;
    }
    else
    {
        cellHeight = [ZQValuationCell getValuationCellHeight];
    }
    if (vModel.desTextSize>60) {
        cellHeight += 20;
    }
    if (vModel.images)
    {
        if (vModel.images.count) {
            return cellHeight;
        }
    }
    else
    {
        cellHeight = cellHeight-60;
    }
    return cellHeight;
}
- (void)openUpBtnAction:(UIButton *)sender
{
//    if ([sender.titleLabel.text isEqualToString:@"展开"]) {
//        [sender setTitle:@"收起" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [sender setTitle:@"展开" forState:UIControlStateNormal];
//    }
    ZQValuationModel *vModel = self.listArray[sender.tag];
    vModel.isOpenUp = !vModel.isOpenUp;
    
    [self.tableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.text = @"游客点评（0条）";
        _countLabel.font = [UIFont systemFontOfSize:16];
        _countLabel.textColor = __MoneyColor;
        _countLabel.backgroundColor = __HeaderBgColor;
    }
    return _countLabel;
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
