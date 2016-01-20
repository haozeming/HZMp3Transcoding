//
//  KaolattAQRecord.m
//  RecordTest
//
//  Created by 郝泽明 on 14/10/21.
//  Copyright (c) 2014年 车语传媒. All rights reserved.
//

#import "KaolattAQRecord.h"
@implementation KaolattAQRecord
#pragma mark--
#pragma mark-- 初始化
-(id)init
{
    self = [super init];
    if(self) {
        self.kaolattEncodeToMP3 = [[KaolattEncodeToMP3 alloc] init];
        self.writeFileQueue = dispatch_queue_create("AudioRecorder.writeFileQueue", NULL);
        recordTime = 0;
    }
    
    return self;
}
#pragma mark--
#pragma mark-- 开始录音
-(void)startRecord
{
    self.kaolattSession = [AVAudioSession sharedInstance];
    NSError *kaolattSessionError;
    [self.kaolattSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&kaolattSessionError];
    if (self.kaolattSession == nil) {
        NSLog(@"%@",[kaolattSessionError description]);
    }
    else {
        [self.kaolattSession setActive:YES error:&kaolattSessionError];
    }
    [self settingBaseForamt];
    AudioQueueStart(kaolattAudioQueue, NULL);
/*录音时间*/
    recordTime = 0;
    self.kaolattTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(recordeTime) userInfo:nil repeats:YES];
}
#pragma mark--
#pragma mark-- 结束录音
-(void)endRecord
{
    AudioQueueStop(kaolattAudioQueue, true);
    AudioQueueDispose(kaolattAudioQueue, true);
    NSError *kaolattSessionError;
    [self.kaolattSession setActive:NO error:&kaolattSessionError];
    [self.kaolattTimer invalidate];
    if (self.recordeFinishedBlock) {
        self.recordeFinishedBlock(self.kaolattEncodeToMP3.kaolattMP3FilePath);
    }
}
#pragma mark--
#pragma mark-- 录音回调
void AduioRecordAQInputCallBack(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription *inPacketDescs)
{
    KaolattAQRecord *kaolattAQRecord = (__bridge KaolattAQRecord *)inUserData;
    if (inNumberPacketDescriptions > 0) {
        NSData *pcmData = [[NSData alloc] initWithBytes:inBuffer->mAudioData length:inBuffer->mAudioDataByteSize];
        if (pcmData && pcmData.length > 0) {
            dispatch_async(kaolattAQRecord.writeFileQueue, ^{
                [kaolattAQRecord.kaolattEncodeToMP3 encodeToMP3With:pcmData];
            });
        }
    }
/*回调执行*/
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}
#pragma mark--
#pragma mark-- 设置音频格式
-(void)settingBaseForamt
{
/*采样率*/
    kaolattAudioDescription.mSampleRate = 44100;
/*编码格式*/
    kaolattAudioDescription.mFormatID = kAudioFormatLinearPCM;
    kaolattAudioDescription.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger |kLinearPCMFormatFlagIsPacked;
/*每一个packet一帧数据*/
    kaolattAudioDescription.mFramesPerPacket = 1;
/*双声道*/
    kaolattAudioDescription.mChannelsPerFrame = 2;
    kaolattAudioDescription.mBitsPerChannel = 16;
    kaolattAudioDescription.mBytesPerFrame = (kaolattAudioDescription.mBitsPerChannel/8) * kaolattAudioDescription.mChannelsPerFrame;
    kaolattAudioDescription.mBytesPerPacket = kaolattAudioDescription.mBytesPerFrame;
/*音频出入通道*/
    AudioQueueNewInput(&kaolattAudioDescription, AduioRecordAQInputCallBack, (__bridge void *)(self), NULL, kCFRunLoopCommonModes,0, &kaolattAudioQueue);
    for (int i = 0;i < MP3_QUEUE_BUFFER_SIZE;i++) {
        AudioQueueAllocateBuffer(kaolattAudioQueue, MP3_MIN_SIZE_PER_FRAME, &kaolattAudioQueueBuffers[i]);
        AudioQueueEnqueueBuffer(kaolattAudioQueue, kaolattAudioQueueBuffers[i], 0, NULL);
    }
}
#pragma mark--
#pragma mark-- 录音时间
-(void)recordeTime
{
    int minutes = recordTime / 60;
    int seconds = recordTime % 60;
    recordTime ++;
    NSString *minutesStr;
    NSString *secondsStr;
/*时间－－限定2分钟*/
    if (minutes < 10) {
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    }
    else {
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    }
    if (seconds < 10) {
        secondsStr = [NSString stringWithFormat:@"0%d",seconds];
    }
    else {
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    }
    NSString *recordeTime = [NSString stringWithFormat:@"%@:%@",minutesStr,secondsStr];
    if (self.recordeTimeBlock) {
        self.recordeTimeBlock(recordeTime);
    }
}
@end
