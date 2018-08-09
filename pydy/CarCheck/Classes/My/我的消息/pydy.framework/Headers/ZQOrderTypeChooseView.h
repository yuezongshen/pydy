


#import <UIKit/UIKit.h>

@interface ZQOrderTypeChooseView : UIView

@property (nonatomic,copy) void(^chooseOrderType)(NSInteger);
- (void)configViewWithArray:(NSArray *)titles andType:(NSInteger)aType;
//- (void)jumpToFirstBtnWith:(NSInteger)tag;
@end
