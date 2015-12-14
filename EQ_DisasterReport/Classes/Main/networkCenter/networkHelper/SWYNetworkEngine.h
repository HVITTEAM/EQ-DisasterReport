//
//  SWYNetworkEngine.h
//  EQCollect_HD
//
//  Created by shi on 15/12/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SWYResponse.h"
#import "SWYNetworkConfigure.h"
@class SWYRequestParams;

typedef void (^networkCallBack)(SWYResponse *response);

@interface SWYNetworkEngine : NSObject

+(instancetype)sharedInstance;

-(NSInteger)startRequestWithURL:(NSString *)url
                    params:(SWYRequestParams *)params
                    requestMethod:(SWYRequestType)requestType
                    success:(networkCallBack)success
                    failure:(networkCallBack)failure;

-(BOOL)isNetworkReachable;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
@end
