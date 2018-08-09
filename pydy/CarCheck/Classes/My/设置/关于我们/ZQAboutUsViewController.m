//
//  ZQAboutUsViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQAboutUsViewController.h"

@interface ZQAboutUsViewController ()

@property (strong,nonatomic) UIImageView *QRIV;
@end

@implementation ZQAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self initView];
//    [self getData];
}
-(void)getData{
    
    NSString *checkUrl = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",@""];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = checkUrl;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    self.QRIV.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:120];
}
-(void)initView{
    //main
    UIImageView *loginIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-70)/2, 130, 70, 70)];
    [self.view addSubview:loginIV];
    loginIV.image =MImage(@"appIcon");
    
    UILabel *versionLb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(loginIV)+5, __kWidth, 20)];
    [self.view addSubview:versionLb];
    versionLb.textAlignment = NSTextAlignmentCenter;
    versionLb.font = MFont(15);
    versionLb.textColor = __DTextColor;
    versionLb.text = ZQPROJECTNAME;
    
    UILabel *listLb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectYH(versionLb), __kWidth, 15)];
    [self.view addSubview:listLb];
    listLb.textAlignment = NSTextAlignmentCenter;
    listLb.font = MFont(11);
    listLb.textColor = __TextColor;
    listLb.text = [NSString stringWithFormat:@"v %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    self.QRIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-150)/2, CGRectYH(versionLb)+30, 150, 150)];
    self.QRIV.image = MImage(@"appIcon");
    [self.view addSubview:self.QRIV];

    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-180)/2, __kHeight-76, 80, 30)];
//    label.font = [UIFont systemFontOfSize:16];
//    label.textColor = [UIColor darkTextColor];
//    label.text = @"客服热线: ";
//    [self.view addSubview:label];
//    
//    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),CGRectGetMinY(label.frame),100, 30)];
//    phoneBtn.titleLabel.font = MFont(16);
//    [phoneBtn setTitle:[Utility getServerPhone] forState:BtnNormal];
//    [phoneBtn setTitleColor:__DefaultColor forState:BtnNormal];
//    //    [phoneBtn setTitleColor:[UIColor blueColor] forState:BtnNormal];
//    [phoneBtn addTarget:self action:@selector(phoneBtnAction) forControlEvents:BtnTouchUpInside];
//    [self.view addSubview:phoneBtn];
//    
//    UILabel*rightLb =[[UILabel alloc]initWithFrame:CGRectMake((__kWidth-200)/2, CGRectGetMaxY(label.frame), 200, 20)];
//    [self.view addSubview:rightLb];
//    rightLb.textAlignment = NSTextAlignmentCenter;
//    rightLb.textColor = __TextColor;
//    rightLb.font = MFont(16);
//    rightLb.text = @"微信公众号: 智慧党建";

}
- (void)phoneBtnAction
{
    [Utility phoneCallAction];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
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
