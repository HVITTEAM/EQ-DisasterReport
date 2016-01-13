//
//  DateUtil.m
//  EQ_DisasterReport
//
//  Created by shi on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    //设置输入时区
    NSTimeZone *uTCTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0000"];
    [dateFormatter setTimeZone:uTCTimeZone];
    //将输入的时间字符串转成 NSDate 对象
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDateStr];
    
    //设置输出格式格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //设置输出时区
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //转换成字符串
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

+(NSString *)getUTCDateFormateLocalDate:(NSString *)localDateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //设置输入时区
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //将输入的时间字符串转成 NSDate 对象
    NSDate *dateFormatted = [dateFormatter dateFromString:localDateStr];
    
    //设置输出格式格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    //设置输出时区
    NSTimeZone *uTCTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0000"];
    [dateFormatter setTimeZone:uTCTimeZone];
    //转换成字符串
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}


@end
