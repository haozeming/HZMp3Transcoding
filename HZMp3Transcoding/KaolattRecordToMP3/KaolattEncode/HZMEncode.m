//
//  HZMEncode.m
//  HZMp3Transcoding
//
//  Created by 郝泽明 on 16/1/21.
//  Copyright © 2016年 Vega. All rights reserved.
//

#import "HZMEncode.h"

@implementation HZMEncode

#pragma mark--
#pragma mark-- 初始化
-(instancetype)init {
    self = [super init];
    if (self) {
        [self settingEncodeFormat];
        [self settingEncodeFile];
    }
    return self;
}

#pragma mark--
#pragma mark-- 设置编码格式
-(void)settingEncodeFormat {
    lame = lame_init();
    lame_set_num_channels(lame, 2);
    lame_set_brate(lame, 128 * 1024);
    lame_set_in_samplerate(lame, 44100);
    lame_set_VBR(lame, vbr_default);
    lame_init_params(lame);
}

#pragma mark--
#pragma mark-- 设置转码文件
-(void)settingEncodeFile {
    NSString *mp3FileName = @"MP3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    self.mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    mp3File = fopen([self.mp3FilePath cStringUsingEncoding:1], "wb");
}

#pragma mark--
#pragma mark-- 转码－MP3
-(void)encodeToMP3With:(NSData *)originalData {
/*录音数据*/
    short *encodeData = (short *)originalData.bytes;
/*录音长度*/
    int encodeDataLen = (int)originalData.length;
/*每个声道的字节数－－－双声道（2）＋字节（2）*/
    int nsamples = encodeDataLen / 4;
/*设置buffer*/
    unsigned char buffer[encodeDataLen];
/*编码－－－交叉编码（双声道）*/
    int recvlen = lame_encode_buffer_interleaved(lame, encodeData, nsamples, buffer, encodeDataLen);
/*写入文件*/
    fwrite(buffer, recvlen, 1, mp3File);
}

@end
