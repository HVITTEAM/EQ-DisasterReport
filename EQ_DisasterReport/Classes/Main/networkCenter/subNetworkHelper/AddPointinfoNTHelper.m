//
//  AddPointinfoNTHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/14.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AddPointinfoNTHelper.h"

@implementation AddPointinfoNTHelper
-(NSString *)url
{
    return URL_addPointinfo;
}

-(SWYRequestType)requestType
{
    return SWYRequestTypePost;
}
@end
