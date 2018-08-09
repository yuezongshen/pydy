//
//  FBTextView.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBTextView : UITextView
{
    BOOL _shouldDrawPlaceholder;
}
@property (nonatomic) NSString *placeholder;
@property (nonatomic) UIColor *placeholderColor;
@end
