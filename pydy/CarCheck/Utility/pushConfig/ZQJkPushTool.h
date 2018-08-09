//
//  ZQJkPushTool.h
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/13.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ZQJkPushTool : NSObject
{
    SystemSoundID soundID;
}
+ (id) sharedInstanceForVibrate;
+ (id) sharedInstanceForSound;

/**震动初始化*/
- (id)initForPlayingShake;
/**铃声初始化*/
- (id)initForPlayingSound:(NSString*)fileName;
/**播放*/
- (void)zQPlay;
/**播放声音*/
- (void)zQPlayRemind;
@end
