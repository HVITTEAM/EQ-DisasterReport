//
//  PictureTableHelper.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureTableHelper : NSObject
{
    FMDatabase *db;
    NSString *database_path;
}

+(instancetype)sharedInstance;
/**初始化数据库**/
- (void)initDataBase;
/**创建表**/
- (void)createTable;
@end
