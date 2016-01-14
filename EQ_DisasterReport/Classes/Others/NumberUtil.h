//
//  NumberUtil.h
//  EQ_DisasterReport
//
//  Created by shi on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberUtil : NSObject

/**
 *  将罗马数字表示的烈度转换成阿拉伯数字表示
 */
+(NSString *)switchRomeNumToNum:(NSString *)romeNum;

/**
 *  将阿拉伯数字表示的烈度转换成罗马数字表示
 */
+(NSString *)switchNumToRomeNumWithNum:(NSInteger)num;

/**
 *  将IndexPath转换成罗马数字表示
 */
+(NSString *)switchIndexPathToRomeNumWithIndexPath:(NSIndexPath *)idx;

/**
 *  判断输入内容是否在指定字符集合中
 */
+(BOOL)validateNumber:(NSString *)numStr filterCondition:(NSString *)filerCondition;

@end
