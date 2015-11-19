//
//  VoiceTableHelper.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceTableHelper : NSObject
{
    FMDatabase *db;
    NSString *database_path;
}

+(instancetype)sharedInstance;
/**初始化数据库**/
- (void)initDataBase;
/**创建表**/
- (void)createTable;
-(BOOL)insertDataWithDictionary:(NSDictionary *)dict;
-(NSMutableArray *) selectDataByReleteTable:(NSString *)reltable Releteid:(NSString *)relid;
-(BOOL) deleteVoiceByAttribute:(NSString *)attribute value:(NSString *)value;
-(BOOL) deleteDataByReleteTable:(NSString *)reltable Releteid:(NSString *)relid;
@end
