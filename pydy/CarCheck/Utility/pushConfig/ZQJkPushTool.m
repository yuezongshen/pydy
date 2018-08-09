//
//  ZQJkPushTool.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/13.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQJkPushTool.h"

static ZQJkPushTool *_sharedInstance;//震动对象全局变量
static ZQJkPushTool *_sharedInstanceForSound;//声音对象全局变量

@implementation ZQJkPushTool

+(id)sharedInstanceForVibrate{
    if (_sharedInstance==nil) {
        _sharedInstance = [[ZQJkPushTool alloc]initForPlayingShake];
    }
    return _sharedInstance;
}

+(id)sharedInstanceForSound{
    if (_sharedInstanceForSound == nil) {
        _sharedInstanceForSound = [[ZQJkPushTool alloc]initForPlayingSound:@"sound.caf"];
    }
    return _sharedInstanceForSound;
}



-(id)initForPlayingShake{
    if (self = [super init]) {
        soundID = kSystemSoundID_Vibrate;
    }
    return self;
}


-(id)initForPlayingSound:(NSString *)fileName{
    if (self = [super init]) {
        NSURL *fileURL = [[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
        if (fileURL!=nil) {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            }else{
                NSLog(@"Failed to create sound");
            }
        }
    }
    return self;
}
/**播放声音*/
- (void)zQPlayRemind
{
  AudioServicesPlaySystemSound(soundID);
}
-(void)zQPlay{
    AudioServicesPlaySystemSound(soundID);
}

-(void)dealloc{
    AudioServicesDisposeSystemSoundID(soundID);
}

@end
