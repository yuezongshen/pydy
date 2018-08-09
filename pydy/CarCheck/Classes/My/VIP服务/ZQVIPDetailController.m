//
//  ZQVIPDetailController.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/19.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQVIPDetailController.h"

@interface ZQVIPDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titleArray;
}
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation ZQVIPDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"权益详情";
    _titleArray = @[@{@"title":@"机动车年检",@"content":@"免费对上线机动车进行全方位检测维修（不含两客一危及校车），保证机动车上线检测顺利通过。",@"price":@"价值69元"},@{@"title":@"保险服务",@"content":@"在平台购买车险，价格最实惠。",@"price":@"价值70元"},@{@"title":@"代缴罚款",@"content":@"有效期内代缴违章处理罚款，免收服务费。",@"price":@"价值30元"},@{@"title":@"年检代办",@"content":@"6年内免检机动车代办年检，免收服务费。",@"price":@"价值30元"},@{@"title":@"法律援助",@"content":@"本平台提供权威的、专业的交通事故法律咨询，随时随地为您解答相关法律问题。",@"price":@"价值100元"},@{@"title":@"头等舱服务",@"content":@"享受工作人员全程微笑式一对一服务，提供精美午餐，提供安静优美的休息环境，享受头等舱式的贴心服务。",@"price":@"价值99元"},];
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, self.view.bounds.size.height ) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = HEXCOLOR(0xeeeeee);
        _tableView.estimatedSectionHeaderHeight = 10;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

#pragma mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return _titleArray.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id0"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell_id0"];
                    cell.textLabel.textColor = [UIColor darkTextColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:18];
//                    cell.detailTextLabel.textColor = [UIColor redColor];
//                    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
//                UIImageView *bView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 45)];
//                [bView setBackgroundColor:LH_RGBCOLOR(187,156,92)];
                cell.imageView.layer.cornerRadius = 6;
                cell.imageView.layer.masksToBounds = YES;
                [cell.imageView setImage:[self getImage:@"会员卡"]];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 26)];
                label.text = @"会员卡";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                [cell.imageView addSubview:label];

//                [cell.imageView setImage:[UIImage imageNamed:@"appIcon"]];
                cell.textLabel.text = @"尊享违章代办超值体验";
                [cell.detailTextLabel setText:@"￥99"];
                
//                NSString *tString = @"￥99  原价¥398";
//                NSRange range = [tString rangeOfString:@"￥99"];
//                NSRange yRange = [tString rangeOfString:@"原价¥398"];
//                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:tString];
//                [attr addAttribute:NSFontAttributeName value:MFont(18) range:range];
//                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//
//                [attr addAttribute:NSFontAttributeName value:MFont(14) range:yRange];
//                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:yRange];
//                [attr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:yRange];
                
                NSString *tString = [NSString stringWithFormat:@"￥%@  原价¥%@",self.vipModel.current_price,self.vipModel.original_price];
                NSRange range = [tString rangeOfString:[NSString stringWithFormat:@"￥%@",self.vipModel.current_price]];
                NSRange yRange = [tString rangeOfString:[NSString stringWithFormat:@"¥%@",self.vipModel.original_price]];
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:tString];
                [attr addAttribute:NSFontAttributeName value:MFont(18) range:range];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
                
                [attr addAttribute:NSFontAttributeName value:MFont(14) range:yRange];
                [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:yRange];
                [attr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:yRange];

                cell.detailTextLabel.attributedText = attr;
            }
            break;
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id1"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell_id1"];
                cell.textLabel.textColor = [UIColor darkTextColor];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.numberOfLines = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(tableView.frame)-110, 5, 100, 20)];
                priceL.font = [UIFont systemFontOfSize:13];
                priceL.textColor = [UIColor brownColor];
                priceL.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:priceL];
                priceL.tag = 11111;
            }
            [cell.imageView setImage:[UIImage imageNamed:@"myMoney"]];
            NSDictionary *dic = _titleArray[indexPath.row];
            cell.textLabel.text = dic[@"title"];
            [cell.detailTextLabel setText:dic[@"content"]];
            UILabel *priceL = [cell.contentView viewWithTag:11111];
            [priceL setText:dic[@"price"]];
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id2"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell_id2"];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.numberOfLines = 0;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"1、适用范围：所有机动车（两客一危及校车除外）\n2、适用地区：河北省\n3、有效期限：成功办理起一年内。";
        }
            break;
        default:
            break;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50)];
        view.backgroundColor = LH_RGBCOLOR(241,239,235);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(tableView.frame), 40)];
        label.backgroundColor = [UIColor whiteColor];
        if (section==1) {
            [label setText:@"      权益明细"];
        }
        else
        {
            [label setText:@"      使用说明"];
        }
        [label setFont:[UIFont systemFontOfSize:12]];
        [view addSubview:label];
        return view;
    }
    return nil;
}
// 样式
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 50;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIImage *)getImage:(NSString *)name
{
    UIColor *color = LH_RGBCOLOR(220,195,129);
    CGRect rect = CGRectMake(0.0f, 0.0f, 80, 46);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    NSString *headerName = nil;
//    if (name.length < 3) {
//        headerName = name;
//    }else{
//        headerName = [name substringFromIndex:name.length-2];
//    }
//    UIImage *headerimg = [self imageToAddText:img withText:headerName];
//     UIImage *headerimg = [self imageToAddText:img withText:name];
//    return headerimg;
    return img;
}

//把文字绘制到图片上
- (UIImage *)imageToAddText:(UIImage *)img withText:(NSString *)text
{
    //1.获取上下文
    UIGraphicsBeginImageContext(img.size);
    //2.绘制图片
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //3.绘制文字
//    CGRect rect = CGRectMake(0,(img.size.height-45)/2, img.size.width, 25);
    CGRect rect = CGRectMake(12,13, 56, 20);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //文字的属性
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeWidthAttributeName:@(-4)};
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];

    //4.获取绘制到得图片
    UIImage *watermarkImg = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    
    return watermarkImg;
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
