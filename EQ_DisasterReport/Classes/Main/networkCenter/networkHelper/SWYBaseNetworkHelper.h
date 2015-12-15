//
//  SWYBaseNetworkHelper.h
//  EQCollect_HD
//
//  Created by shi on 15/12/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "SWYNetworkEngine.h"
#import "SWYNetworkConfigure.h"
@class SWYRequestParams;
@class SWYBaseNetworkHelper;

@protocol SWYNetworkCallBackDelegate <NSObject>

@required
- (void)requestDidSuccess:(SWYBaseNetworkHelper *)networkHelper;

- (void)requestDidFailed:(SWYBaseNetworkHelper *)networkHelper;

@end

@protocol SWYNetworkParamSourceDelegate <NSObject>

@required
- (SWYRequestParams *)paramsForRequest:(SWYBaseNetworkHelper *)networkHelper;

@end


@protocol SWYNetworkReformerDelegate <NSObject>

@required
- (id)networkHelper:(SWYBaseNetworkHelper *)networkHelper reformData:(id)data;

@end

@interface SWYBaseNetworkHelper : NSObject

@property (nonatomic, copy,readonly)NSString *url;

@property (nonatomic, assign,readonly)SWYRequestType requestType;

@property (nonatomic, assign, readonly) BOOL isReachable;

@property (nonatomic, assign, readonly) BOOL isLoading;

@property (weak,nonatomic)id<SWYNetworkCallBackDelegate>callBackDelegate;

@property (weak,nonatomic)id<SWYNetworkParamSourceDelegate>paramSource;

-(void)startSendRequest;
-(void)startSendRequestWithParams:(SWYRequestParams *)params;

- (id)fetchDataWithReformer:(id<SWYNetworkReformerDelegate>)reformer;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (void)beforePerformSuccessedCallBackWithResponse:(SWYResponse *)response;
- (void)afterPerformSuccessedCallBackWithResponse:(SWYResponse *)response;

- (void)beforePerformFailedCallBackWithResponse:(SWYResponse *)response;
- (void)afterPerformFailedCallBackWithResponse:(SWYResponse *)response;

- (BOOL)shouldSendRequestWithParams:(SWYRequestParams *)params;
- (void)afterSendRequestWithParams:(SWYRequestParams *)params;

@end
