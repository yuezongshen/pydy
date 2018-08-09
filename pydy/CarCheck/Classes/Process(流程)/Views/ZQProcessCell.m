//
//  ZQProcessCell.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/27.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQProcessCell.h"

@interface ZQProcessCell(){
    
    NSMutableArray *_btnArray;
    
}

@property(strong,nonatomic)UIButton *imgBtn;
@property(strong,nonatomic)UILabel *titleLabel;


@end

@implementation ZQProcessCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    CGFloat height = 40,btnWidth = 60;
    
    _imgBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _imgBtn.frame = CGRectMake((__kWidth - btnWidth) / 2.0, 10, btnWidth, height + 10);
//    [_imgBtn setTitle:@"一" forState:(UIControlStateNormal)];
//    [_imgBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [_imgBtn setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
    _imgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _imgBtn.titleEdgeInsets = UIEdgeInsetsMake(-6, 0, 6, 0);
    [_imgBtn setBackgroundImage:[UIImage imageNamed:@"process_step"] forState:UIControlStateNormal];
    [self addSubview:_imgBtn];
    
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, height, CGRectGetMinX(_imgBtn.frame) - 15, height)];
//    _titleLabel.backgroundColor = [UIColor greenColor];
//    [self addSubview:_titleLabel];
}

-(void)writeDataWithArray:(NSArray *)dataArray color:(UIColor *)color title:(NSString *)title {
    
    [_imgBtn setTitle:title forState:(UIControlStateNormal)];
    
    _dataArray = dataArray;
    if (!_dataArray.count) {
        return;
    }
    if (_btnArray.count) {
        for (int i=0;i<_btnArray.count;i++) {
            UIButton *btn = _btnArray[i];
            [btn setTitle:_dataArray[i] forState:(UIControlStateNormal)];
        }
    }else {
        CGFloat height = 34;
        _btnArray = [NSMutableArray array];
        for (int i = 0; i < _dataArray.count; i ++) {
            NSString *titleStr = _dataArray[i];
            UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//            titleBtn.frame = CGRectMake(10, height*(i+1) + i*5+8, CGRectGetMinX(_imgBtn.frame) - 10, height);
            titleBtn.frame = CGRectMake(10, (height+5)*i+12, CGRectGetMinX(_imgBtn.frame) - 10, height);
            titleBtn.backgroundColor = color;
            [titleBtn setTitle:titleStr forState:(UIControlStateNormal)];
            if (titleStr.length>6) {
                 [titleBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            }
            titleBtn.tag = i+100;
            [titleBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            [self addSubview:titleBtn];
            [_btnArray addObject:titleBtn];
        }
    }
    
}

//-(void)setDataArray:(NSArray *)dataArray {
//    
//    _dataArray = dataArray;
//    if (!_dataArray.count) {
//        return;
//    }
//    if (_btnArray.count) {
//        for (int i=0;i<_btnArray.count;i++) {
//            UIButton *btn = _btnArray[i];
//            [btn setTitle:_dataArray[i] forState:(UIControlStateNormal)];
//        }
//    }else {
//        CGFloat height = 30;
//        _btnArray = [NSMutableArray array];
//        for (int i = 0; i < _dataArray.count; i ++) {
//            UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//            titleBtn.frame = CGRectMake(15, height*(i+1) + i*5, CGRectGetMinX(_imgBtn.frame) - 15, height);
//            titleBtn.backgroundColor = [UIColor greenColor];
//            [titleBtn setTitle:_dataArray[i] forState:(UIControlStateNormal)];
//            titleBtn.tag = i+100;
//            [titleBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
//            [self addSubview:titleBtn];
//            [_btnArray addObject:titleBtn];
//        }
//    }
//}

-(void)clickBtn:(UIButton *)sender {
    
    if (!self.delegate) {
        NSLog(@"click没有设置代理");
        return;
    }
    UITableViewController *tableVC = (UITableViewController *)self.delegate;
    NSIndexPath *path = [tableVC.tableView indexPathForCell:self];
    [self.delegate selectAtRow:path.row index:sender.tag - 100];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
