//
//  SharedAppUtil.m
//  EQ_DisasterReport
//
//  Created by shi on 16/1/13.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SharedAppUtil.h"

@implementation SharedAppUtil

+(instancetype)sharedInstance
{
    static SharedAppUtil *shareUtil = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareUtil = [[SharedAppUtil alloc] init];
    });
    
    return shareUtil;
}

@end
