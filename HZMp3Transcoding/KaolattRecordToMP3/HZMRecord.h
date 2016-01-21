//
//  HZMRecord.h
//  HZMp3Transcoding
//
//  Created by 郝泽明 on 16/1/21.
//  Copyright © 2016年 Vega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "HZMEncode.h"

/*队列缓冲个数*/
#define MP3_QUEUE_BUFFER_SIZE 3
/*每次从文件读取的长度 8000是40毫秒----1152是MP3一帧大小*/
#define MP3_EVERY_READ_LENGTH 1152
/*每侦最小数据长度*/
#define MP3_MIN_SIZE_PER_FRAME 1152

@interface HZMRecord : NSObject
{
/*音频参数*/
    AudioStreamBasicDescription _audioDescription;
/*音频队列:控制器*/
    AudioQueueRef _audioQueue;
/*音频缓存：控制器*/
    AudioQueueBufferRef _audioQueueBuffers[MP3_QUEUE_BUFFER_SIZE];
/*流媒体控制器*/
    AVAudioSession *_audioSession;
/*录音时间*/
    NSTimer *_recordTimer;
    NSInteger _recordTime;
}

/*转码类*/
@property (nonatomic, strong) HZMEncode *encode;
/*文件写入标示*/
@property (nonatomic, strong) dispatch_queue_t writeFileQueue;
@property (nonatomic, strong) dispatch_semaphore_t semError;
/*录音完成回调*/
@property (nonatomic, copy) void (^RecordeFinishedBlock)(NSString *filePath);
/*录音时间回调*/
@property (nonatomic, copy) void (^RecordeTimeBlock)(NSString *recordeTime);

/* !
 * @method 初始化
 * @abstract
 * @discussion
 * @param
 * @result
 */
+(instancetype)sharedManager;

/* !
 * @method 开始录音
 * @abstract
 * @discussion
 * @param
 * @result
 */
-(void)startRecord;

/* !
 * @method 结束录音
 * @abstract
 * @discussion
 * @param
 * @result
 */
-(void)endRecord;

@end
