//
//  ZQServerViewCell.m
//  CarCheck
//
//  Created by zhangqiang on 2017/9/26.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQServerViewCell.h"

@interface ZQServerViewCell(){
    CGFloat _width;
    CGFloat _height;
}
@property(strong,nonatomic)UILabel *label;
@property(strong,nonatomic)UIImageView *imageView;

@end

@implementation ZQServerViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _width = frame.size.width;
        _height = frame.size.height;
//        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        
    }
    return self;
}

- (void)initViews {
    
    CGFloat inset = 20;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(inset, inset / 2.0, _width-inset*2, _width - inset * 2)];
//    _imageView.backgroundColor = [UIColor redColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_imageView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(1, CGRectGetMaxY(_imageView.frame)+5, _width - 2, 20)];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

-(void)writDataWithModel:(NSDictionary *)mDic
{
    _label.text = mDic[@"title"];
    _label.font = [UIFont systemFontOfSize:13];
    [_imageView setImage:[UIImage imageNamed:mDic[@"image"]]];
}
-(void)writeDataWithTitle:(NSString *)str imageStr:(NSString *)imgStr{
    _label.text = str;
    _label.font = [UIFont systemFontOfSize:15];
    if (imgStr.length) {
        CGFloat inset = 26;
        [self.imageView  setFrame:CGRectMake(inset, inset / 2.0, _width-inset*2, _width - inset * 2)];
        [_imageView setImage:[UIImage imageNamed:imgStr]];
    }
}

@end
