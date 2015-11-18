//
//  VoiceTableHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//
//语音：语音ID(voiceid)、语音信息(voiceinfo)、录音时间(voicetime)；
#import "VoiceTableHelper.h"
#import "VoiceModel.h"

#define TABLENAME         @"VOICETABLE"
#define VOICEID           @"voiceid"
#define VOICEINFO         @"voiceinfo"
#define VOICETIME         @"voicetime"
#define VOICENAME         @"voiceName"
#define VOICEPATH         @"voicePath"
#define RELETEID          @"releteid"
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
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@'INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLENAME,VOICEID,VOICEINFO,VOICETIME,VOICENAME,VOICEPATH,RELETEID];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating voice table");
        } else {
            NSLog(@"success to creating voice table");
        }
        [db close];
    }
}

-(BOOL)insertDataWithDictionary:(NSDictionary *)dict
{
    BOOL res = NO;
    if ([db open]) {
        NSString *sqlInsertStr= [NSString stringWithFormat:
                                @"INSERT INTO '%@' ('%@', '%@', '%@', '%@','%@')  VALUES ('%@','%@', '%@', '%@', '%@')",TABLENAME, VOICEINFO,VOICETIME,VOICENAME,VOICEPATH,RELETEID,dict[@"voiceinfo"],dict[@"voicetime"],dict[@"voiceName"], dict[@"voicePath"], dict[@"releteid"]];
        res = [db executeUpdate:sqlInsertStr];
        if (!res) {
            NSLog(@"error when insert voice table");
        }else{
            NSLog(@"success when insert voice table");
        }
        [db close];
    }
    return res;
}

-(BOOL)updateDataWithDictionary:(NSDictionary *)dict
{
    BOOL res = NO;
    if ([db open])
    {
        NSString *sqlUpdateStr = [NSString stringWithFormat:
                                  @"UPDATE %@ SET %@ = '%@',%@ = '%@', %@='%@', %@='%@', %@='%@' WHERE %@ = '%@' ",TABLENAME,VOICEINFO,dict[@"voiceinfo"],VOICETIME,dict[@"voicetime"],VOICENAME,dict[@"voiceName"],VOICEPATH,dict[@"voicePath"],RELETEID,dict[@"releteid"],VOICEID,dict[@"voiceid"]];
        
        NSLog(@"%@",sqlUpdateStr);
        res = [db executeUpdate:sqlUpdateStr];
        if (!res) {
            NSLog(@"error when update voice table");
        } else {
            NSLog(@"success to update voice table");
        }
        [db close];
    }
    return res;
}


/**
 *  根据releteid，reletetable 字段查询相应的语音
 *
 *  @param reletetable 关联的表名
 *  @param releteid    关联表中某条记录的id
 */
-(NSMutableArray *) selectDataByReleteTable:(NSString *)reltable Releteid:(NSString *)relid
{
    NSMutableArray *dataCollect = [[NSMutableArray alloc] init];
    if ([db open])
    {
        NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@ where %@ = '%@' ",TABLENAME,RELETEID,relid];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next])
        {
            NSString * voiceid = [rs stringForColumn:VOICEID];
            NSString * voiceinfo = [rs stringForColumn:VOICEINFO];
            NSString * voicetime = [rs stringForColumn:VOICETIME];
            NSString * voiceName = [rs stringForColumn:VOICENAME];
            NSString * voicePath = [rs stringForColumn:VOICEPATH];
            NSString * releteid = [rs stringForColumn:RELETEID];
            
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:voiceid forKey:@"voiceid"];
            [dict setObject:voiceinfo forKey:@"voiceinfo"];
            [dict setObject:voicetime forKey:@"voicetime"];
            [dict setObject:voiceName forKey:@"voiceName"];
            [dict setObject:voicePath forKey:@"voicePath"];
            [dict setObject:releteid forKey:@"releteid"];
            
            [dataCollect addObject:[VoiceModel objectWithKeyValues:dict]];
        }
        [db close];
    }
    
    return dataCollect;
}

@end

