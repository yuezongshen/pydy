//
//  PBPlayViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/3/29.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "PBPlayViewController.h"
#import "UIImageView+WebCache.h"
#import "PBPlayBtnView.h"


#import "UIImage+Blur.h"

@interface PBPlayViewController ()

@property (nonatomic, strong) UIScrollView *aScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) PBPlayBtnView *playBtnView;
@end

@implementation PBPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)setPlayContentDic:(NSDictionary *)playContentDic
{
    if (_playContentDic != playContentDic) {
        if (self.isMyData) {
            NSArray *cArr = playContentDic[@"info"];
            if ([cArr isKindOfClass:[NSArray class]]) {
                if (cArr.count) {
                    _playContentDic = cArr[0];
                    [self configPlayView];
                    return;
                }
            }
        }
        _playContentDic = playContentDic;
        [self configPlayView];
    }
}
- (void)configPlayView
{
    self.title = @"播放详情";
    
    [self.view addSubview:self.aScrollView];
    
    NSString *imageUrl = [Utility verifyActionWithString:_playContentDic[@"InfoPicture"]];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeightScale(220))];
    imageV.image = [[UIImage imageNamed:@"agency"] blurImageWithBlur:0.5 exclusionPath:nil];
//    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseAPI,imageUrl]] placeholderImage:[UIImage imageNamed:@"agency"]];
    // 开启异步函数，获取下载图片，获取尺寸
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [strongSelf selectContinent:continent atFirstTime:NO];
//    });
    
//    dispatch_queue_t queue = dispatch_queue_create("cn.xxx.queue", DISPATCH_QUEUE_SERIAL);
//          dispatch_async(queue, ^{
//                             NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseAPI,imageUrl]]];
//                            UIImage *image = [UIImage imageWithData:data];
//                             // 回到主线程执行
//                             dispatch_sync(dispatch_get_main_queue(), ^(){
//                                 imageV.image = [image blurImageWithBlur:0.5 exclusionPath:nil];
//
//                                 });
//                       });
    [self.aScrollView addSubview:imageV];
    
    if (imageUrl.length) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kHeightScale(135), kHeightScale(135))];
        imageView.center = imageV.center;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseAPI,imageUrl]] placeholderImage:[UIImage imageNamed:@"agency"]];
        [self.aScrollView addSubview:imageView];
    }
  
    UIImageView *hImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageV.frame)+15, 40, 40)];
    [hImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseAPI,imageUrl]] placeholderImage:[UIImage imageNamed:@"agency"]];
    hImageV.layer.cornerRadius = 20;
    hImageV.layer.masksToBounds = YES;
    [self.aScrollView addSubview:hImageV];
    
    [self.titleLabel setFrame:CGRectMake(CGRectGetMaxX(hImageV.frame)+5, CGRectGetMinY(hImageV.frame), CGRectGetWidth(self.view.frame)-CGRectGetMaxX(hImageV.frame)-5-10, CGRectGetHeight(hImageV.frame))];
    [self.titleLabel setText:_playContentDic[@"InfoTitle"]];
    [self.aScrollView addSubview:self.titleLabel];
    
    [self.aScrollView addSubview:self.progressView];
    
    [self.aScrollView addSubview:self.playBtnView];
    
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playBtnView.frame)+20, CGRectGetWidth(self.view.frame), 0.5)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self.aScrollView addSubview:lineV];
    
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lineV.frame)+5, 200, 20)];
    introLabel.text = @"内容介绍";
    introLabel.font = [UIFont systemFontOfSize:14];
    introLabel.textColor = [UIColor lightGrayColor];
    [self.aScrollView addSubview:introLabel];
    lineV = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(introLabel.frame)+5, CGRectGetWidth(self.view.frame)-10, 0.5)];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [self.aScrollView addSubview:lineV];
  
    NSString *titleStr = _playContentDic[@"InfoContent"];
    [self.contentLabel setText:titleStr];
    CGSize size = [titleStr boundingRectWithSize:CGSizeMake( CGRectGetWidth(self.view.frame)-30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.contentLabel.font} context:nil].size;
    [self.contentLabel setFrame:CGRectMake(15, CGRectGetMaxY(lineV.frame), CGRectGetWidth(self.view.frame)-30, size.height+10)];
    [self.aScrollView addSubview:self.contentLabel];
    
    _aScrollView.contentSize = CGSizeMake(KWidth, CGRectYH(_contentLabel)+50);
    [_aScrollView setContentInset:UIEdgeInsetsZero];
}

