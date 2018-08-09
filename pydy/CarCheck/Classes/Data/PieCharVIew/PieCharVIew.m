//  饼状图
//  PieCharView.m
//  TestBtn
//
//  Created by 许文波 on 15/12/25.
//  Copyright © 2015年 许文波. All rights reserved.
//

#import "PieCharVIew.h"

@implementation PieCharView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#define PI 3.14159265358979323846

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

static inline float radians(double degrees) {
 return degrees * PI / 180;
}

static inline void drawArc(CGContextRef ctx, CGPoint point, float angle_start, float angle_end, UIColor* color, float radius) {
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    CGContextAddArc(ctx, point.x, point.y, radius,  angle_start, angle_end, 0);
    CGContextFillPath(ctx);
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (_dataArray) {
        for (id view in self.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        float radius_start = 0.0;
        float radius_end = 0.0;
        for (PieCharModel *model in _dataArray) {
            radius_end = [model.percent floatValue] * 360.0;
            drawArc(ctx, self.center, radians(radius_start), radians(radius_start + radius_end), model.color, self.radius);
            CGContextSetLineWidth(ctx, 1.0f);
            [model.color set];
            // 起始
            CGPoint point1 = [self getPostionX:self.center.x withPostionY:self.center.y withRadius:_radius - 20 withCirAngle:(radius_start + radius_end / 2)];
            CGContextMoveToPoint(ctx, point1.x, point1.y);
            
            // 字符串长度
            NSString *labelTitle = model.title;
            NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0]};
            CGSize size = [labelTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
            if (size.width > CGRectGetWidth(self.frame) / 2 - _radius) {
                size.width = CGRectGetWidth(self.frame) / 2 - _radius - 10;
            }
            
            // 延伸
            CGPoint point2 = [self getPostionX:self.center.x withPostionY:self.center.y withRadius:_radius + 10 withCirAngle:(radius_start + radius_end / 2)];
            // 折线
            CGFloat line_x;
            CGFloat label_x;
            
            if (radius_start + radius_end / 2 < 90 || radius_start + radius_end / 2 > 270) { // 右边的线
                line_x = CGRectGetWidth(self.frame)  - size.width;
                label_x  = line_x + size.width / 2;
                if (point2.x + size.width > CGRectGetWidth(self.frame)) {
                    point2.x = CGRectGetWidth(self.frame) - size.width;
                }
            } else {
                line_x = size.width;
                label_x = size.width - size.width / 2;
                if (point2.x < size.width) {
                    point2.x = size.width;
                }
            }
            
            CGContextAddLineToPoint(ctx, point2.x, point2.y);
            CGContextAddLineToPoint(ctx, line_x, point2.y);
            
            // 显示框
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 20)];
            label.text = labelTitle;
            label.font = _textFont;
            label.textColor = _textColor;
            [self addSubview:label];
            label.center = CGPointMake(label_x, point2.y);
            
            CGContextStrokePath(ctx);
            radius_start += radius_end;
        }
    }
}

/**
 *  验证码请求字典
 *
 *  @param cirX 中心点x坐标
 *  @param cirY 中心点y坐标
 *  @param radiu 半径
 *  @param cirAngle 旋转角度
 *
 *  @return
 */
- (CGPoint)getPostionX:(CGFloat)cirX withPostionY:(CGFloat)cirY withRadius:(CGFloat)radiu withCirAngle:(CGFloat)cirAngle
{
    CGPoint point;
    CGFloat posX = 0.0;
    CGFloat posY = 0.0;
    CGFloat arcAngle = M_PI * cirAngle / 180.0;
    if (cirAngle < 90) {
        posX = cirX + cos(arcAngle) * radiu;
        posY = cirY + sin(arcAngle) * radiu;
    } else if (cirAngle == 90) {
        posX = cirX;
        posY = cirY + radiu;
    } else if (cirAngle > 90 && cirAngle < 180) {
        arcAngle = M_PI * (180 - cirAngle) / 180.0;
        posX = cirX - cos(arcAngle) * radiu;
        posY = cirY + sin(arcAngle) * radiu;
    } else if (cirAngle == 180) {
        posX = cirX - radiu;
        posY = cirY;
    } else if (cirAngle > 180 && cirAngle < 270) {
        arcAngle = M_PI * (cirAngle - 180) / 180.0;
        posX = cirX - cos(arcAngle) * radiu;
        posY = cirY - sin(arcAngle) * radiu;
    } else if (cirAngle == 270) {
        posX = cirX;
        posY = cirY - radiu;
    } else {
        arcAngle = M_PI * (360 - cirAngle) / 180.0;
        posX = cirX + cos(arcAngle) * radiu;
        posY = cirY - sin(arcAngle) * radiu;
    }
    point.x = posX;
    point.y = posY;
    return point;
}

@end

