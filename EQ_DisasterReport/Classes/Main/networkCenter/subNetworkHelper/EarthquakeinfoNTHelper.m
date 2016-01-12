//
//  EarthquakeinfoNTHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 16/1/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EarthquakeinfoNTHelper.h"

@implementation EarthquakeinfoNTHelper

-(NSString *)url
{
    return URL_earthquakeinfo;
}

-(SWYRequestType)requestType
{
    return SWYRequestTypeGet;
}

@end
