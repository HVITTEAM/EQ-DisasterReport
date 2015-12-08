//
//  PictureTableHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//


//图片：图片ID(photoid)、拍摄时间(phototime)；
#import "PictureTableHelper.h"
#import "PhotoModel.h"

#define TABLENAME         @"PICTURETABLE"
#define PHOTOID           @"photoid"
#define PHOTOTIME         @"phototime"
#define PHOTONAME         @"photoName"
#define PHOTOPATH         @"photoPath"
#define RELETEID          @"releteid"
//#define RELETETABLE       @"reletetable"

@implementation PictureTableHelper
+(instancetype)sharedInstance
{
    static PictureTableHelper *pictureTableHelper;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pictureTableHelper = [[PictureTableHelper alloc] init];
        [pictureTableHelper initDataBase];
        [pictureTableHelper createTable];
    });
    return pictureTableHelper;
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
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@'INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLENAME,PHOTOID,PHOTOTIME,PHOTONAME,PHOTOPATH,RELETEID];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating photo table");
        } else {
            NSLog(@"success to creating photo table");
        }
        [db close];
    }
}

-(BOOL)insertDataWithDictionary:(NSDictionary *)dict
{
    BOOL res = NO;
    if ([db open]) {
        NSString *sqlInsertStr= [NSString stringWithFormat:
                                 @"INSERT INTO '%@' ('%@', '%@', '%@', '%@')  VALUES ('%@', '%@', '%@', '%@')",TABLENAME, PHOTOTIME,PHOTONAME,PHOTOPATH,RELETEID,dict[@"phototime"],dict[@"photoName"],dict[@"photoPath"], dict[@"releteid"]];
        res = [db executeUpdate:sqlInsertStr];
        if (!res) {
            NSLog(@"error when insert photo table");
        }else{
            NSLog(@"success when insert photo table");
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
                                  @"UPDATE %@ SET %@ = '%@',%@ = '%@', %@='%@' WHERE %@ = '%@' ",TABLENAME,PHOTOTIME,dict[@"phototime"],PHOTONAME,dict[@"photoName"],PHOTOPATH,dict[@"photoPath"],RELETEID,dict[@"releteid"]];
        
        NSLog(@"%@",sqlUpdateStr);
        res = [db executeUpdate:sqlUpdateStr];
        if (!res) {
            NSLog(@"error when update photo table");
        } else {
            NSLog(@"success to update photo table");
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
            NSString * photoid = [rs stringForColumn:PHOTOID];
            NSString * photoName = [rs stringForColumn:PHOTONAME];
            NSString * phototime = [rs stringForColumn:PHOTOTIME];
            NSString * photoPath = [rs stringForColumn:PHOTOPATH];
            NSString * releteid = [rs stringForColumn:RELETEID];
            
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:photoid forKey:@"photoid"];
            [dict setObject:photoName forKey:@"photoName"];
            [dict setObject:phototime forKey:@"phototime"];
            [dict setObject:photoPath forKey:@"photoPath"];
            [dict setObject:releteid forKey:@"releteid"];
            
            [dataCollect addObject:[PhotoModel objectWithKeyValues:dict]];
        }
        [db close];
    }
    
    return dataCollect;
}

/**
 *  从沙盒目录中删除图片并删除数据表中的记录，通常是根据图片名来删除
 *
 *  @param attribute 属性名
 *  @param value     属性值
 *
 *  @return   成功返回 yes，失败返回 no
 */
-(BOOL) deleteImageByAttribute:(NSString *)attribute value:(NSString *)value
{
    BOOL result = YES;
    NSString *picFilepath;
    if ([db open])
    {
        NSString *selectsql = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@='%@'",PHOTOPATH,TABLENAME,attribute,value];
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = '%@'",TABLENAME, attribute, value];
        FMResultSet *rs = [db executeQuery:selectsql];
        while ([rs next]) {
            picFilepath = [rs stringForColumn:PHOTOPATH];
        }
        
        if (picFilepath!=nil) {
            result = [[NSFileManager defaultManager] removeItemAtPath:picFilepath error:nil];
            if (result) {
                result = [db executeUpdate:deleteSql];
                if (!result) {
                    NSLog(@"error when delete photo table");
                } else {
                    NSLog(@"success to delete photo table");
                }
                
            }
        }
        [db close];
    }
    return result;
}

/**
 *  根据releteid，reletetable 字段删除相应的记录,不删除沙盒中的图片
 *
 *  @param reletetable 关联的表名
 *  @param releteid    关联表中某条记录的id
 */
-(BOOL) deleteDataByReleteTable:(NSString *)reltable Releteid:(NSString *)relid
{
    BOOL result = NO;
    if ([db open])
    {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               TABLENAME,RELETEID, relid];
        BOOL res = [db executeUpdate:deleteSql];
        
        if (!res) {
            NSLog(@"error when delete photo table");
            result = NO;
        } else {
            NSLog(@"success to delete photo table");
            result = YES;
        }
        [db close];
    }
    return result;
}

@end
