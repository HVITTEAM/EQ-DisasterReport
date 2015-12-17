//
//  SWYBaseNetworkHelper.m
//  EQCollect_HD
//
//  Created by shi on 15/12/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYBaseNetworkHelper.h"

@interface SWYBaseNetworkHelper ()

@property (nonatomic, strong) NSMutableArray *requestIdList;

@property (nonatomic, strong, readwrite) id rawData;

@end

@implementation SWYBaseNetworkHelper


-(NSMutableArray *)requestIdList
{
    if (!_requestIdList) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

-(BOOL)isReachable
{
   return [[SWYNetworkEngine sharedInstance] isNetworkReachable];
}

-(SWYRequestType)requestType
{
    return SWYRequestTypePost;
}

-(BOOL)isLoading
{
    if (self.requestIdList.count > 0) {
        return YES;
    }
    return NO;
}

-(NSString *)url
{
    return nil;
}

- (id)fetchDataWithReformer:(id<SWYNetworkReformerDelegate>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(networkHelper:reformData:)]) {
        resultData = [reformer networkHelper:self reformData:self.rawData];
    } else {
        resultData = [self.rawData mutableCopy];
    }
    return resultData;
}

-(void)startSendRequest
{
   SWYRequestParams *params = [self.paramSource paramsForRequest:self];
   [self startSendRequestWithParams:params];
}

-(void)startSendRequestWithParams:(SWYRequestParams *)params
{
    BOOL shouldStart = [self shouldSendRequestWithParams:params];
    if (shouldStart) {
        NSInteger requestId = 0;
        if (self.requestType == SWYRequestTypeGet) {
            requestId =[[SWYNetworkEngine sharedInstance]startRequestWithURL:self.url params:params requestMethod:self.requestType success:^(SWYResponse *response) {
                [self callNetworkEngineSuccessed:response];
            } failure:^(SWYResponse *response) {
                [self callNetworkEngineFailed:response];
            }];
        }else if (self.requestType == SWYRequestTypePost){
            requestId = [[SWYNetworkEngine sharedInstance] startRequestWithURL:self.url params:params requestMethod:self.requestType success:^(SWYResponse *response) {
                [self callNetworkEngineSuccessed:response];
            } failure:^(SWYResponse *response) {
                [self callNetworkEngineFailed:response];
            }];
        }
        [self.requestIdList addObject:@(requestId)];
        [self afterSendRequestWithParams:params];
    }else{
        [self callNetworkEngineFailed:nil];
    }
}

-(void)callNetworkEngineSuccessed:(SWYResponse *)response
{
    [self removeRequestIdWithRequestID:response.requestId];
    
    if (response.responseObject) {
        self.rawData = [response.responseObject copy];
    } else {
        self.rawData = [response.responseData copy];
    }
    
    [self beforePerformSuccessedCallBackWithResponse:response];
    
    [self.callBackDelegate requestDidSuccess:self];
    
    [self afterPerformSuccessedCallBackWithResponse:response];
}

-(void)callNetworkEngineFailed:(SWYResponse *)response
{
    [self removeRequestIdWithRequestID:response.requestId];
    
    [self beforePerformFailedCallBackWithResponse:response];
    
    [self.callBackDelegate requestDidFailed:self];
    
    [self afterPerformFailedCallBackWithResponse:response];
}

- (void)cancelAllRequests
{
    [[SWYNetworkEngine sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestIdWithRequestID:requestID];
    [[SWYNetworkEngine sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (void)beforePerformSuccessedCallBackWithResponse:(SWYResponse *)response
{
    NSLog(@"成功回调前");
}

- (void)afterPerformSuccessedCallBackWithResponse:(SWYResponse *)response
{
    NSLog(@"成功回调后");
}

- (void)beforePerformFailedCallBackWithResponse:(SWYResponse *)response
{
    NSLog(@"%d",response.responsestatus);
    NSLog(@"失败回调前");
}

- (void)afterPerformFailedCallBackWithResponse:(SWYResponse *)response
{
    NSLog(@"失败回调后");
}

- (BOOL)shouldSendRequestWithParams:(SWYRequestParams *)params
{
    NSLog(@"是否应该发请求");
    return YES;
}
- (void)afterSendRequestWithParams:(SWYRequestParams *)params
{
    
    NSLog(@"发请求后");
}

@end
