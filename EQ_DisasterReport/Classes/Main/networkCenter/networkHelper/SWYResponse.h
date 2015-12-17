//
//  SWYResponse.h
//  EQCollect_HD
//
//  Created by shi on 15/12/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWYNetworkConfigure.h"

@interface SWYResponse : NSObject
@property (nonatomic, assign, readonly) SWYResponseStatus responsestatus;   //这个 Response 的状态，成功，失败：超时和网络问题
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSString *responseString;
@property (nonatomic, copy, readonly) id responseObject;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, assign, readonly) BOOL isCache;              //这个 Response 是否已经缓存过

//@property (nonatomic, assign, readonly) NSInteger requestId;
//@property (nonatomic, copy) NSDictionary *requestParams;

- (instancetype)initWithResponseString:(NSString *)responseString
                        responseObject:(id)responseObject
                          responseData:(NSData *)responseData
                               request:(NSURLRequest *)request
                             requestId:(NSInteger)requestId;

- (instancetype)initWithResponseString:(NSString *)responseString
                        responseObject:(id)responseObject
                          responseData:(NSData *)responseData
                               request:(NSURLRequest *)request
                             requestId:(NSInteger)requestId
                                 error:(NSError *)error;

@end
