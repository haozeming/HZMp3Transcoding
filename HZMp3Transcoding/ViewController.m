//
//  ViewController.m
//  HZMp3Transcoding
//
//  Created by 郝泽明 on 16/1/20.
//  Copyright © 2016年 Vega. All rights reserved.
//

#import "ViewController.h"
#import "HZMAQRecord.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
/*开始录音*/
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(100, 100, 100, 60);
    [startBtn setTitle:@"开始录音" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startMethod:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:startBtn];
    
/*结束录音*/
    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endBtn.frame = CGRectMake(100, 300, 100, 60);
    [endBtn setTitle:@"结束录音" forState:UIControlStateNormal];
    [endBtn addTarget:self action:@selector(endMethod:) forControlEvents:UIControlEventTouchUpInside];
    endBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:endBtn];
    
    
/*预听录音*/
    UIButton *listenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listenBtn.frame = CGRectMake(100, 500, 100, 60);
    [listenBtn setTitle:@"预听录音" forState:UIControlStateNormal];
    [listenBtn addTarget:self action:@selector(listenethod:) forControlEvents:UIControlEventTouchUpInside];
    listenBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:listenBtn];

}

#pragma mark--
#pragma mark-- 开始录音
-(void)startMethod:(UIButton *)sender {
    [[HZMAQRecord sharedManager] startRecord];
    [HZMAQRecord sharedManager].RecordeFinishedBlock = ^(NSString *filePath) {
        _mp3FilePath = filePath;
    };
}

#pragma mark--
#pragma mark-- 结束录音
-(void)endMethod:(UIButton *)sender {
    [[HZMAQRecord sharedManager] endRecord];
}

#pragma mark--
#pragma mark-- 预听录音
-(void)listenethod:(UIButton *)sender {
    //静音状态下播放
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    //后台播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //远程控制：打完电话继续播放
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    NSError *playerError;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_mp3FilePath] error:&playerError];
    self.player.delegate = self;
    self.player.volume = 1;
    [self.player prepareToPlay];
    self.player.meteringEnabled = YES;
    [self.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
