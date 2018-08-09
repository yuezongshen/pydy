//
//  ZQProCityPickerV.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/4.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQProCityPickerV.h"
#import "ZQProvinceModel.h"
#import "ZQCityModel.h"

@interface ZQProCityPickerV()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
    ZQProvinceBlock _myBlock;
    NSInteger _index;
}

@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) NSArray *list0Array;
@property (strong, nonatomic) NSArray *list1Array;
@end
@implementation ZQProCityPickerV

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
    }
    return self;
}

-(void)initViews {
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 1)];
    lineView.backgroundColor = __DefaultColor;
    
    [self addSubview:lineView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 50, 20)];
    [self addSubview:cancelBtn];
    cancelBtn.titleLabel.font = MFont(15);
    [cancelBtn setTitle:@"取消" forState:BtnNormal];
    [cancelBtn setTitleColor:LH_RGBCOLOR(0, 122, 255) forState:BtnNormal];
    [cancelBtn addTarget:self action:@selector(chooseCanel) forControlEvents:BtnTouchUpInside];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-50, 5, 50, 20)];
    [self addSubview:sureBtn];
    sureBtn.titleLabel.font = MFont(15);
    [sureBtn setTitle:@"确定" forState:BtnNormal];
    [sureBtn setTitleColor:LH_RGBCOLOR(0, 122, 255) forState:BtnNormal];
    [sureBtn addTarget:self action:@selector(chooseSure) forControlEvents:BtnTouchUpInside];
    
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, __kWidth, self.frame.size.height-25)];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    [self addSubview:self.pickView];
}

-(void)showWithProvinceArray:(NSArray *)dataArray inView:(UIView *)view chooseBackBlock:(ZQProvinceBlock)block {
    _index = 0;
    self.list0Array = dataArray;
    ZQProvinceModel *model = dataArray[0];
    self.list1Array = model.citys;
    [self.pickView reloadAllComponents];
    _myBlock = block;
    [view addSubview:self];
}
#pragma mark UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    if (component) {
        ZQCityModel *cityModel = self.list1Array[row];
        return cityModel.city_name;
    }
    ZQProvinceModel *model = self.list0Array[row];
    return model.province;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component) {
        return self.list1Array.count;
    }
    else
    return self.list0Array.count;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"-------%ld",(long)row);
    if (component) {
        _index = row;
    }
    else
    {
        ZQProvinceModel *model = self.list0Array[row];
        self.list1Array = model.citys;
        [pickerView reloadComponent:1];
    }
}

#pragma mark ==取消==
-(void)chooseCanel{
    _myBlock(nil);
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}
#pragma mark ==确认==
-(void)chooseSure{
    _myBlock(self.list1Array[_index]);
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
