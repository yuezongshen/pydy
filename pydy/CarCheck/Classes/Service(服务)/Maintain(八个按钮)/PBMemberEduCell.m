//
//  PBMemberEduCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/19.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBMemberEduCell.h"

@interface PBMemberEduCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation PBMemberEduCell

+ (CGFloat)EduCellHeight
{
    return 60;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.markLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.attachLabel];
    }
    
    return self;
}
- (void)setEduContent:(NSDictionary *)cDic type:(NSInteger)type
{
    if (![cDic isKindOfClass:[NSDictionary class]]) {
        [self.titleLabel setText:@""];
        [self.timeLabel setText:@""];
        return;
    }
    NSString *string = nil;
    NSString *titleStr = nil;
    switch (type) {
        case 1:
          {
              titleStr = cDic[@"InfoTitle"];
              NSRange range = [titleStr rangeOfString:@"："];
              if (range.location != NSNotFound) {
                  NSArray *array = [titleStr componentsSeparatedByString:@"："];
                  string = array.firstObject;
                  titleStr = array.lastObject;
              }
          }
            break;
        default:
        {
            titleStr = cDic[@"InfoTitle"];
        }
            break;
    }
    [self.titleLabel setText:titleStr];
    [self.timeLabel setText:cDic[@"InfoTime"]];
    if ([string isKindOfClass:[NSString class]]) {
        if (string.length) {
            CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:_markLabel.font}];
            [_markLabel setFrame:CGRectMake(10, 10, size.width+6, 14)];
            [_markLabel setText:string];
            [_titleLabel setFrame:CGRectMake(CGRectGetMaxX(_markLabel.frame)+4, 9, KWidth-CGRectGetMaxX(_markLabel.frame)-10-4, 16)];
            return;
        }
    }
    [_markLabel setFrame:CGRectZero];
    [_titleLabel setFrame:CGRectMake(10, 9, KWidth-10-10, 16)];
}

- (UILabel *)markLabel
{
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.font = [UIFont systemFontOfSize:10];
        _markLabel.textColor = [UIColor whiteColor];
        _markLabel.layer.cornerRadius = 2;
        _markLabel.layer.masksToBounds = YES;
        [_markLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _markLabel;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 200, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
    }
    return _timeLabel;
}
- (UILabel *)attachLabel
{
    if (!_attachLabel) {
        _attachLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-10-200, CGRectGetMinY(_timeLabel.frame), 200, 15)];
        _attachLabel.font = [UIFont systemFontOfSize:12];
        _attachLabel.textColor = [UIColor lightGrayColor];
        _attachLabel.textAlignment = NSTextAlignmentRight;
    }
    return _attachLabel;
}
@end
