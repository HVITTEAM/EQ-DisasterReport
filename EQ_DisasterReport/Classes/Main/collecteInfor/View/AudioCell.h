//
//  AudioCell.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/11.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3RecordButton.h"

@protocol AudioCellDelegate;

@interface AudioCell : UITableViewCell<D3RecordDelegate,AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet D3RecordButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIImageView *signalImage;
@property (weak, nonatomic) IBOutlet UILabel *audioDuration;
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
@property (nonatomic,weak)id<AudioCellDelegate>delegate;

@property (nonatomic,strong)NSData *audioData;
@property (nonatomic,strong)NSTimer *fashImageTimer;
@property (nonatomic,assign)NSUInteger imageIndex;
@end

@protocol AudioCellDelegate <NSObject>

-(void)audioCell:(AudioCell *)audioCell finishRecod:(NSData *)voiceData;
@end