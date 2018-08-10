//
//  ZQUpPhotoController.h
//  CarCheck
//
//  Created by FYXJ（6） on 2018/7/5.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^imageUrslAction)(NSArray *imageUrls);

@interface ZQUpPhotoController : BaseViewController

@property (nonatomic, copy) imageUrslAction imgUrlsAction;
- (instancetype)initWithUrls:(NSArray *)urls;
@end
