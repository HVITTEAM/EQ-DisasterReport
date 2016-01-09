//
//  NSObject+Extension.h
//  EQ_DisasterReport
//
//  Created by shi on 15/12/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

/**
 *  验证数据是否为 NSNull，如果是则返回 nil 否则返回本身
 */
-(id)validateDataIsNull;

@end
