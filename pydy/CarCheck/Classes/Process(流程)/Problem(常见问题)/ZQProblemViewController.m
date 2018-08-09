//
//  ZQHtmlViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQProblemViewController.h"
#import <WebKit/WebKit.h>

@interface ZQProblemViewController ()<WKNavigationDelegate>

@property (nonatomic, copy) NSString *urlString;
@end

@implementation ZQProblemViewController

- (id)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"常见问题";
    CGRect rect = self.view.bounds;
    if (![_urlString hasPrefix:@"https://"])
    {
        _urlString = @"https://www.baidu.com";
        rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds));
//        [self addBottomBtn];
    }
    WKWebView *webView = [[WKWebView alloc] initWithFrame:rect];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    [self.view addSubview:webView];
}
- (void)addBottomBtn
{
    CGFloat width = CGRectGetWidth(self.view.bounds)/2;
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(width*i,  CGRectGetHeight(self.view.bounds)-44,width, 44)];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        if (i) {
            [button setBackgroundColor:LH_RGBCOLOR(12,189,49)];
            [button setTitle:@"立即预约" forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundColor:LH_RGBCOLOR(17,149,232)];
            [button setImage:[UIImage imageNamed:@"naviIcon"] forState:UIControlStateNormal];
            [button setTitle:@"导航到点" forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)bottomBtnAction:(UIButton *)sender
{
    if (sender.tag) {
        //        立即预约
    }
    else
    {
        //        导航到店
    }
}
//**WKNavigationDelegate*
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //获取请求的url路径.
    NSString *requestString = navigationResponse.response.URL.absoluteString;
    NSLog(@"requestString:%@",requestString);
    // 遇到要做出改变的字符串
    NSString *subStr = @"www.baidu.com";
    if ([requestString rangeOfString:subStr].location != NSNotFound) {
        NSLog(@"这个字符串中有subStr");
        //回调的URL中如果含有百度，就直接返回，也就是关闭了webView界面
        [self.navigationController  popViewControllerAnimated:YES];
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
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

