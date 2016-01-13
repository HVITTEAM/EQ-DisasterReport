//
//  NumberUtil.m
//  EQ_DisasterReport
//
//  Created by shi on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "NumberUtil.h"

@implementation NumberUtil

+(NSString *)switchRomeNumToNum:(NSString *)romeNum
{
    NSArray *romes = @[@"Ⅰ",@"Ⅱ",@"Ⅲ",@"Ⅳ",@"Ⅴ",@"Ⅵ",@"Ⅶ",@"Ⅷ",@"Ⅸ",@"Ⅹ",@"Ⅺ",@"Ⅻ"];
    NSUInteger num = [romes indexOfObject:romeNum];
    if (num == NSNotFound) {
        return nil;
    }
    return [NSString stringWithFormat:@"%d",(int)(num+1)];
}

+(NSString *)switchNumToRomeNumWithNum:(NSInteger)num
{
    if (num <= 0) {
        return nil;
    }
    NSArray *romes = @[@"Ⅰ",@"Ⅱ",@"Ⅲ",@"Ⅳ",@"Ⅴ",@"Ⅵ",@"Ⅶ",@"Ⅷ",@"Ⅸ",@"Ⅹ",@"Ⅺ",@"Ⅻ"];
    return romes[num - 1];
}

+(NSString *)switchIndexPathToRomeNumWithIndexPath:(NSIndexPath *)idx
{
    NSArray *romes = @[@"Ⅰ",@"Ⅱ",@"Ⅲ",@"Ⅳ",@"Ⅴ",@"Ⅵ",@"Ⅶ",@"Ⅷ",@"Ⅸ",@"Ⅹ",@"Ⅺ",@"Ⅻ"];
    return romes[idx.row];
}

@end
