//
//  SWYResponse.m
//  EQCollect_HD
//
//  Created by shi on 15/12/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYResponse.h"

@implementation SWYResponse

-(instancetype)initWithResponseString:(NSString *)responseString responseObject:(id)responseObject responseData:(NSData *)responseData request:(NSURLRequest *)request requestId:(NSInteger)requestId
{
    self = [super init];
    if (self) {
        _responseString = responseString;
        _responseObject = responseObject;
        _responseData = responseData;
        _request = request;
        _responsestatus = SWYResponseStatusSuccess;
        _requestId = requestId;
        
        //从服务器返回的数据，没有进行过缓存
        _isCache = NO;
    }
    return self;
}

-(instancetype)initWithResponseString:(NSString *)responseString responseObject:(id)responseObject responseData:(NSData *)responseData request:(NSURLRequest *)request requestId:(NSInteger)requestId error:(NSError *)error
{
    self = [super init];
    if (self) {
        _responseString = responseString;
        _responseObject = responseObject;
        _responseData = responseData;
        _request = request;
        _responsestatus = [self responseStatusWithError:error];
        _requestId = requestId;
        
        //从服务器返回的数据，没有进行过缓存
        _isCache = NO;
    }
    return self;
}

-(SWYResponseStatus)responseStatusWithError:(NSError *)error
{
    NSLog(@"%@",error);
    if (error) {
        SWYResponseStatus result = SWYResponseStatusErrorNoNetwork;
        
        if (error.code == NSURLErrorTimedOut) {
            result = SWYResponseStatusErrorTimeout;
        }
        return result;
    } else {
        return SWYResponseStatusSuccess;
    }
}

@end
