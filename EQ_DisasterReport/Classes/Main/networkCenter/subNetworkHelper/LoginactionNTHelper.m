//
//  LoginactionNetworkHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/14.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "LoginactionNTHelper.h"


@implementation LoginactionNTHelper

-(NSString *)url
{
    return URL_loginaction;
}

-(SWYRequestType)requestType
{
    return SWYRequestTypePost;
}

@end
