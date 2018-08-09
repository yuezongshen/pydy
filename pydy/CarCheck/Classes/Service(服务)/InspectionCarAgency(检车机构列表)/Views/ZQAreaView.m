//
//  ZQAreaView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQAreaView.h"

@interface ZQAreaView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *listArr;
@property (strong, nonatomic) ZQAreaModel *selectedModel;

@property (strong,nonatomic) UIPickerView *areaPickerV;
@end

@implementation ZQAreaView

- (instancetype)initWithFrame:(CGRect)frame provinceId:(NSString *)pId{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor=HEXCOLOR(0xffffff);
        self.backgroundColor = LH_RGBCOLOR(209,212,221);

        [self initView];
        if (pId.integerValue == -1) {
            
            NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
            for (NSString *str in [Utility getProvinceShortNum]) {
                ZQAreaModel *model = [[ZQAreaModel alloc] init];
                model.areaName = str;
                model.areaId = @"-1";
                [muArr addObject:model];
            }
            self.listArr = muArr;
            self.selectedModel = self.listArr.firstObject;
            [_areaPickerV reloadAllComponents];
        }
        else if (pId.integerValue == -2)
        {
            NSArray *array = @[@"男",@"女",@"保密"];
            NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
            for (NSString *str in array) {
                ZQAreaModel *model = [[ZQAreaModel alloc] init];
                model.areaName = str;
                model.areaId = @"-2";
                [muArr addObject:model];
            }
            self.listArr = muArr;
            self.selectedModel = self.listArr.firstObject;
            [_areaPickerV reloadAllComponents];
        }
        else
        {
            [self getProvinceDataFromLocalWithProvinceId:pId];
        }
//        self.layer.masksToBounds = YES;
//        CALayer *capa = self.layer;
//        [capa setShadowColor: [[UIColor blackColor] CGColor]];
//        [capa setShadowOpacity:0.85f];
//        [capa setShadowOffset: CGSizeMake(0.0f, 2.5f)];
//        [capa setShadowRadius:2.0f];
//        [capa setShouldRasterize:YES];
//        
//        
//        //Round
//        CGRect bounds = CGRectMake(0, -100, 450, 520);
//        bounds.size.height += 20.0f;    //I'm reserving enough room for the shadow
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
//                                                      byRoundingCorners: (UIRectCornerBottomLeft | UIRectCornerBottomRight)
//                                                            cornerRadii:CGSizeMake(8.0, 8.0)];
//        
//        CAShapeLayer *maskLayer = [CAShapeLayer layer];
//        maskLayer.frame = bounds;
//        maskLayer.path = maskPath.CGPath;
//        
//        [capa addSublayer:maskLayer];
//        capa.mask = maskLayer;
    }
    return self;
}
- (void)initView{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 40)];
    [self addSubview:headV];
    headV.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 1)];
    lineView.backgroundColor = __DefaultColor;
    
    [headV addSubview:lineView];
    
//    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 40, 40)];
//    headV.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    [headV addSubview:cancelBtn];
    cancelBtn.titleLabel.font = MFont(15);
    cancelBtn.backgroundColor =[UIColor clearColor];
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
    [cancelBtn setTitleColor:LH_RGBCOLOR(0, 122, 255) forState:BtnNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:BtnTouchUpInside];
    
//    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-60, 0, 40, 40)];
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-50, 0, 40, 40)];
    [headV addSubview:sureBtn];
    sureBtn.titleLabel.font = MFont(15);
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn setTitle:@"确定" forState:BtnNormal];
    [sureBtn setTitleColor:LH_RGBCOLOR(0, 122, 255) forState:BtnNormal];
    sureBtn.layer.cornerRadius = 4;
    //    [sureBtn addTarget:self action:@selector(aaaaaa) forControlEvents:BtnTouchUpInside];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:BtnTouchUpInside];
    
    
    _areaPickerV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, __kWidth, self.frame.size.height-40)];
    _areaPickerV.delegate =self;
    _areaPickerV.dataSource =self;
    [self addSubview:_areaPickerV];
}
- (void)getProvinceDataFromLocalWithProvinceId:(NSString *)pId
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"YPAddress" ofType:@"plist"];
    NSArray *localArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *listArr = [NSMutableArray arrayWithCapacity:0];
    if (pId) {
        for (NSDictionary *dic in localArr) {
            NSString *key1 = [NSString stringWithFormat:@"%@",dic[@"province_id"]];
            if (key1.integerValue==pId.integerValue) {
                for (NSDictionary *dic1 in dic[key1]) {
                    NSString *key2 = [NSString stringWithFormat:@"%@",dic1[@"city_id"]];
                    ZQAreaModel *cityModel = [[ZQAreaModel alloc]init];
                    cityModel.areaName = dic1[@"city_name"];
                    cityModel.areaId = key2;
                    [listArr addObject:cityModel];
                }
                break;
            }
        }
    }
    else
    {
        for (NSDictionary *dic in localArr) {
            ZQAreaModel *addressModel = [[ZQAreaModel alloc]init];
            addressModel.areaName = dic[@"province_name"];
            addressModel.areaId = dic[@"province_id"];
            [listArr addObject:addressModel];
        }
    }
    self.listArr = listArr;
    [_areaPickerV reloadAllComponents];
    self.selectedModel = self.listArr.firstObject;
}

- (void)sureAction{
    if (self.handler) {
        self.handler(self.selectedModel);
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}
- (void)cancelAction{
    if (self.handler) {
        self.handler(nil);
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}
#pragma mark -UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _listArr.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = (UILabel*)view;
    if (!label)
    {
        label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:14]];
    }
    label.textAlignment = NSTextAlignmentCenter;
    ZQAreaModel *model = self.listArr[row];
    label.text = model.areaName;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    ZQAreaModel *model = self.listArr[row];
    self.selectedModel = model;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
