//
//  ZQPersonModel.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/10/8.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQPersonModel : NSObject

/**头像*/
@property (strong,nonatomic) NSString *imageName;
/**用户名*/
@property (strong,nonatomic) NSString *name;
/**昵称*/
@property (strong,nonatomic) NSString *nickName;
/**邮箱*/
@property (strong,nonatomic) NSString *email;
/**性别*/
@property (strong,nonatomic) NSString *sex;
/**联系电话*/
@property (strong,nonatomic) NSString *phone;
/**生日*/
@property (strong,nonatomic) NSString *birth;
/**职位*/
@property (strong,nonatomic) NSString *job;

@property (strong,nonatomic) NSString *userid;
@end
