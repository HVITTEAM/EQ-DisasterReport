//
//  SWYNetworkEngine.m
//  EQCollect_HD
//
//  Created by shi on 15/12/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYNetworkEngine.h"
#import "SWYRequestParams.h"
#import "SWYMultipartFormObject.h"

@interface SWYNetworkEngine ()
@property (nonatomic,strong)AFHTTPRequestOperationManager *magager;
@property (nonatomic,strong)AFHTTPRequestOperation *requesOperatin;
@property (nonatomic,strong) NSMutableDictionary *requestsRecord;
@property (nonatomic,strong) NSNumber *requestId;
@end

@implementation SWYNetworkEngine

+(instancetype)sharedInstance
{
    static SWYNetworkEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[SWYNetworkEngine alloc] init];
        [engine monitoringNetWorkStatus];
    });
    return engine;
}

- (AFHTTPRequestOperationManager *)magager
{
    if (!_magager) {
        _magager = [AFHTTPRequestOperationManager manager];
        _magager.requestSerializer.timeoutInterval = [self timeoutInterval];
    }
    return _magager;
}

-(NSTimeInterval)timeoutInterval
{
    return 30;
}

-(NSMutableDictionary *)requestsRecord
{
    if (!_requestsRecord) {
        _requestsRecord = [[NSMutableDictionary alloc] init];
    }
    return _requestsRecord;
}

-(NSInteger)startRequestWithURL:(NSString *)url params:(SWYRequestParams *)params requestMethod:(SWYRequestType)requestType success:(networkCallBack)success failure:(networkCallBack)failure
{
    NSNumber *reqId = [self generateRequestId];
    
    if (requestType == SWYRequestTypeGet) {
        
        self.requesOperatin = [self.magager GET:url parameters:params.userParams success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            //get 成功
            [self handleSuccess:operation object:responseObject success:success requestId:reqId];
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            //get 失败
            [self handleFailure:operation error:error failure:failure requestId:reqId];
        }];
        
    }else{
        
        SWYMultipartFormDataBlock block = [params getMultiFormDataBlock];
        if (block) {
            self.requesOperatin = [self.magager POST:url parameters:params.userParams constructingBodyWithBlock:block success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                //post 图片成功
                [self handleSuccess:operation object:responseObject success:success requestId:reqId];
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                //post 图片失败
                [self handleFailure:operation error:error failure:failure requestId:reqId];
            }];
        }else{
            NSLog(@"SWYNetworkEngine %@  --  %@",url,params.userParams);
            self.requesOperatin = [self.magager POST:url parameters:params.userParams success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                //post 成功
                [self handleSuccess:operation object:responseObject success:success requestId:reqId];
            } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                //post 失败
                [self handleFailure:operation error:error failure:failure requestId:reqId];
            }];
        }
        
    }
    self.requestsRecord[reqId] = self.requesOperatin;
    return [reqId integerValue];
}

-(void)handleSuccess:(AFHTTPRequestOperation *)operation object:(id)responseObject success:(networkCallBack)success requestId:reqId
{
    AFHTTPRequestOperation *op = self.requestsRecord[_requestId];
    if (op == nil) {
        // 如果这个operation是被cancel的，那就不用处理回调了。
        return;
    } else {
        [self.requestsRecord removeObjectForKey:_requestId];
    }

    if (success) {
        SWYResponse *response = [[SWYResponse alloc]initWithResponseString:operation.responseString
                                                            responseObject:responseObject
                                                              responseData:operation.responseData
                                                                   request:operation.request];
        success(response);
    }
}

-(void)handleFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error failure:(networkCallBack)failure requestId:reqId
{
    
    AFHTTPRequestOperation *op = self.requestsRecord[_requestId];
    if (op == nil) {
        // 如果这个operation是被cancel的，那就不用处理回调了。
        return;
    } else {
        [self.requestsRecord removeObjectForKey:_requestId];
    }
    
    if (failure) {
        SWYResponse *response = [[SWYResponse alloc] initWithResponseString:operation.responseString
                                                             responseObject:nil
                                                               responseData:operation.responseData
                                                                    request:operation.request
                                                                      error:error];
        failure(response);
    }
}

- (NSNumber *)generateRequestId
{
    if (_requestId == nil) {
        _requestId = @(1);
    } else {
        if ([_requestId integerValue] == NSIntegerMax) {
            _requestId = @(1);
        } else {
            _requestId = @([_requestId integerValue] + 1);
        }
    }
    return _requestId;
}

-(void)monitoringNetWorkStatus{
    
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    //网络变化时的回调方法
    [self.magager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"没有网络连接，请检查您的网络！");
            return ;
        }else{
            NSLog(@"有网络连接");
        }
    }];
    [self.magager.reachabilityManager startMonitoring];
}

-(BOOL)isNetworkReachable
{
    AFNetworkReachabilityStatus status = self.magager.reachabilityManager.networkReachabilityStatus;
    if (status == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    return YES;
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSOperation *requestOperation = self.requestsRecord[requestID];
    [requestOperation cancel];
    [self.requestsRecord removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}


@end
