//
//  ZQVIPContentCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/19.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQVIPContentCell.h"

@interface ZQVIPContentCell (){
    CGFloat _width;
    CGFloat _height;
}

@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *contentlabel;
@property (strong,nonatomic) UILabel *pricelabel;
@end

@implementation ZQVIPContentCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _width = frame.size.width;
        _height = frame.size.height;
//        self.backgroundColor = HEXCOLOR(0xcccccc);
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        
    }
    return self;
}

- (void)initViews {
    
//    CGFloat inset = 20;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_width-20)/2,18, 20, 20)];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
//
    self.contentlabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_imageView.frame)+10, _width -30, 30)];
    _contentlabel.numberOfLines = 0;
    _contentlabel.font = [UIFont systemFontOfSize:12];
    _contentlabel.textColor = [UIColor darkTextColor];
    _contentlabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_contentlabel];

    self.pricelabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_contentlabel.frame), _width -30, 20)];
    _pricelabel.font = [UIFont systemFontOfSize:12];
    _pricelabel.textColor = [UIColor brownColor];
    _pricelabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pricelabel];
}

-(void)writDataWithModel:(NSDictionary *)mDic
{
    _contentlabel.text = mDic[@"title"];
    _pricelabel.text = mDic[@"price"];
    [_imageView setImage:[UIImage imageNamed:mDic[@"image"]]];
}

@end
