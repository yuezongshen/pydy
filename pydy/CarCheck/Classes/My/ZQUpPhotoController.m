//
//  ZQUpPhotoController.m
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/5.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQUpPhotoController.h"
#import "ZQPhotoCell.h"
#import "ZQPhotoDashCell.h"
#import "UIImageView+WebCache.h"

@interface ZQUpPhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *_imagePicker;
    NSMutableArray *photos;
    BOOL wobble;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
@implementation ZQUpPhotoController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}
- (instancetype)initWithUrls:(NSArray *)urls
{
    self = [super init];
    if (self) {
        if (urls) {
            for (NSString *urlStr in urls) {
                if (urlStr.length) {
                    [self.dataArray addObject:urlStr];
                }
            }
        }
        [self.dataArray addObject: [UIImage imageNamed:@"withdraw_bg"]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:self.navigationController.view.bounds];
    bgImageV.image = [UIImage imageNamed:@"info_bg"];
    [self.view addSubview:bgImageV];
    
    self.title = @"完善个人信息";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(uploadPicturesData)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    UILabel *_countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kDevice_Is_iPhoneX?88:64), CGRectGetWidth(self.view.frame), 50)];
    _countLabel.text = @"   上传图片";
    _countLabel.font = [UIFont systemFontOfSize:16];
    _countLabel.textColor = __MoneyColor;
    _countLabel.backgroundColor = __HeaderBgColor;
    [self.view addSubview:_countLabel];
    //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置cell的尺寸
//    CGFloat sapce = 10;
//    [flowLayout setItemSize:CGSizeMake((CGRectGetWidth(self.view.frame)-sapce*5)/3, (CGRectGetWidth(self.view.frame)-5*sapce)/3)];
    CGFloat sapce = 10;
    [flowLayout setItemSize:CGSizeMake((CGRectGetWidth(self.view.frame)-sapce*2)/3, (CGRectGetWidth(self.view.frame)-sapce*2)/3)];
    //设置其布局方向
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //设置其边界(上，左，下，右）
//    flowLayout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(9, CGRectGetMaxY(_countLabel.frame)+5, CGRectGetWidth(self.view.frame)-18,CGRectGetHeight(self.view.frame)-CGRectGetHeight(_countLabel.frame)) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
//    _collectionView.backgroundColor = MainBgColor;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ZQPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    [_collectionView registerClass:[ZQPhotoDashCell class] forCellWithReuseIdentifier:@"ZQPhotoDashCell"];
    [self.view addSubview:_collectionView];
    
    
    
    photos = [[NSMutableArray alloc ] init];

}
- (void)uploadPicturesData
{
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    for (UIImage *obj in self.dataArray) {
        if ([obj isKindOfClass:[NSString class]]) {
            continue;
        }
        if ([obj isKindOfClass:[UIImage class]]) {
            if ([obj isEqual:[UIImage imageNamed:@"withdraw_bg"]]) {
                continue;
            }
        }
        [dataArr addObject:UIImageJPEGRepresentation(obj, 1.0)];

    }
    if (!dataArr.count) {
        [ZQLoadingView showAlertHUD:@"请选择图片上传" duration:SXLoadingTime];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [JKHttpRequestService POST:@"Appuser/picture" Params:@{@"guide_id":[Utility getUserID]} NSArray:dataArr key:@"file" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSArray *images = jsonDic[@"data"];
            if ([images isKindOfClass:[NSArray class]]) {
                if (images.count) {
                    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
                    for (NSString *url in images) {
                        if (url.length) {
                            [array addObject:url];
                        }
                    }
                    if (weakSelf.imgUrlsAction) {
                        weakSelf.imgUrlsAction(array);
                    }
                }
            }
            [ZQLoadingView showAlertHUD:jsonDic[@"msg"] duration:SXLoadingTime];
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf)
            {
                [strongSelf.navigationItem.rightBarButtonItem setEnabled:NO];
            }
        }
    } failure:^(NSError *error) {
        
    } animated:YES];
}

//section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count-1) {
        ZQPhotoDashCell *cell = (ZQPhotoDashCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ZQPhotoDashCell" forIndexPath:indexPath];
        return cell;
    }
    ZQPhotoCell *cell = (ZQPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.tag=indexPath.row;
    //图片
    UIImage *image = self.dataArray[indexPath.row];
    if ([image isKindOfClass:[UIImage class]]) {
        cell.photoImage.image = image;
    }
    else
    {
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"appIcon"]];
    }
    
    
    // 删除按钮
    cell.deleteBtn.tag =indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(doClickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // 长按删除
    //    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc ] initWithTarget:self action:@selector(longPressedAction)];
    //    [cell.contentView addGestureRecognizer:longPress];
    return cell;
}
//这个是两行cell之间的间距（上下行cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;




