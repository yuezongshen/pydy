//
//  ZQNewMyViewController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQNewMyViewController.h"
#import "ZQSettingViewController.h"
#import "ZQMyOrderViewController.h"
#import "ZQLoginViewController.h"

#import "BaseNavigationController.h"
#import "UIButton+WebCache.h"

#import "UIViewController+MMDrawerController.h"
#import "ZQValuationController.h"
#import "ZQUpVioViewController.h"
#import "ZQMyMoneyViewController.h"
#import "pydy/pydy.h"

#import "ZQVoiceRecordController.h"

static CGFloat kImageOriginHight = 200.f;
@interface ZQNewMyViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
     NSArray *_titleArray;
     UIImageView *expandZoomImageView;
}
@property (strong, nonatomic) UITableView *tableView;
//@property (strong, nonatomic) UIImageView *headIV;
@property (strong, nonatomic) UIButton *headBtn;
@property (strong, nonatomic) UILabel *phoneLabel;
@property (strong, nonatomic) UILabel *comL;

@property (strong, nonatomic) NSDictionary *contentDic;

@property (nonatomic, strong) LGAudioPlayer *audioPlayer;
@end

@implementation ZQNewMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@[@{@"title":@"待确认",@"image":@"pending_confirm"},@{@"title":@"进行中",@"image":@"ongoing"},@{@"title":@"已完成",@"image":@"over_icon"},@{@"title":@"我的评价",@"image":@"appraise"},@{@"title":@"完善信息",@"image":@"info_icon"},@{@"title":@"提现申请",@"image":@"money_apply"}]];

    [self.view addSubview:self.tableView];
    
    UIButton *_putBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(self.view.frame)-50, 300, 50)];
    _putBtn.backgroundColor = HEXCOLOR(0x292933);
    _putBtn.titleLabel.font = MFont(18);
    [_putBtn setTitle:@"退出登陆" forState:BtnNormal];
    [_putBtn setTitleColor:__MoneyColor forState:BtnNormal];
    [_putBtn addTarget:self action:@selector(logoutAction) forControlEvents:BtnTouchUpInside];
    [self.view addSubview:_putBtn];
}
- (void)setMyHeaderView:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *guide_headimgStr = dic[@"guide_headimg"];
        if ([guide_headimgStr isKindOfClass:[NSString class]]) {
            if (guide_headimgStr.length) {
                if ([guide_headimgStr rangeOfString:@"http"].location == NSNotFound) {
                    guide_headimgStr = [NSString stringWithFormat:@"%@%@",ImageBaseAPI,guide_headimgStr];
                }
                [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:guide_headimgStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_head"]];
            }
            else
            {
                [self.headBtn setBackgroundImage:MImage(@"user_head") forState:UIControlStateNormal];
            }
        }
        else
        {
            [self.headBtn setBackgroundImage:MImage(@"user_head") forState:UIControlStateNormal];
        }
        [self setPhoneTextStr:dic[@"name"] andSex:[dic[@"sex"] integerValue]];
        [self.comL setText:dic[@"company"]];
        self.contentDic = dic;
    }
    else
    {
        [self.headBtn setBackgroundImage:MImage(@"user_head") forState:UIControlStateNormal];
        [self setPhoneTextStr:@"xxxxxx" andSex:[dic[@"sex"] integerValue]];
        [self.comL setText:@"xxxxxxxx"];
        self.contentDic = nil;
    }
    [self.tableView reloadData];
}
- (void)logoutAction
{
    [self deleteAudioAction];
    [Utility setLoginStates:NO];
    ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
    BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self.mm_drawerController presentViewController:loginNa animated:YES completion:^{
        [self.mm_drawerController closeDrawerAnimated:NO completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
//            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
//        [[NSNotificationCenter defaultCenter] postNotificationName:ZQdidLogoutNotication object:nil];
    }];
}
- (void)setPhoneTextStr:(NSString *)contentStr andSex:(NSInteger)sex
{
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    if (sex==1) {
        attchImage.image = [UIImage imageNamed:@"man"];
    }
    else
    {
        attchImage.image = [UIImage imageNamed:@"woman"];
    }
    attchImage.bounds = CGRectMake(10, -2, attchImage.image.size.width/2, attchImage.image.size.height/2);
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    [attriStr insertAttributedString:stringImage atIndex:contentStr.length];
    self.phoneLabel.attributedText = attriStr;
}
- (void)userInfoRequest
{
//    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
//    api/Ln/myinfo
    [JKHttpRequestService POST:@"api/Ln/myinfo" withParameters:@{@"token":[Utility getWalletPayPassword]} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            if (strongSelf)
            {
                [strongSelf setPhoneTextStr:jsonDic[@"data"][@"MemberName"] andSex:1];
                
                [strongSelf.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageBaseAPI,[Utility verifyActionWithString:jsonDic[@"data"][@"imgurl"]]]] forState:UIControlStateNormal placeholderImage:MImage(@"user_head")];

            }
        }
        else
        {
            [ZQLoadingView showAlertHUD:jsonDic[@"info"] duration:SXLoadingTime];
            [strongSelf.phoneLabel setText:@"未登录"];
            [strongSelf.headBtn setBackgroundImage:MImage(@"user_head") forState:UIControlStateNormal];
            [Utility setLoginStates:NO];
        }
    } failure:^(NSError *error) {
//        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.phoneLabel setText:@"未登录"];
        [strongSelf.headBtn setBackgroundImage:MImage(@"user_head") forState:UIControlStateNormal];
    } animated:NO];
}
//更换头像
- (void)headBtnAction
{

    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        //想要知道选择的图片
        pickerVC.delegate = self;
        //开启编辑状态
        pickerVC.allowsEditing = YES;
        [self presentViewController:pickerVC animated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheetController addAction:cameraAction];
    [actionSheetController addAction:albumAction];
    [actionSheetController addAction:cancelAction];
    [self presentViewController:actionSheetController animated:YES completion:nil];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGRect f = expandZoomImageView.frame;
    f.origin.y = yOffset;
    f.size.height =  -yOffset+kImageOriginHight;
    expandZoomImageView.frame = f;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempArr = _titleArray[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_idMy"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell_idMy"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        UILabel *_goingNumLabel  = [[UILabel alloc] initWithFrame:CGRectMake(0,0,20,20)];
        _goingNumLabel.font = [UIFont systemFontOfSize:10];
        _goingNumLabel.textAlignment = NSTextAlignmentCenter;
        _goingNumLabel.backgroundColor = __MoneyColor;
        _goingNumLabel.textColor = [UIColor whiteColor];
        _goingNumLabel.layer.cornerRadius = CGRectGetWidth(_goingNumLabel.frame)/2;
        _goingNumLabel.layer.masksToBounds = YES;
        cell.accessoryView = _goingNumLabel;
        cell.backgroundColor = HEXCOLOR(0x2c2f38);
    }
    UILabel *label = (UILabel *)cell.accessoryView;
    switch (indexPath.row) {
        case 0:
            {
                if (self.contentDic) {
                    [label setText:self.contentDic[@"confirmNum"]];
                }
                else
                {
                    label.text = @"0";
                }
                label.hidden = NO;
            }
            break;
        case 1:
        {
            if (self.contentDic) {
                [label setText:self.contentDic[@"conductNum"]];
            }
            else
            {
                label.text = @"0";
            }
            label.hidden = NO;
        }
            break;
        default:
            label.hidden = YES;
            break;
    }
    NSDictionary *dic = _titleArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    cell.textLabel.text = dic[@"title"];
    return cell;
}
- (void)dealloc
{
    NSLog(@"MY+dealloc");
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    BaseNavigationController* nav = (BaseNavigationController*)self.mm_drawerController.centerViewController;
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
            {
                ZQMyOrderViewController *myOrderVc = [[ZQMyOrderViewController alloc] initWithOrderViewType:(ZQOrderViewType)indexPath.row];
                [nav pushViewController:myOrderVc animated:NO];
            }
            break;
        case 3:
        {
            ZQValuationController *valuationC = [[ZQValuationController alloc] init];
            [nav pushViewController:valuationC animated:NO];
        }
            break;
        case 4:
        {
            ZQUpVioViewController *vioVc = [[ZQUpVioViewController alloc] init];
            [nav pushViewController:vioVc animated:NO];
        }
            break;
        case 5:
        {
            ZQMyMoneyViewController *applyVC = [[ZQMyMoneyViewController alloc] init];
            [nav pushViewController:applyVC animated:NO];
        }
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

   /*
    switch (indexPath.section) {
        case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        ZQMyOrderViewController *myOrderVc = [[ZQMyOrderViewController alloc] init];
                        [myOrderVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myOrderVc animated:YES];
                    }
                        break;
                    case 1:
                    {
                        //新车免检预约订单
                        ZQNewCarOrderViewController *myOrderVc = [[ZQNewCarOrderViewController alloc] init];
                        [myOrderVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myOrderVc animated:YES];
                    }
                        break;
                    case 2:
                    {
    
                    }
                        break;
                    case 3:{
                        //VIP服务
                        //                        ZQNewVIPViewController *myVipVc = [[ZQNewVIPViewController alloc] initWithNibName:@"ZQNewVIPViewController" bundle:nil];
                        //                        [myVipVc setHidesBottomBarWhenPushed:YES];
                        //                        [self.navigationController pushViewController:myVipVc animated:YES];
                        ZQBuyVipViewController *myMoneyVc = [[ZQBuyVipViewController alloc] init];
                        [myMoneyVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myMoneyVc animated:YES];
                    }
                        break;
                    case 4:
                    {
                        //我的钱包
                        ZQMyMoneyViewController *myMoneyVc = [[ZQMyMoneyViewController alloc] init];
                        [myMoneyVc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:myMoneyVc animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
            break;
        case 1:{
            //我的消息
            ZQMessageViewController *messageVC = [[ZQMessageViewController alloc] init];
            [messageVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 2:
        {
            //客服电话
            [Utility phoneCallAction];
        }
            break;
        case 3:
        {
            //设置
            ZQSettingViewController *setVC = [[ZQSettingViewController alloc] init];
            [setVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        default:
            break;
    }
    */
}

// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    return 10;
//}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = nil;
    if (picker.allowsEditing) {
        image = [self scaleImage:info[UIImagePickerControllerEditedImage] toScale:0.5];
    }
    else
    {
        image = [self scaleImage:info[UIImagePickerControllerOriginalImage] toScale:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    //保存图片进入沙盒中
    [self saveImage:image withName:@"headImage"];
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    NSLog(@"%@",NSStringFromCGSize(scaledImage.size));
    return scaledImage;
}
#pragma mark - 上传头像
-(void)saveImage:(UIImage*)headImage withName:(NSString*)imageName{
//    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5);
    
    [self modifyUserHeadimgWith:headImage];
}
- (NSData *)imageData:(UIImage *)myimage{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
            
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
            
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
            
        }    }
    return data;
    
}
-(void)modifyUserHeadimgWith:(UIImage *)image{
    NSString *imgStr = [[self imageData:image] base64EncodedStringWithOptions:(NSDataBase64Encoding64CharacterLineLength)];
    [ZQLoadingView showProgressHUD:@"loading..."];
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"appuser/personinfo" withParameters:@{@"guide_id":[Utility getUserID],@"user_header":imgStr} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        [ZQLoadingView hideProgressHUD];
        __strong typeof(self) strongSelf = weakSelf;
        if (succe) {
            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
           [strongSelf.headBtn setBackgroundImage:image forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        [ZQLoadingView hideProgressHUD];
        
    } animated:NO];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, (__kWidth == 320 ? 260:300), self.view.bounds.size.height - 50) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXCOLOR(0x2c2f38);
        _tableView.estimatedSectionHeaderHeight = 10;
        _tableView.estimatedSectionFooterHeight = 0;
        
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, KWidth, kImageOriginHight)];
        headView.backgroundColor = HEXCOLOR(0x292933);
        headView.autoresizesSubviews = YES;
        _tableView.tableHeaderView = headView;

        UIImageView *redBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, -50, CGRectGetWidth(headView.frame), 50)];
        redBg.backgroundColor = HEXCOLOR(0x292933);
        [headView addSubview:redBg];
        
        //        self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake((__kWidth-80)/2,(kImageOriginHight-80)/2, 80, 80)];
        //        _headIV.layer.cornerRadius = 40;
        //        _headIV.layer.borderColor = [UIColor whiteColor].CGColor;
        //        _headIV.layer.borderWidth = 2.5;
        //        _headIV.image =MImage(@"user_head");
        //        _headIV.clipsToBounds = YES;
        //        _headIV.contentMode =UIViewContentModeScaleAspectFill;
        //        [headView addSubview:_headIV];
        
        self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setFrame:CGRectMake(18,60, 76, 76)];
        _headBtn.layer.cornerRadius = 38;
        _headBtn.layer.borderColor = __MoneyColor.CGColor;
        _headBtn.layer.borderWidth = 2.5;
        _headBtn.clipsToBounds = YES;
        [_headBtn addTarget:self action:@selector(headBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:_headBtn];
        
//        self.VIPImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VIP_Head_logo"]];
//        [self.VIPImageV setCenter:CGPointMake(CGRectGetMaxX(_headBtn.frame)-8, CGRectGetMaxY(_headBtn.frame)-15)];
//        [headView addSubview:_VIPImageV];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headBtn.frame)+16, CGRectGetMinY(_headBtn.frame), 160, 24)];
        [_phoneLabel setTextColor:[UIColor whiteColor]];
        [_phoneLabel setFont:[UIFont systemFontOfSize:18]];
        [_phoneLabel setText:@"xxxxxx"];
        [headView addSubview:_phoneLabel];
        
        UILabel *comL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneLabel.frame), CGRectGetMaxY(_phoneLabel.frame), CGRectGetWidth(_phoneLabel.frame), 20)];
        comL.textColor = HEXCOLOR(0x6d7175);
        comL.text = @"xxxxxxxx";
        comL.font = [UIFont systemFontOfSize:12];
        [headView addSubview:comL];
        self.comL = comL;
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetMinX(_phoneLabel.frame), CGRectGetMaxY(comL.frame)+16, 90, 30);
        btn.backgroundColor = HEXCOLOR(0x5b6076);
        btn.layer.cornerRadius = 4;
        [btn addTarget:self action:@selector(soundBtnAtion:) forControlEvents:BtnTouchUpInside];
        [headView addSubview:btn];
        
        UIImageView *sound1V = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_icon"]];
        sound1V.center = CGPointMake(15, 15);
        [btn addSubview:sound1V];
        
        sound1V = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_i"]];
        sound1V.center = CGPointMake(80, 15);
        [btn addSubview:sound1V];
        
        comL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, CGRectGetMinY(btn.frame), 30, 30)];
        comL.textColor = HEXCOLOR(0x6d7175);
        comL.text = @"试听";
        comL.font = [UIFont systemFontOfSize:12];
        [headView addSubview:comL];
    }
    return _tableView;
}
- (LGAudioPlayer *)audioPlayer
{
    if (!_audioPlayer) {
        _audioPlayer = [[LGAudioPlayer alloc] init];
        __weak typeof(self) weakSelf = self;
        _audioPlayer.startPlaying = ^(AVPlayerItemStatus status, CGFloat duration) {
            if (status == AVPlayerItemStatusReadyToPlay) {
                if (weakSelf.audioPlayer.isLocalFile) {
                    
                } else {
                    //网络
                    NSLog(@"duration %f",duration);
                }
                
            } else {
                if (status == AVPlayerItemStatusFailed) {
                    
                    NSLog(@"音频播放失败，请重试");
                    [ZQLoadingView showAlertHUD:@"音频播放失败，请重试" duration:SXLoadingTime];
                    [weakSelf performSelector:@selector(deleteAudioAction) withObject:nil afterDelay:SXLoadingTime];
                }
                if (weakSelf.audioPlayer.isLocalFile) {
                  
                } else {
                    //网络音频
                }
                
                
            }
            
            
        };
        _audioPlayer.playComplete = ^{
            if (weakSelf.audioPlayer.isLocalFile) {
                NSLog(@"播放完成了");
            } else {
                //网络
                NSLog(@"网络播放完成了");
                [weakSelf performSelector:@selector(deleteAudioAction) withObject:nil afterDelay:SXLoadingTime];
            }
        };
        _audioPlayer.playingBlock = ^(CGFloat currentTime) {
            if (weakSelf.audioPlayer.isLocalFile) {
               
            } else {
                //网络
                NSLog(@"网络播放");

            }
            
        };
    }
    return _audioPlayer;
}
- (void)deleteAudioAction
{
    if (_audioPlayer) {
        self.audioPlayer = nil;
        _audioPlayer = nil;
    }
}
- (void)soundBtnAtion:(UIButton *)sender
{
    if (self.contentDic)
    {
        if (_audioPlayer) {
            sender.selected = !sender.selected;
            [self.audioPlayer pause:sender.selected];
            return;
        }
        else
        {
            NSString *voiceStr = self.contentDic[@"guide_voice"];
            if ([voiceStr isKindOfClass:[NSString class]]) {
                if (voiceStr.length) {
                    if ([voiceStr rangeOfString:@"http"].location == NSNotFound) {
                        voiceStr = [NSString stringWithFormat:@"%@%@",ImageBaseAPI,voiceStr];
                    }
                    [self.audioPlayer startPlayWithUrl:voiceStr isLocalFile:NO];
                    return;
                }
            }
        }
    }
    else
    {
        [self uploadVoiceData];
    }
//  [ZQLoadingView showAlertHUD:@"请到完善信息页面上传录音" duration:SXLoadingTime];
}

