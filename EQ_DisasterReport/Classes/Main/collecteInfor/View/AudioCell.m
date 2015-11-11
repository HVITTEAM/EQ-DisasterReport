//
//  AudioCell.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/11.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AudioCell.h"
@implementation AudioCell

- (void)awakeFromNib {
    // Initialization code
    [self.recordBtn initRecord:self maxtime:60 title:@"单击话筒结束,双击取消"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)endRecord:(NSData *)voiceData{
    
    self.audioData = voiceData;
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc]initWithData:self.audioData error:&error];
    self.audioPlayer.delegate = self;
    NSLog(@"错误%@",error);
    self.audioPlayer.volume = 1.0f;
    
    self.audioDuration.text = [NSString stringWithFormat:@"%.1f秒",self.audioPlayer.duration];
    
    
   if ([self.delegate respondsToSelector:@selector(audioCell:finishRecod:)]) {
        [self.delegate audioCell:self finishRecod:voiceData];
    }
    [self.recordBtn setTitle:@"点击录音" forState:UIControlStateNormal];
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
    
    //NSLog(@"时长%f",play.duration);
}


-(void)addTimer{
    if (!self.fashImageTimer) {
        self.fashImageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flashImage) userInfo:nil repeats:YES];
        //[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)removeTimer{
    if (self.fashImageTimer!=nil) {
        [self.fashImageTimer invalidate];
        self.fashImageTimer = nil;
        self.imageIndex = 0;
        self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"fs_icon_wave_%d",0]];
    }
}

-(void)flashImage
{
    self.signalImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"fs_icon_wave_%lu",self.imageIndex%3]];
    self.imageIndex ++;
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
        
    }
}




@end
