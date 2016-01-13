//
//  DateUtil.h
//  EQ_DisasterReport
//
//  Created by shi on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

/**
 *  将 UTC 时间转成本地时间(UTC 时间格式需要这种格式:2016-01-12T06:36:09.000Z,转换后的时间格式为:2016-01-12 06:36:09)
 */
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDateStr;

/**
 *  将成本地时间转成UTC时间(输入的本地时间格式为:2016-01-12 06:36:09,转换后的UTC时间格式为:2016-01-12T06:36:09.000Z)
 */
+(NSString *)getUTCDateFormateLocalDate:(NSString *)localDateStr;

@end
