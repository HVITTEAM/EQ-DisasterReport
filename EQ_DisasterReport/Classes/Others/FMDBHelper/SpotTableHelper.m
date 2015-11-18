//
//  SpotTableHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

//采集点：采集点ID(pointid)、关键字（主题）(keys)、地址(address)、经纬度(lat  lon)、烈度等级(level)、简要描述(description)、采集时间(collecttime)、图片ID(photoid)、语音ID(voiceid)；

#import "SpotTableHelper.h"
#import "SpotInforModel.h"

#define TABLENAME         @"SPOTTABLE"
#define POINTID           @"pointid"
#define COLLECTTIME       @"collecttime"
#define LEVEL             @"level"
#define DEPTH             @"depth"
#define LAT               @"lat"
#define LON               @"lon"
#define ADDRESS           @"address"
#define DESCRIPTION       @"descr"
#define KEYS              @"keys"

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
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@'INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLENAME,POINTID,COLLECTTIME,LEVEL,DEPTH,LAT,LON,ADDRESS,DESCRIPTION,KEYS];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating spot table");
        } else {
            NSLog(@"success to creating spot table");
        }
        [db close];
    }
}

-(NSMutableArray *)fetchAllData
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([db open]) {
        NSString *sqlSelectStr = [NSString stringWithFormat:@"SELECT * FROM %@",TABLENAME];
        FMResultSet *set = [db executeQuery:sqlSelectStr];
        while ([set next]) {
            NSString * pointid     = [set stringForColumn:POINTID];
            NSString * collecttime = [set stringForColumn:COLLECTTIME];
            NSString * level       = [set stringForColumn:LEVEL];
            NSString * depth       = [set stringForColumn:DEPTH];
            NSString * lat         = [set stringForColumn:LAT];
            NSString * lon         = [set stringForColumn:LON];
            NSString * address     = [set stringForColumn:ADDRESS];
            NSString * description = [set stringForColumn:DESCRIPTION];
            NSString * keys        = [set stringForColumn:KEYS];
            
            NSMutableDictionary *dict = [NSMutableDictionary new];
            
            [dict setObject:pointid forKey:@"pointid"];
            [dict setObject:collecttime forKey:@"collecttime"];
            [dict setObject:level forKey:@"level"];
            [dict setObject:depth forKey:@"depth"];
            [dict setObject:lat forKey:@"lat"];
            [dict setObject:lon forKey:@"lon"];
            [dict setObject:address forKey:@"address"];
            [dict setObject:description forKey:@"descr"];
            [dict setObject:keys forKey:@"keys"];
            
            [array addObject:[SpotInforModel objectWithKeyValues:dict]];
        }
        
        [db close];
    }
    
    return array;
}

-(BOOL)insertDataWithDictionary:(NSDictionary *)dict
{
    BOOL res = NO;
    if ([db open]) {
        NSString *sqlInsertStr= [NSString stringWithFormat:
                         @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@','%@', '%@', '%@')  VALUES ('%@', '%@','%@', '%@', '%@', '%@', '%@', '%@')",
                        TABLENAME, COLLECTTIME,LEVEL,DEPTH,LAT,LON,ADDRESS,DESCRIPTION,KEYS,dict[@"collecttime"],dict[@"level"],dict[@"depth"], dict[@"lat"], dict[@"lon"],dict[@"address"], dict[@"descr"], dict[@"keys"]];
        res = [db executeUpdate:sqlInsertStr];
        if (!res) {
             NSLog(@"error when insert spot table");
        }else{
             NSLog(@"success when insert spot table");
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
            @"UPDATE %@ SET %@ = '%@',%@ = '%@', %@='%@', %@='%@', %@='%@', %@='%@', %@='%@', %@='%@' WHERE %@ = '%@' ",TABLENAME,COLLECTTIME,dict[@"collecttime"],LEVEL,dict[@"level"],DEPTH,dict[@"depth"],LAT,dict[@"lat"],LON,dict[@"lon"],ADDRESS,dict[@"address"],DESCRIPTION,dict[@"descr"],KEYS,dict[@"keys"],POINTID,dict[@"pointid"]];
        
        NSLog(@"%@",sqlUpdateStr);
        res = [db executeUpdate:sqlUpdateStr];
        if (!res) {
            NSLog(@"error when update db table");
        } else {
            NSLog(@"success to update db table");
        }
        [db close];
    }
    return res;
}

-(NSInteger)getMaxIdOfRecords
{
    NSInteger maxid = 0;
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT MAX(pointid) AS maxid FROM %@ ",TABLENAME];
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            maxid = [rs intForColumn:@"maxid"];
        }
    }
    [db close];
    return maxid;
}

@end
