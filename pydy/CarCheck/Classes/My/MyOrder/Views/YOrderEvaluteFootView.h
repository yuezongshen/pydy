//
//  YOrderEvaluteFootView.h
//  shopsN
//
//  Created by imac on 2016/12/8.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YOrderEvaluteFootViewDelegate <NSObject>

-(void)chooseStar:(NSInteger)star;

@end

@interface YOrderEvaluteFootView : UIView

@property (weak,nonatomic) id<YOrderEvaluteFootViewDelegate>delegate;


@end
