//
//  ZQVioUpTableViewCell.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/31.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQVioUpTableViewCell.h"

@interface ZQVioUpTableViewCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *provinceCodeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftInset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfRightInset;
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

@end

@implementation ZQVioUpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCarProvinceAction:)];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCarProvinceAction:)];
//    [self.imgView addGestureRecognizer:tap1];
//    self.imgView.userInteractionEnabled = YES;
//    [self.provinceCodeLabel addGestureRecognizer:tap2];
//    self.provinceCodeLabel.userInteractionEnabled = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    
    self.contentTf.textColor = __TestOColor;
}

-(void)chooseCarProvinceAction:(UITapGestureRecognizer *)gesture {
    
    if ([self.delegate respondsToSelector:@selector(showChooseView)]) {
        [self.delegate showChooseView];
    }
    
}

-(void)setIsCarCode:(BOOL )isCarCode {
    
    _isCarCode = isCarCode;
    if (_isCarCode) {
        self.titleLabel.backgroundColor = [UIColor redColor];
        self.imgView.hidden = NO;
        self.provinceCodeLabel.hidden = NO;
        self.leftInset.constant = 80.0;
    }else{
        self.leftInset.constant = 8.0;
        self.imgView.hidden = YES;
        self.provinceCodeLabel.hidden = YES;
    }
}

- (void)changeTitleColor:(UIColor *)tColor
{
    if (tColor)
    {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = tColor;
    }
    else
    {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        self.leftInset.constant = -80;
        self.contentTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
}
-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

-(void)setPalceText:(NSString *)palceText {
    _palceText = palceText;
    self.contentTf.placeholder = palceText;
}

-(void)setCellType:(ZqCellType )type title:(NSString *)title placeText:(NSString *)placeText provinceCode:(NSString *)carProvince{
    
    self.title = title;
    self.palceText = placeText;
    self.provinceCodeLabel.text = carProvince;
    switch (type) {
        case ZQVioUpCellType1:
        {
            self.imgView.hidden = NO;
            self.provinceCodeLabel.hidden = NO;
            self.leftInset.constant = 80.0;
            self.contentTf.enabled = YES;
            self.tfRightInset.constant = 8;
            self.rightImgView.hidden = YES;
            self.contentTf.textAlignment = NSTextAlignmentLeft;
            self.contentTf.keyboardType = UIKeyboardTypeASCIICapable;
            self.contentTf.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            break;
        }
        case ZQVioUpCellType2:
        {
            self.leftInset.constant = 2.0;
            self.imgView.hidden = YES;
            self.provinceCodeLabel.hidden = YES;
            self.contentTf.enabled = YES;
//            self.contentTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.contentTf.keyboardType = UIKeyboardTypeDefault;
            self.tfRightInset.constant = 8;
            self.rightImgView.hidden = YES;
            self.contentTf.textAlignment = NSTextAlignmentLeft;
            self.contentTf.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            break;
        }
        case ZQVioUpCellType3:
        {
//            self.leftInset.constant = 8.0;
            self.leftInset.constant = 80.0;
            self.imgView.hidden = YES;
            self.provinceCodeLabel.hidden = YES;
            self.contentTf.enabled = NO;
            self.tfRightInset.constant = 1;
            self.rightImgView.hidden = YES;
            self.contentTf.textAlignment = NSTextAlignmentLeft;
            self.contentTf.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            break;
        }
        case ZQVioUpCellType4:
        {
            // 第二分组
            self.leftInset.constant = 8.0;
            self.imgView.hidden = YES;
            self.provinceCodeLabel.hidden = YES;
            self.contentTf.enabled = YES;
            self.tfRightInset.constant = 8;
            self.rightImgView.hidden = YES;
            self.contentTf.enabled = NO;
            self.contentTf.textAlignment = NSTextAlignmentRight;
            self.contentTf.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            self.contentTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        }
            // 能输入,字在右边
        case ZQVioUpCellType5:
        {
            self.leftInset.constant = 8.0;
            self.imgView.hidden = YES;
            self.provinceCodeLabel.hidden = YES;
            self.contentTf.enabled = YES;
            self.contentTf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.tfRightInset.constant = 8;
            self.rightImgView.hidden = YES;
            self.contentTf.textAlignment = NSTextAlignmentRight;
            self.contentTf.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            break;
        }
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
