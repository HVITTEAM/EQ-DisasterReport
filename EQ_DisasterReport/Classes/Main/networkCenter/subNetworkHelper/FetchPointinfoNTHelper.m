//
//  FetchPointinfo.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/16.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "FetchPointinfoNTHelper.h"

@implementation FetchPointinfoNTHelper

-(NSString *)url
{
    return [NSString stringWithFormat:@"%@/%@",URL_pointinfo,self.detailUrl];
}

-(SWYRequestType)requestType
{
    return SWYRequestTypeGet;
}

@end
