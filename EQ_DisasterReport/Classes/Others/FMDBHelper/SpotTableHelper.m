//
//  SpotTableHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

//采集点：采集点ID(pointid)、关键字（主题）(keys)、地址(address)、经纬度(lat  lon)、烈度等级(level)、简要描述(description)、采集时间(collecttime)、图片ID(photoid)、语音ID(voiceid)；


//发震时刻、经度、纬度、地址、上报手机号、烈度、备注 note
//详细信息描述 descr


#import "SpotTableHelper.h"
#import "SpotInforModel.h"

#define TABLENAME         @"SPOTTABLE"
#define POINTID           @"pointid"
#define OCCURTIME         @"occurTime"
#define LON               @"lon"
#define LAT               @"lat"
#define ADDRESS           @"address"
#define LEVEL             @"level"
#define PHONENUM          @"phoneNum"
#define NOTE              @"note"
#define DESCR             @"descr"
#define KEYS              @"keys"

#define ISUPLOAD          @"isUpload"
//#define DEPTH             @"depth"
//#define COLLECTTIME       @"collecttime"

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
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@'INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLENAME,POINTID,OCCURTIME,LON,LAT,ADDRESS,LEVEL,PHONENUM,NOTE,DESCR,KEYS,ISUPLOAD];
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
        NSString *sqlSelectStr = [NSString stringWithFormat:@"SELECT * FROM %@  ORDER BY pointid DESC",TABLENAME];
        FMResultSet *set = [db executeQuery:sqlSelectStr];
        while ([set next]) {
            NSString * pointid     = [set stringForColumn:POINTID];
            NSString * occurTime = [set stringForColumn:OCCURTIME];
            NSString * lon       = [set stringForColumn:LON];
            NSString * lat       = [set stringForColumn:LAT];
            NSString * address         = [set stringForColumn:ADDRESS];
            NSString * level         = [set stringForColumn:LEVEL];
            NSString * phoneNum     = [set stringForColumn:PHONENUM];
            NSString * note      =    [set stringForColumn:NOTE];
            NSString * descr        = [set stringForColumn:DESCR];
            NSString * keys        = [set stringForColumn:KEYS];
            NSString * isupload        = [set stringForColumn:ISUPLOAD];
            
            NSMutableDictionary *dict = [NSMutableDictionary new];
            
            [dict setObject:pointid forKey:@"pointid"];
            [dict setObject:occurTime forKey:@"occurTime"];
            [dict setObject:lon forKey:@"lon"];
            [dict setObject:lat forKey:@"lat"];
            [dict setObject:address forKey:@"address"];
            [dict setObject:level forKey:@"level"];
            [dict setObject:phoneNum forKey:@"phoneNum"];
            [dict setObject:note forKey:@"note"];
            [dict setObject:descr forKey:@"descr"];
            [dict setObject:keys forKey:@"keys"];
            [dict setObject:isupload forKey:@"isUpload"];
            
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
                         @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@','%@', '%@', '%@', '%@','%@')  VALUES ('%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@','%@')",
                        TABLENAME, OCCURTIME,LON,LAT,ADDRESS,LEVEL,PHONENUM,NOTE,DESCR,KEYS,ISUPLOAD,dict[@"occurTime"],dict[@"lon"],dict[@"lat"], dict[@"address"], dict[@"level"],dict[@"phoneNum"], dict[@"note"], dict[@"descr"],dict[@"keys"],dict[@"isUpload"]];
        
         NSLog(@"------sqlInsertStr-------%@",sqlInsertStr);
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
            @"UPDATE %@ SET %@ = '%@',%@ = '%@', %@='%@', %@='%@', %@='%@', %@='%@', %@='%@', %@='%@',%@='%@',%@='%@' WHERE %@ = '%@' ",TABLENAME,OCCURTIME,dict[@"occurTime"],LON,dict[@"lon"],LAT,dict[@"lat"],ADDRESS,dict[@"address"],LEVEL,dict[@"level"],PHONENUM,dict[@"phoneNum"],NOTE,dict[@"note"],DESCR,dict[@"descr"],KEYS,dict[@"keys"],ISUPLOAD,dict[@"isUpload"],POINTID,dict[@"pointid"]];
        
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


-(BOOL)updateUploadFlag:(NSString *)uploadFlag ID:(NSString *)idString
{
    BOOL result = NO;
    if ([db open]) {
        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@' ",TABLENAME,ISUPLOAD,uploadFlag,POINTID,idString];
        NSLog(@"updateUploadFlag %@",updateSql);
        result = [db executeUpdate:updateSql];
        if (!result) {
            NSLog(@"error when update upload table");
        }else{
            NSLog(@"success to update upload table");
        }
        [db close];
    }
    return result;
}

-(BOOL) deleteDataByAttribute:(NSString *)attribute value:(NSString *)value
{
    BOOL result = NO;
    if ([db open])
    {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               TABLENAME, attribute, value];
        result = [db executeUpdate:deleteSql];
        
        if (!result) {
            NSLog(@"error when delete spot table");
        } else {
            NSLog(@"success to delete spot table");
        }
        [db close];
    }
    return result;
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