- (void)playViewActionWithString:(NSString *)str
{
    if ([str isKindOfClass:[NSString class]]) {
        if (str.length) {
            [self.playBtnView.playBtn setSelected:YES];
            [self performSelector:@selector(perStartSpeakingString:) withObject:str afterDelay:1.0];
            return;
        }
    }
    [ZQLoadingView showAlertHUD:@"播放内容为空" duration:SXLoadingTime];
}
- (void)perStartSpeakingString:(NSString *)str
{
    
}

- (UIScrollView *)aScrollView
{
    if (!_aScrollView) {
        _aScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _aScrollView.backgroundColor = MainBgColor;
    }
    return _aScrollView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame)+10, CGRectGetWidth(self.view.frame)-20, 10)];
        _progressView.backgroundColor = LH_RGBCOLOR(17,149,232);
    }
    return _progressView;
}
- (void)playBtnAction:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    if (sender.selected) {
        NSString *string = self.playContentDic[@"InfoContent"];
        if ([string isKindOfClass:[NSString class]]) {
            if (string.length) {
               
                return ;
            }
        }
        [ZQLoadingView showAlertHUD:@"播放内容为空" duration:SXLoadingTime];
        [self.playBtnView playDone];
    }
    else
    {
        if (self.pDelegate) {
            [self.pDelegate NextUpBtnCallBackAction:0];
        }
    }
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if (_playBtnView) {
//        _playBtnView.playBtn.selected = ((IFlySpeechSynthesizer *)[IFlySpeechSynthesizer sharedInstance]).isSpeaking;
//    }
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_playBtnView) {
        _playBtnView.playBtn.selected = self.isStop;
    }
}
- (PBPlayBtnView *)playBtnView
{
    if (!_playBtnView) {
        _playBtnView = [[PBPlayBtnView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_progressView.frame)+10, CGRectGetWidth(self.view.frame), 55)];
        [_playBtnView.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        __weak typeof(self) weakSelf = self;
        _playBtnView.upAction = ^{
            __strong typeof(self) strongSelf = weakSelf;
//            NSInteger index = [strongSelf.playContentArray indexOfObject:strongSelf.playContentDic];
            if (strongSelf.pPlayIndex==0) {
                [ZQLoadingView showAlertHUD:@"没有上一篇了" duration:SXLoadingTime];
                return ;
            }
            if (strongSelf.pPlayIndex-1<strongSelf.playContentArray.count) {
                strongSelf.pPlayIndex--;
                strongSelf.playContentDic = strongSelf.playContentArray[strongSelf.pPlayIndex];
                [strongSelf playViewActionWithString:strongSelf.playContentDic[@"InfoContent"]];
                if (strongSelf.pDelegate) {
                    [strongSelf.pDelegate NextUpBtnCallBackAction:1];
                }
                
            }
            else
            {
                [ZQLoadingView showAlertHUD:@"没有上一篇了" duration:SXLoadingTime];
            }
        };
        _playBtnView.nextAction = ^{
            __strong typeof(self) strongSelf = weakSelf;
//            NSInteger index = [strongSelf.playContentArray indexOfObject:strongSelf.playContentDic];
            if (strongSelf.pPlayIndex+1 <strongSelf.playContentArray.count) {
                strongSelf.pPlayIndex++;
                strongSelf.playContentDic = strongSelf.playContentArray[strongSelf.pPlayIndex];
                [strongSelf playViewActionWithString:strongSelf.playContentDic[@"InfoContent"]];
                if (strongSelf.pDelegate) {
                    [strongSelf.pDelegate NextUpBtnCallBackAction:2];
                }
                
//                if (strongSelf.playCallBackAction) {
//                    strongSelf.playCallBackAction(2);
//                }
            }
            else
            {
                [ZQLoadingView showAlertHUD:@"没有下一篇了" duration:SXLoadingTime];
            }
        };
    }
    return _playBtnView;
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
