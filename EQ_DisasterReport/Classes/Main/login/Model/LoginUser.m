//
//  LoginUser.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/15.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "LoginUser.h"

@implementation LoginUser
+(instancetype)shareInstance
{
    static LoginUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[LoginUser alloc] init];
    });
    return user;
}

@end
