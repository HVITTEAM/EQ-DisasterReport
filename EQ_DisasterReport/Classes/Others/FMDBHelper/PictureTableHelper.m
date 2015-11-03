//
//  PictureTableHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//


//图片：图片ID(photoid)、拍摄时间(phototime)；
#import "PictureTableHelper.h"

#define TABLENAME         @"PICTURETABLE"
#define PHOTOID           @"photoid"
#define PHOTOTIME         @"phototime"
#define PHOTONAME         @"photoName"
#define PHOTOPATH         @"photoPath"
//#define RELETEID          @"releteid"
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
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@'INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT,'%@' TEXT)",TABLENAME,PHOTOID,PHOTOTIME,PHOTONAME,PHOTOPATH];
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"error when creating photo table");
        } else {
            NSLog(@"success to creating photo table");
        }
        [db close];
    }
}

@end
