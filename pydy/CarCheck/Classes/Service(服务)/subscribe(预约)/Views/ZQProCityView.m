//
//  ZQProCityView.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/12/20.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQProCityView.h"
#import "ZQAreaModel.h"

@interface ZQProCityView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *listArr;
@property (strong, nonatomic) NSArray *cityArr;
//@property (strong, nonatomic) ZQAreaModel *selectedModel;
@property (copy, nonatomic) NSString *proStr;
@property (copy, nonatomic) NSString *cityStr;


@property (strong,nonatomic) UIPickerView *areaPickerV;
@end

@implementation ZQProCityView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //        self.backgroundColor=HEXCOLOR(0xffffff);
        self.backgroundColor = LH_RGBCOLOR(209,212,221);
        
        [self getProvinceData];
        
        [self initView];

    }
    return self;
}
- (void)getProvinceData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"YPAddress" ofType:@"plist"];
    NSArray *localArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *listArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in localArr) {
        ZQAreaModel *addressModel = [[ZQAreaModel alloc]init];
        addressModel.areaName = dic[@"province_name"];
        addressModel.areaId = dic[@"province_id"];
        [listArr addObject:addressModel];
    }
    self.listArr = listArr;
    [_areaPickerV reloadAllComponents];
    ZQAreaModel *aModel = self.listArr.firstObject;
    self.proStr = aModel.areaName;
    [self getdataWithProvinceId:aModel.areaId];
//    self.selectedModel = self.listArr.firstObject;
}

- (void)getdataWithProvinceId:(NSString *)pId{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"YPAddress" ofType:@"plist"];
    NSArray *localArr = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *listArr = [NSMutableArray arrayWithCapacity:0];
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
            self.cityArr = listArr;
            ZQAreaModel *aModel = self.cityArr.firstObject;
            self.cityStr = aModel.areaName;
            break;
        }
    }
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
//    self.pickerDic = [[NSDictionary alloc]initWithContentsOfFile:path];
//    self.provinceArr = [self.pickerDic allKeys];
//    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
//    if (self.selectedArray.count>0) {
//        self.cityArr = [[self.selectedArray objectAtIndex:0]allKeys];
//    }
//    if (self.cityArr.count>0) {
//        self.townArr = [[self.selectedArray objectAtIndex:0]allKeys];
//    }
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

- (void)sureAction{
    if (self.handler) {
        self.handler([NSString stringWithFormat:@"%@ %@",self.proStr,self.cityStr]);
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
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component) {
        return _cityArr.count;
    }
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
    ZQAreaModel *model = nil;
    if (component) {
      model = self.cityArr[row];
    }
     else
      {
    model = self.listArr[row];
      }
    label.text = model.areaName;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component) {
        ZQAreaModel *model = self.cityArr[row];
        self.cityStr = model.areaName;
    }
    else
    {
        ZQAreaModel *model = self.listArr[row];
        [self getdataWithProvinceId:model.areaId];
        [pickerView reloadComponent:1];

        self.proStr = model.areaName;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
