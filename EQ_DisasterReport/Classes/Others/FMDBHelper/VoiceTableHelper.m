//
//  VoiceTableHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//
//语音：语音ID(voiceid)、语音信息(voiceinfo)、录音时间(voicetime)；
#import "VoiceTableHelper.h"

#define TABLENAME         @"VOICETABLE"
#define VOICEID           @"voiceid"
#define VOICEINFO         @"voiceinfo"
#define VOICETIME         @"voicetime"
#define VOICENAME         @"voiceName"
#define VOICEPATH         @"voicePath"
//#define RELETEID          @"releteid"
//#define RELETETABLE       @"reletetable"

@implementation VoiceTableHelper
+(instancetype)sharedInstance
{
    static VoiceTableHelper *voiceTableHelper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        voiceTableHelper = [[VoiceTableHelper alloc] init];
        [voiceTableHelper initDataBase];
        [voiceTableHelper createTable];
    });
    return voiceTableHelper;
}

-(void)initDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];
}

- (void)createTable
{
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@'INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLENAME,VOICEID,VOICEINFO,VOICETIME,VOICENAME,VOICEPATH];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating voice table");
        } else {
            NSLog(@"success to creating voice table");
        }
        [db close];
    }
}

@end
