//
//  SpotTableHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//


//采集点：采集点ID(pointid)、关键字（主题）(keys)、地址(address)、经纬度(lat  lon)、烈度等级(level)、简要描述(description)、采集时间(collecttime)、图片ID(photoid)、语音ID(voiceid)；
#import "SpotTableHelper.h"

#define TABLENAME         @"SPOTTABLE"
#define POINTID           @"pointid"
#define KEYS              @"keys"
#define ADDRESS           @"address"
#define LAT               @"lat"
#define LON               @"lon"
#define LEVEL             @"level"
#define DESCRIPTION       @"description"
#define COLLECTTIME       @"collecttime"
#define PHOTOID           @"photoid"
#define VOICEID           @"voiceid"

@implementation SpotTableHelper
+(instancetype)sharedInstance
{
    static SpotTableHelper *spotTableHelper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        spotTableHelper = [[SpotTableHelper alloc] init];
        [spotTableHelper initDataBase];
        [spotTableHelper createTable];
    });
    return spotTableHelper;
}

-(void)initDataBase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    NSLog(@"%@",database_path);
    
    db = [FMDatabase databaseWithPath:database_path];
}

- (void)createTable
{
    if ([db open]) {
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@'INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT,'%@' TEXT)",TABLENAME,POINTID,KEYS,ADDRESS,LAT,LON,LEVEL,DESCRIPTION,COLLECTTIME,PHOTOID,VOICEID];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating spot table");
        } else {
            NSLog(@"success to creating spot table");
        }
        [db close];
    }
}

@end
