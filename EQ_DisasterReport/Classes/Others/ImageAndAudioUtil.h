//
//  ImageAndAudioUtil.h
//  EQ_DisasterReport
//
//  Created by shi on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioVO;


@interface ImageAndAudioUtil : NSObject

/**
 * 保存图片
 **/
+(void)saveImages:(NSArray *)images releteId:(NSString *)releteID releteTable:(NSString *)releteTable;

/**
 * 获取图片
 **/
+(NSMutableArray *)getImagesWithReleteId:(NSString *)releteID releteTable:(NSString *)releteTable;

/**
 *  保存声音
 **/
+(void)saveVoice:(AudioVO *)audioVO releteId:(NSString *)releteID releteTable:(NSString *)releteTable;

/**
 *  获取声音
 **/
+(AudioVO *)getVoiceWithReleteId:(NSString *)releteID releteTable:(NSString *)releteTable;

@end
