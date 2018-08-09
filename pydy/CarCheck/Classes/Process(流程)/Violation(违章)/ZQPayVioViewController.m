//
//  ZQPayVioViewController.m
//  CarCheck
//
//  Created by zhangqiang on 2017/10/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQPayVioViewController.h"
#import "YPayViewController.h"

@interface ZQPayVioViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UITextField *driveCodeTf;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation ZQPayVioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction)];
    [self.imgView addGestureRecognizer:tap];
    self.imgView.userInteractionEnabled = YES;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)sendAction:(id)sender {
    
    YPayViewController *payVC = [[YPayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
}

-(void)chooseImageAction {
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    //想要知道选择的图片
    pickerVC.delegate = self;
    //开启编辑状态
    pickerVC.allowsEditing = YES;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self.imgView setImage:info[UIImagePickerControllerOriginalImage]];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

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