//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    ZQPhotoCell *cell = (ZQPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row==self.dataArray.count-1) {
        [self doClickAddButton:nil];
    }
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma -mark -doClickActions
//删除按钮
-(void)doClickDeleteButton:(UIButton *)btn
{
    NSString *imageUrl = self.dataArray[btn.tag];
    if ([imageUrl isKindOfClass:[NSString class]]) {
//        if ([imageUrl rangeOfString:@"Public"].location == NSNotFound){
//            return;
//        }
//        imageUrl = [imageUrl componentsSeparatedByString:@"Public"].lastObject;
        __weak typeof(self) weakSelf = self;
        [JKHttpRequestService POST:@"Appuser/delPic" withParameters:@{@"guide_id":[Utility getUserID],@"picname":imageUrl} success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                    __strong typeof(self) strongSelf = weakSelf;
            if (succe) {
                if (strongSelf)
                {
                    [strongSelf.dataArray removeObjectAtIndex:btn.tag];
                    NSIndexPath *path =  [NSIndexPath indexPathForRow:btn.tag inSection:0];
                    [strongSelf.collectionView deleteItemsAtIndexPaths:@[path]];
                    if (weakSelf.imgUrlsAction) {
                        weakSelf.imgUrlsAction(imageUrl);
                    }
                }
            }
        } failure:^(NSError *error) {
            
        } animated:YES];
    }
    else
    {
        [self.dataArray removeObjectAtIndex:btn.tag];
        NSIndexPath *path =  [NSIndexPath indexPathForRow:btn.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[path]];
    }
}
- (void)deletePictureWithStr:(NSString *)imageUrl
{
  
}
//增加按钮
-(void)doClickAddButton:(UIButton *)btn
{
    NSLog(@"-----doClickAddButton-------");
    if (wobble) {
        // 如果是编辑状态则取消编辑状态
        [self cancelWobble];
        
    }else{
        //不是编辑状态，添加图片
        if (self.dataArray.count > 12) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多支持12张" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else
        {
            
            UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openCamera];
                //                UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
                //                pickerVC.delegate = self;
                //                pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                //                [self.tabBarController presentViewController:pickerVC animated:YES completion:nil];
            }];
            UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"我的相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self openPics];
                //                UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
                //                //想要知道选择的图片
                //                pickerVC.delegate = self;
                //                //开启编辑状态
                //                pickerVC.allowsEditing = YES;
                //                (void)(pickerVC.videoQuality = UIImagePickerControllerQualityTypeLow),           // 最低的质量,适合通过蜂窝网络传输
                //                [self presentViewController:pickerVC animated:YES completion:nil];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [actionSheetController addAction:cameraAction];
            [actionSheetController addAction:albumAction];
            [actionSheetController addAction:cancelAction];
            [self presentViewController:actionSheetController animated:YES completion:nil];
        }
    }
    
    NSLog(@"---add--dataArray---%@",self.dataArray);
}
//长按删除
-(void)longPressedAction
{
    NSLog(@"-----longPressedAction-------");
    
    wobble = YES;
    NSArray *array =  [_collectionView subviews];
    
    for (int i = 0; i < array.count; i ++) {
        if ([array[i] isKindOfClass:[ZQPhotoCell class]]) {
            ZQPhotoCell *cell = array[i];
            cell.deleteBtn.hidden = YES;
            cell.photoImage.image = [UIImage imageNamed:@"ensure"];
            cell.tag = 999999;
            // 晃动动画
            [self animationViewCell:cell];
        }
    }
}
// 取消晃动
-(void)cancelWobble
{
    wobble = NO;
    NSArray *array =  [_collectionView subviews];
    for (int i = 0; i < array.count; i ++) {
        if ([array[i] isKindOfClass:[ZQPhotoCell class]]) {
            ZQPhotoCell *cell = array[i];
            cell.deleteBtn.hidden =  YES;
            if (cell.tag == 999999) {
                cell.photoImage.image = [UIImage imageNamed:@"plus"];
            }
            // 晃动动画
            [self animationViewCell:cell];
        }
    }
}
// 晃动动画
-(void)animationViewCell:(ZQPhotoCell *)cell
{
    //摇摆
    if (wobble){
        cell.transform = CGAffineTransformMakeRotation(-0.1);
        
        [UIView animateWithDuration:0.08
                              delay:0.0
                            options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear
                         animations:^{
                             cell.transform = CGAffineTransformMakeRotation(0.1);
                         } completion:nil];
    }
    else{
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             cell.transform = CGAffineTransformIdentity;
                         } completion:nil];
    }
}

#pragma -mark -camera
// 打开相机
- (void)openCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (_imagePicker == nil) {
            _imagePicker =  [[UIImagePickerController alloc] init];
        }
        _imagePicker.delegate = (id)self;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.showsCameraControls = YES;
        _imagePicker.allowsEditing = YES;
        [self.navigationController presentViewController:_imagePicker animated:YES completion:nil];
    }
}
// 打开相册
- (void)openPics {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = (id)self;
    [self presentViewController:_imagePicker animated:YES completion:NULL];
}
// 选中照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [_imagePicker dismissViewControllerAnimated:YES completion:NULL];
    _imagePicker = nil;
    
    // 判断获取类型：图片
    if ([mediaType isEqualToString:@"public.image"]){
        UIImage *theImage = nil;
        
        // 判断，图片是否允许修改
        if ([picker allowsEditing]){
            //获取用户编辑之后的图像
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            // 照片的元数据参数
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage] ;
        }
        theImage = [self thumbnailWithImage:theImage size:CGSizeMake(1360, 907)];
        [self.dataArray insertObject:theImage atIndex:0];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [_collectionView insertItemsAtIndexPaths:@[path]];
        ZQPhotoDashCell *cell = (ZQPhotoDashCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]];
        cell.numLabel.text = [NSString stringWithFormat:@"%ld/12",self.dataArray.count-1];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
// 判断设备是否有摄像头
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}
- (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size
{
    CGSize originalsize = [originalImage size];
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        
        CGFloat rate = 1.0;
        
        CGFloat widthRate = originalsize.width/size.width;
        
        CGFloat heightRate = originalsize.height/size.height;
        
        
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        
        
        CGImageRef imageRef = nil;
        
        
        
        if (heightRate>widthRate)
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
            
        }
        
        else
            
        {
            
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
            
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        
        
        CGContextTranslateCTM(con, 0.0, size.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        
        
        return standardImage;
        
    }
    return originalImage;
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
