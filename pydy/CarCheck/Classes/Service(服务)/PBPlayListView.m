//
//  PBPlayListView.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/26.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBPlayListView.h"

@interface PBPlayListView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *playListTableV;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation PBPlayListView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self addSubview:self.titleLabel];
        
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 48, CGRectGetWidth(frame), 2)];
        lineV.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:lineV];
        
        [self addSubview:self.playListTableV];
        
        lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playListTableV.frame), CGRectGetWidth(frame), 1)];
        lineV.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:lineV];
        
        [self.closeBtn setFrame:CGRectMake(0, CGRectGetMaxY(lineV.frame)+10, CGRectGetWidth(frame), 30)];
        [self addSubview:self.closeBtn];
    }
    return self;
}

- (void)setPlayListArr:(NSArray *)playListArr
{
    if (_playListArr != playListArr) {
        _playListArr = playListArr;
        [self.titleLabel setText:[NSString stringWithFormat:@"内容列表(%lu)",(unsigned long)_playListArr.count]];
        [self.playListTableV reloadData];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playListArr.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"playListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if (self.isMyDataList) {
        NSArray *array = self.playListArr[indexPath.row][@"info"];
        if ([array isKindOfClass:[NSArray class]]) {
            if (array.count) {
                cell.textLabel.text = [NSString stringWithFormat:@"%ld %@",(long)indexPath.row+1,array[0][@"InfoTitle"]];
            }
            else
            {
                cell.textLabel.text = nil;
            }
        }
        else
        {
            cell.textLabel.text = nil;
        }
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld %@",(long)indexPath.row+1,self.playListArr[indexPath.row][@"InfoTitle"]];

    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.playListArr[indexPath.row][@"name"]];

    if (indexPath.row == self.seletedIndex) {
        cell.textLabel.textColor = [UIColor brownColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playing_image"]];
    }
    else
    {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 19)];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.seletedIndex = indexPath.row;
    [tableView reloadData];
    [self performSelector:@selector(performeCellAction) withObject:nil afterDelay:0.0];
}
- (void)performeCellAction
{
    if (self.cellAction) {
        self.cellAction(self.seletedIndex);
    }
}
- (UITableView *)playListTableV
{
    if (!_playListTableV) {
        
        _playListTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,50, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-100)];
        _playListTableV.backgroundColor = [UIColor clearColor];
        _playListTableV.dataSource = self;
        _playListTableV.delegate = self;
        _playListTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _playListTableV;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, CGRectGetWidth(self.frame), 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
