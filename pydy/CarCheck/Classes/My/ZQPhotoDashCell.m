//
//  ZQPhotoDashCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2018/7/5.
//  Copyright © 2018年 zhangqiang. All rights reserved.
//

#import "ZQPhotoDashCell.h"

@implementation ZQPhotoDashCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MainBgColor;
//        self.contentView.backgroundColor = [UIColor redColor];
        UIImageView *bottomV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"upload_icon"]];
        bottomV.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2-5);
        [self.contentView addSubview:bottomV];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 20)];
        label.center = CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame)/2+22);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = __TestGColor;
        label.text = @"0/12";
        [self.contentView addSubview:label];
        self.numLabel = label;
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGFloat lengths[] = {5,5,5,5};
    
    
    CGRect aRect= CGRectMake(10, 10,self.bounds.size.width-10*2,self.bounds.size.height-10*2);
    CGContextSetRGBStrokeColor(context, 68.0/255.0, 68.0/255.0, 68.0/255.0, 1.0);
    CGContextSetLineDash(context, 0, lengths, 4);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddRect(context, aRect);
    CGContextDrawPath(context, kCGPathStroke);
}
@end
