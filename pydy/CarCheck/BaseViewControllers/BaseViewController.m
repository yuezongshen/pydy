//
//  BaseViewController.m
//  shopSN
//
//  Created by imac on 15/12/1.
//  Copyright © 2015年 imac. All rights reserved.
//

#import "BaseViewController.h"
#import "ZQLoginViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
/**
 *  注册通知
 */
-(void)registerNotification{
    
    
    
}


#pragma mark - ==== 页面设置 =====
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count) {
        if (self.navigationController.viewControllers.count==1) {
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        }
        else
        {
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }
    }
    else
    {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:MainBgColor];
    if (@available(iOS 11.0,*))  {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;\
    }
}


-(void)addNavigationBar{
    
//    if (self.navigationController.childViewControllers.count && [self.navigationController.childViewControllers[0] isEqual:self])
//    {
//    }
//    else
//    {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    }

    
}

// 检测登录
-(void)checkLogin {
    
    if ([Utility isLogin]) {
        
    }else {
        
        ZQLoginViewController *loginVC = [[ZQLoginViewController alloc] init];
        [self.navigationController presentViewController:loginVC animated:YES completion:^{
            
        }];
        
    }
    
}

/**
 *  返回  调用
 */
-(void)back{
//    NSLog(@"返回前页面");
    
    if (self.navigationController.viewControllers.count>1) {
         [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 *  更多  调用
 */
//-(void)more{
//    
//}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleLightContent;
}

/**
 *  结束编辑
 */
-(void)allResignFirstResponder{
//    NSLog(@"allResignFirstResponder====");
    
    [self.view endEditing:YES];
}
-(void)dealloc{
//    NSLog(@"界面销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
