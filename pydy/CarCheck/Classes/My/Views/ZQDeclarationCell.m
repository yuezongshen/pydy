//
//  ZQDeclarationCell.m
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/4.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQDeclarationCell.h"

@interface ZQDeclarationCell ()<UITextViewDelegate>

@property (strong,nonatomic) UITextView *inputTV;
@property (strong,nonatomic) UILabel *titleLb;
@property (strong,nonatomic) UIImageView *pointImageV;
@end

@implementation ZQDeclarationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self addSubview:self.titleLb];
    [self addSubview:self.inputTV];
//    [_inputTV addSubview:self.plachorLb];
}
- (void)configTitle:(NSString *)title
{
    [self.titleLb setText:title];
    _titleLb.font = MFont(15);
    CGRect rect = self.titleLb.frame;
    rect.origin.x += 24;
    self.titleLb.frame = rect;
    [self addSubview:self.pointImageV];
    
    rect = self.inputTV.frame;
    rect.origin.x+=24;
    rect.size.width-=24;
    self.inputTV.frame = rect;
}
- (void)configTextFeild:(NSString *)tfText
{
     [self.inputTV setEditable:NO];
     [self.inputTV setText:tfText];
}
- (void)configTextFeildText:(NSString *)tfText
{
    [self.inputTV setText:tfText];
}

#pragma mark ==懒加载==

- (UIImageView *)pointImageV
{
    if (!_pointImageV) {
        _pointImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"front_point"]];
        _pointImageV.center = CGPointMake(17, 8+14);
    }
    return _pointImageV;
}
-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 14, 100, 15)];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.textColor = LH_RGBCOLOR(119, 119, 119);
        _titleLb.font = MFont(13);
        _titleLb.text = @"导游宣言:";
    }
    return _titleLb;
}

-(UITextView *)inputTV{
    if (!_inputTV) {
        _inputTV = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectYH(_titleLb)+8, __kWidth-20, 50)];
        _inputTV.backgroundColor = __BackColor;
        _inputTV.textAlignment = NSTextAlignmentLeft;
        _inputTV.font = MFont(12);
        _inputTV.delegate = self;
        _inputTV.returnKeyType = UIReturnKeyDone;
    }
    return _inputTV;
}

//-(UILabel *)plachorLb{
//    if (!_plachorLb) {
//        _plachorLb = [[UILabel alloc]initWithFrame:CGRectMake(11, 7, 200, 15)];
//        _plachorLb.textAlignment = NSTextAlignmentLeft;
//        _plachorLb.textColor = LH_RGBCOLOR(198, 198, 198);
//        _plachorLb.font = MFont(12);
//        _plachorLb.text = @"";
//    }
//    return _plachorLb;
//}

#pragma mark ==UITextViewDelegate==
-(void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length>0) {
//        _plachorLb.hidden = YES;
//    }else{
//        _plachorLb.hidden = NO;
//    }
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (!IsNilString(textView.text)) {
        if (self.dTextBack) {
            self.dTextBack(textView.text);
        }
    }
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
//    if (textView.text.length>1) {
//        _plachorLb.hidden = YES;
//    }else{
//        _plachorLb.hidden = NO;
//    }
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
