//
//  ZqvioFooterView.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/31.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQvioFooterView.h"
#import <Masonry.h>

@interface ZQvioFooterView()

@property(strong,nonatomic)UIButton *btn;
@property(strong,nonatomic)UILabel *agreeLabel;
@property(strong,nonatomic)UIButton *protocolBtn;
@property(strong,nonatomic)UIImageView *imgView;

@end

@implementation ZQvioFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

-(void)setImage:(UIImage *)image {
    
    if (_image != image) {
        _image = image;
        self.imgView.image = _image;
    }
}

-(void)initViews {
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    UILabel *fineLabel = [[UILabel alloc] init];
//    fineLabel.text = @"上传罚款单照片";
    fineLabel.text = @"上传处罚决定书";
    [self addSubview:fineLabel];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.image = [UIImage imageNamed:@"chooseImg"];
    [self addSubview:self.imgView];
    self.imgView.userInteractionEnabled = YES;
//    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
//    self.imgView.layer.masksToBounds = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImgAction:)];
    [self.imgView addGestureRecognizer:tap];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.btn];
//    self.btn.layer.cornerRadius = 3;
    [self.btn setImage:[UIImage imageNamed:@"unAgree"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateSelected];
    [self.btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.btn.backgroundColor = [UIColor redColor];
    
    self.agreeLabel = [[UILabel alloc] init];
    self.agreeLabel.text = @"我已阅读并同意";
    self.agreeLabel.textColor = [UIColor lightGrayColor];
    self.agreeLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:self.agreeLabel];
    
    self.protocolBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.protocolBtn];
    [self.protocolBtn addTarget:self action:@selector(clickKnowAction:) forControlEvents:UIControlEventTouchUpInside];
    self.protocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.protocolBtn setTitle:@"《新概念检车罚款代缴服务须知》" forState:(UIControlStateNormal)];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"订单合计";
    label.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:label];
    
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(0);
        make.leading.equalTo(self.contentView).offset(0);
        make.trailing.equalTo(self.contentView).offset(0);
        make.height.equalTo(@230);
        
    }];
    
    [fineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(15);
        //        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.left.equalTo(self.contentView).offset(25);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@25);
        
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(fineLabel.mas_bottom).offset(15);
        //        make.left.equalTo(self.contentView.mas_left).offset(20);
//        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.centerX.equalTo(@0);
        make.width.equalTo(@250);
        make.height.equalTo(@150);
        
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(backView.mas_bottom).offset(15);
//        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.width.equalTo(@20);
        make.height.equalTo(self.btn.mas_width).offset(0);
        
    }];
    
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.btn.mas_top).offset(0);
        make.left.equalTo(self.btn.mas_right).offset(5);
        make.width.equalTo(@93);
        make.height.equalTo(self.btn.mas_width).offset(0);
        
    }];
    
    
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.btn.mas_top).offset(0);
        make.left.equalTo(self.agreeLabel.mas_right).offset(-2);
//        make.right.equalTo(self.contentView.mas_right).offset(10);
        make.width.equalTo(@200);
        make.height.equalTo(self.btn.mas_width).offset(0);
        
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.btn.mas_left).offset(15);
//        make.top.equalTo(self.contentView.mas_bottomMargin).offset(0);
        make.top.equalTo(self.btn.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(10);
        make.height.equalTo(self.btn.mas_width).offset(0);
        
    }];
    
    [self setNeedsUpdateConstraints];
//    self.agreeLabel = [uila]
}

// 是否同意按钮
-(void)clickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(agreeAction:)]) {
        [self.delegate agreeAction:sender.selected];
    }
}

// 选择图片
-(void)chooseImgAction:(NSNotification *)notice{
    
    if ([self.delegate respondsToSelector:@selector(chooseImageAction:)]) {
        [self.delegate chooseImageAction:notice];
    }
    
}

// 须知按钮
-(void)clickKnowAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(knowProtocolAction:)]) {
        [self.delegate knowProtocolAction:sender];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
