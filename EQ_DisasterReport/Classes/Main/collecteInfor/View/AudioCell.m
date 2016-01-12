//
//  AudioCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/11.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AudioCell.h"
#import "VoiceTableHelper.h"
@implementation AudioCell

- (void)awakeFromNib {
    // Initialization code    
    [self.recordBtn initRecord:self maxtime:60 title:@"上滑取消录音"];
    [self.recordBtn setTitle:@"语音上报" forState: UIControlStateNormal];
    [self.recordBtn setImage:[UIImage imageNamed:@"microphone_icon"] forState:UIControlStateNormal];
    
    self.resetBtn.layer.cornerRadius = 4;
    self.resetBtn.layer.masksToBounds = YES;
    
    self.recordBtn.layer.cornerRadius = 8;
    self.recordBtn.layer.masksToBounds = YES;
    
    [self setBtnState:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAudioData:(NSData *)audioData
{
    _audioData = audioData;
    
    if (audioData) {
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc]initWithData:self.audioData error:&error];
        self.audioPlayer.delegate = self;
        self.audioPlayer.volume = 1.0f;
        self.imageIndex = 2;
        self.remainTime = self.audioPlayer.duration;
        self.audioDuration.text = [NSString stringWithFormat:@"%.1f秒",self.remainTime];
        self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"fs_icon_wave_%d",(int)self.imageIndex%3]];
        NSLog(@"音频错误%@",error);
        
        [self setBtnState:YES];
    }else{
        [self setBtnState:NO];
    }
}

-(void)endRecord:(NSData *)voiceData{
    
    self.audioData = voiceData;

   if ([self.delegate respondsToSelector:@selector(audioCell:finishRecod:)]) {
        [self.delegate audioCell:self finishRecod:voiceData];
    }
    [self.recordBtn setTitle:@"长按录音" forState:UIControlStateNormal];
}

-(void)dragExit{
    [self.recordBtn setTitle:@"按住录音" forState:UIControlStateNormal];
}

-(void)dragEnter{
    [self.recordBtn setTitle:@"松开发送" forState:UIControlStateNormal];
}

- (IBAction)playAudio:(id)sender {
    // 如果当前正在播放
    if (self.audioPlayer&& self.audioPlayer.playing){
        // 暂停播放
        [self.audioPlayer pause];
        [self removeTimer];
    }else if(self.audioPlayer && !self.audioPlayer.playing ){
        // 播放音频
        [self.audioPlayer play];
        [self addTimer];
    }
}

- (IBAction)reset:(id)sender {
    NSLog(@"重录");
    if ([self.delegate respondsToSelector:@selector(audiocell:resetAudioBtnClickedWithIndexpath:)]) {
        [self.delegate audiocell:self resetAudioBtnClickedWithIndexpath:self.indexpath];
    }
    self.audioData = nil;
}

-(void)addTimer{
    if (!self.fashImageTimer) {
        self.fashImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(flashImage) userInfo:nil repeats:YES];
        //[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)removeTimer{
    if (self.fashImageTimer!=nil) {
        [self.fashImageTimer invalidate];
        self.fashImageTimer = nil;
    }
}

-(void)flashImage
{
    self.imageIndex ++;
    self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"fs_icon_wave_%d",(int)self.imageIndex%3]];
    self.remainTime-=0.3;
    if (self.remainTime<=0) {
        self.remainTime = 0;
    }
    self.audioDuration.text = [NSString stringWithFormat:@"%.1f秒",self.remainTime];
}

// 当AVAudioPlayer播放完成收将会自动激发该方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    if (player == self.audioPlayer && flag)
    {
        NSLog(@"播放完成！！");
        // 停止播放音频
        [self.audioPlayer stop];
        
        [self removeTimer];
        
        self.remainTime = self.audioPlayer.duration;
        self.audioDuration.text = [NSString stringWithFormat:@"%.1f秒",self.remainTime];
        self.imageIndex = 2;
        self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"fs_icon_wave_%d",(int)self.imageIndex%3]];
    }
}

-(void)setBtnState:(Boolean)hasAudioData
{
    if (hasAudioData) {
        self.recordBtn.hidden = YES;
        self.playBtn.hidden = NO;
        self.signalImage.hidden= NO;
        self.resetBtn.hidden = NO;
    }else{
        self.recordBtn.hidden = NO;
        self.playBtn.hidden = YES;
        self.signalImage.hidden= YES;
        self.resetBtn.hidden = YES;
        self.audioDuration.text = nil;
    }
}

@end