- (void)uploadVoiceData
{
    ZQVoiceRecordController *test = [[ZQVoiceRecordController alloc] init];
    __weak typeof(self) weakSelf = self;
    
    test.updateRecordUrl = ^(NSString *urlStr) {
        __strong typeof(self) strongSelf = weakSelf;
//        ZQNewMyViewController *newMyVc = (ZQNewMyViewController *)strongSelf.mm_drawerController.leftDrawerViewController;
        [strongSelf changeAudioUrl:urlStr];
    };
    self.definesPresentationContext = YES;
    test.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    test.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.mm_drawerController presentViewController:test animated:NO completion:nil];
}
- (void)changeAudioUrl:(NSString *)urlStr
{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.contentDic];
    muDic[@"guide_voice"] = urlStr;
    
    self.contentDic = muDic;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    expandZoomImageView.frame = CGRectMake(0, -20, _tableView.frame.size.width, kImageOriginHight+20);
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
//    if ([Utility isLogin]) {
//        [self userInfoRequest];
//    }
//    else
//    {
//        [self.phoneLabel setText:@"未登录"];
////        [self.headBtn setBackgroundImage:MImage(@"user_head") forState:UIControlStateNormal];
//    }
//     [_phoneLabel setText:[Utility getUserName]];

//    NSString *textStr = @"张洋铭\n信息化支撑党支部";
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:textStr];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:8];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [textStr length])];
//
//    [_phoneLabel setAttributedText:attributedString1];
//    [_phoneLabel sizeToFit];
    
//    if ([Utility getUserHeadUrl]) {
//       [_headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageBaseAPI,[Utility getUserHeadUrl]]] forState:UIControlStateNormal placeholderImage:MImage(@"user_head")];
//    }
//    else
//    {
//        [_headBtn setBackgroundImage:MImage(@"user_head") forState:UIControlStateNormal];
//    }
    
//    if ([Utility getIs_vip]) {
//        [self.VIPImageV setHidden:NO];
//    }
//    else
//    {
//        [self.VIPImageV setHidden:YES];
//    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}
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
