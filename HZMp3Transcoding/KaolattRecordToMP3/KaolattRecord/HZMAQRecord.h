//
//  KaolattAQRecord.h
//  RecordTest
//
//  Created by 郝泽明 on 14/10/21.
//  Copyright (c) 2014年 车语传媒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "KaolattEncodeToMP3.h"

/*队列缓冲个数*/
#define MP3_QUEUE_BUFFER_SIZE 3
/*每次从文件读取的长度 8000是40毫秒----1152是MP3一帧大小*/
#define MP3_EVERY_READ_LENGTH 1152
/*每侦最小数据长度*/
#define MP3_MIN_SIZE_PER_FRAME 1152

/*录音完成回调*/
typedef void (^RecordeFinishedBlock)(NSString *filePath);
/*录音时间回调*/
typedef void (^RecordeTimeBlock)(NSString *recordeTime);

@interface KaolattAQRecord : NSObject
{
/*音频参数*/
    AudioStreamBasicDescription kaolattAudioDescription;
/*音频队列:控制器*/
    AudioQueueRef kaolattAudioQueue;
/*音频缓存：控制器*/
    AudioQueueBufferRef kaolattAudioQueueBuffers[MP3_QUEUE_BUFFER_SIZE];
/*流媒体控制器*/
    AVAudioSession *_kaolattSession;
/*转码类*/
    KaolattEncodeToMP3 *_kaolattEncodeToMP3;
/*录音时间*/
    NSTimer *_kaolattTimer;
    NSInteger recordTime;
}
@property (nonatomic, strong) AVAudioSession *kaolattSession;
@property (nonatomic, strong) KaolattEncodeToMP3 *kaolattEncodeToMP3;
/*文件写入标示*/
@property (nonatomic, assign) dispatch_queue_t writeFileQueue;
@property (nonatomic, assign) dispatch_semaphore_t semError;
@property (nonatomic, copy) RecordeFinishedBlock recordeFinishedBlock;
@property (nonatomic, copy) RecordeTimeBlock recordeTimeBlock;
@property (nonatomic, strong) NSTimer *kaolattTimer;

/* !
 * @method 初始化
 * @abstract
 * @discussion
 * @param
 * @result
 */
-(id)init;

/* !
 * @method 录音回调
 * @abstract
 * @discussion
 * @param
 * @result
 */
void AduioRecordAQInputCallBack(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription *inPacketDescs);

/* !
 * @method 设置录音格式
 * @abstract
 * @discussion
 * @param
 * @result
 */
-(void)settingBaseForamt;

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
