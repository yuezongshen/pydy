//
//  ZQFeedBackViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQFeedBackViewController.h"
#import "FBTextView.h"

@interface ZQFeedBackViewController ()<UITextViewDelegate>
{
    FBTextView *_textView;
    UITextField *_contactView;
}
@end

@implementation ZQFeedBackViewController

- (void)dealloc {
    [_textView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";

    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat KHWTintMargin = 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KHWTintMargin, 80, 50, 20)];
    label.text = @"标题:";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label];
    
    _contactView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), CGRectGetMinY(label.frame), CGRectGetWidth(self.view.frame)-KHWTintMargin-CGRectGetMaxX(label.frame), 30)];
    _contactView.backgroundColor = [UIColor whiteColor];
    _contactView.borderStyle = UITextBorderStyleRoundedRect;
    
    _contactView.layer.borderColor = HEXCOLOR(0xeeeeee).CGColor;
    _contactView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contactView.returnKeyType = UIReturnKeyDone;
    _contactView.placeholder = @"请输入标题";
    //    _contactView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"选填,便于您联系" attributes:@{NSForegroundColorAttributeName:kHWColor5,NSFontAttributeName:kHWFont5}];
    _contactView.font = [UIFont systemFontOfSize:15];
    _contactView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_contactView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(KHWTintMargin, CGRectGetMaxY(label.frame)+5, 50, 20)];
    label.text = @"内容:";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label];
    
    UIView *textBgView = [[UIView alloc] initWithFrame:CGRectMake(KHWTintMargin, CGRectGetMaxY(label.frame)+5, CGRectGetWidth(self.view.frame)-2*KHWTintMargin, 140)];
    textBgView.backgroundColor = [UIColor whiteColor];
    textBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textBgView.layer.borderWidth = 0.5;
    textBgView.layer.cornerRadius = 8;
    [self.view addSubview:textBgView];

    _textView = [[FBTextView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(textBgView.frame), 140)];
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.showsVerticalScrollIndicator = NO;
    _textView.placeholder = @"请输入内容";
    _textView.backgroundColor = [UIColor whiteColor];
    [textBgView addSubview:_textView];

    [_textView becomeFirstResponder];
    [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:LH_RGBCOLOR(17,149,232)];
    sendBtn.layer.cornerRadius = 4;
    sendBtn.clipsToBounds = YES;
    sendBtn.frame = CGRectMake((CGRectGetWidth(self.view.frame)-200)/2, CGRectGetMaxY(textBgView.frame)+30, 200, 40);
    [self.view addSubview:sendBtn];
    [sendBtn addTarget:self action:@selector(sendFeedback) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
    [self.view addGestureRecognizer:tap];
}
- (void)sendFeedback
{
    
}
- (void)removeKeyboard {
    
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
    
    if ([_contactView isFirstResponder]) {
        [_contactView resignFirstResponder];
    }
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *textView = object; textView.contentOffset = (CGPoint){.x = 0,.y = 0};
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    _textView.contentInset = UIEdgeInsetsZero;
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
