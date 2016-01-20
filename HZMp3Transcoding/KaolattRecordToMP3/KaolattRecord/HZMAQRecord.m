//
//  KaolattAQRecord.m
//  RecordTest
//
//  Created by 郝泽明 on 14/10/21.
//  Copyright (c) 2014年 车语传媒. All rights reserved.
//

#import "HZMAQRecord.h"
@implementation HZMAQRecord

#pragma mark--
#pragma mark-- 初始化
+(instancetype)sharedManager {
    static HZMAQRecord *_aQRecord = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _aQRecord = [[HZMAQRecord alloc] init];
    });
    return _aQRecord;
}

#pragma mark--
#pragma mark-- 开始录音
-(void)startRecord {
    _encodeToMP3 = [[HZMEncodeToMP3 alloc] init];
    _writeFileQueue = dispatch_queue_create("AudioRecorder.writeFileQueue", NULL);
    _recordTime = 0;

    _audioSession = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (_audioSession == nil) {
        NSLog(@"%@",[sessionError description]);
    }
    else {
        [_audioSession setActive:YES error:&sessionError];
    }
    [self settingBaseForamt];
    AudioQueueStart(_audioQueue, NULL);
/*录音时间*/
    _recordTime = 0;
    _recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(recordeTime) userInfo:nil repeats:YES];
}

#pragma mark--
#pragma mark-- 结束录音
-(void)endRecord {
    AudioQueueStop(_audioQueue, true);
    AudioQueueDispose(_audioQueue, true);
    NSError *sessionError;
    [_audioSession setActive:NO error:&sessionError];
    [_recordTimer invalidate];
    if (self.RecordeFinishedBlock) {
        self.RecordeFinishedBlock(_encodeToMP3.mp3FilePath);
    }
}

#pragma mark--
#pragma mark-- 录音回调
void AduioRecordAQInputCallBack(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription *inPacketDescs) {
    HZMAQRecord *aQRecord = (__bridge HZMAQRecord *)inUserData;
    if (inNumberPacketDescriptions > 0) {
        NSData *pcmData = [[NSData alloc] initWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
        if (pcmData && pcmData.length > 0) {
            dispatch_async(aQRecord.writeFileQueue, ^{
                [aQRecord.encodeToMP3 encodeToMP3With:pcmData];
            });
        }
    }
/*回调执行*/
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

#pragma mark--
#pragma mark-- 设置音频格式
-(void)settingBaseForamt {
/*采样率*/
    _audioDescription.mSampleRate = 44100;
/*编码格式*/
    _audioDescription.mFormatID = kAudioFormatLinearPCM;
    _audioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger |kLinearPCMFormatFlagIsPacked;
/*每一个packet一帧数据*/
    _audioDescription.mFramesPerPacket = 1;
/*双声道*/
    _audioDescription.mChannelsPerFrame = 2;
    _audioDescription.mBitsPerChannel = 16;
    _audioDescription.mBytesPerFrame = (_audioDescription.mBitsPerChannel/8) * _audioDescription.mChannelsPerFrame;
    _audioDescription.mBytesPerPacket = _audioDescription.mBytesPerFrame;
/*音频出入通道*/
    AudioQueueNewInput(&_audioDescription, AduioRecordAQInputCallBack, (__bridge void *)(self), NULL, kCFRunLoopCommonModes,0, &_audioQueue);
    for (int i = 0;i < MP3_QUEUE_BUFFER_SIZE;i++) {
        AudioQueueAllocateBuffer(_audioQueue, MP3_MIN_SIZE_PER_FRAME, &_audioQueueBuffers[i]);
        AudioQueueEnqueueBuffer(_audioQueue, _audioQueueBuffers[i], 0, NULL);
    }
}

#pragma mark--
#pragma mark-- 录音时间
-(void)recordeTime {
    NSInteger minutes = _recordTime / 60;
    NSInteger seconds = _recordTime % 60;
    _recordTime ++;
    NSString *minutesStr;
    NSString *secondsStr;
/*时间－－限定2分钟*/
    if (minutes < 10) {
        minutesStr = [NSString stringWithFormat:@"0%ld",(long)minutes];
    }
    else {
        minutesStr = [NSString stringWithFormat:@"%ld",(long)minutes];
    }
    if (seconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%ld",(long)seconds];
    }
    else {
        secondsStr = [NSString stringWithFormat:@"%ld",(long)seconds];
    }
    NSString *recordeTime = [NSString stringWithFormat:@"%@:%@",minutesStr,secondsStr];
    if (self.RecordeTimeBlock) {
        self.RecordeTimeBlock(recordeTime);
    }
}
@end
