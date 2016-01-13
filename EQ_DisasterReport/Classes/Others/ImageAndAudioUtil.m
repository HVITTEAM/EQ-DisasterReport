//
//  ImageAndAudioUtil.m
//  EQ_DisasterReport
//
//  Created by shi on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ImageAndAudioUtil.h"
#import "PictureVO.h"
#import "PhotoModel.h"
#import "PictureTableHelper.h"
#import "AudioVO.h"
#import "VoiceModel.h"

@implementation ImageAndAudioUtil

/**
 * 保存图片
 **/
+(void)saveImages:(NSArray *)images releteId:(NSString *)releteID releteTable:(NSString *)releteTable
{
    //保存图片
    for (int i = 0; i < images.count ; i++)
    {
        if ([images[i] isKindOfClass:[PictureVO class]])
        {
            PictureVO *pVO = (PictureVO*)images[i];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", pVO.name]];
            BOOL result = [pVO.imageData writeToFile: filePath atomically:YES]; // 写入本地沙盒
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
            if (result)
            {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      pVO.name,@"photoName",
                                      currentDate,@"phototime",
                                      filePath,@"photoPath",
                                      releteID,@"releteid",
                                      nil];
                //保存数据库
                [[PictureTableHelper sharedInstance] insertDataWithDictionary:dict];
            }
        }
    }
}

/**
 * 获取图片
 **/
+(NSMutableArray *)getImagesWithReleteId:(NSString *)releteID releteTable:(NSString *)releteTable
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    //获取符合条件的所有图片的相关的信息
    NSMutableArray * pictureModes= [[PictureTableHelper sharedInstance] selectDataByReleteTable:releteTable
                                                                                       Releteid:releteID];
    //循环添加图片
    for(PhotoModel* pic in pictureModes)
    {
        PictureVO *vo = [[PictureVO alloc] init];
        vo.name = pic.photoName;
        vo.photoTime = pic.phototime;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", pic.photoName]];
        vo.imageData = [NSData dataWithContentsOfFile:filePath];
        [images addObject:vo];
    }
    return images;
}

/**
 *  保存声音
 **/
+(void)saveVoice:(AudioVO *)audioVO releteId:(NSString *)releteID releteTable:(NSString *)releteTable
{
    if (!audioVO.audioData||audioVO.audioData.length<=0) {
        return;
    }
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *voiceTime = [dateFormatter stringFromDate:[NSDate date]];
    
    //获取保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", audioVO.name]];
    // 写入本地沙盒
    BOOL result = [audioVO.audioData writeToFile: filePath atomically:YES];
    if (result) {
        //向数据库保存声音相关信息
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              audioVO.name,@"voiceName",
                              voiceTime,@"voicetime",
                              filePath,@"voicePath",
                              @"voiceinfo",@"voiceinfo",
                              releteID,@"releteid",
                              nil];
        [[VoiceTableHelper sharedInstance] insertDataWithDictionary:dict];
    }
}

/**
 *  获取声音
 **/
+(AudioVO *)getVoiceWithReleteId:(NSString *)releteID releteTable:(NSString *)releteTable
{
    NSMutableArray * voiceModes= [[VoiceTableHelper sharedInstance] selectDataByReleteTable:releteTable
                                                                                   Releteid:releteID];
    if (voiceModes.count>0) {
        AudioVO *audioVO = [[AudioVO alloc] init];
        VoiceModel *voiceModel = (VoiceModel *)voiceModes[0];
        NSData *voicedata = [NSData dataWithContentsOfFile:voiceModel.voicePath];
        audioVO.audioData = voicedata;
        audioVO.name = voiceModel.voiceName;
        audioVO.audioTime = voiceModel.voicetime;
        return audioVO;
    }
    return nil;
}


@end
