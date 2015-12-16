//
//  FetchPointinfo.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/16.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "FetchPointinfo.h"

@implementation FetchPointinfo

-(NSString *)url
{
    return URL_pointinfo;
}

-(SWYRequestType)requestType
{
    return SWYRequestTypeGet;
}

@end
