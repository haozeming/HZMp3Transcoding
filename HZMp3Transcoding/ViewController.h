//
//  ViewController.h
//  HZMp3Transcoding
//
//  Created by 郝泽明 on 16/1/20.
//  Copyright © 2016年 Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate>
{
    NSString *_mp3FilePath;
}

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioSession *kaolattSession;

@end

