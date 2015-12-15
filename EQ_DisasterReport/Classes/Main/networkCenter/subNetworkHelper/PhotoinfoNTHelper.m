//
//  PhotoSetNTHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/15.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "PhotoinfoNTHelper.h"

@interface PhotoinfoNTHelper ()

@property(assign,nonatomic,readwrite)NSInteger nextPageNumber;

@property(assign,nonatomic,readwrite)NSInteger numbersOfEachPage;

@property(assign,nonatomic,readwrite)NSInteger totalNumbers;

@end

@implementation PhotoinfoNTHelper

-(instancetype)init
{
    self = [super init];
    if (self) {
        _nextPageNumber = 1;
        _numbersOfEachPage = 10;
        _isFirstPage = YES;
    }
    return self;
}

-(NSString *)url
{
    return URL_photoinfo;
}

-(SWYRequestType)requestType
{
    return SWYRequestTypeGet;
}

-(void)startSendRequestForNextPage
{
    if (self.isLoading) {
        return;
    }
    
    NSInteger totalPage = ceil(self.totalNumbers / self.numbersOfEachPage);
    if (totalPage >= 1 && self.nextPageNumber <= totalPage) {
        [self startSendRequest];
    }
}

- (void)beforePerformSuccessedCallBackWithResponse:(SWYResponse *)response
{
    [super beforePerformSuccessedCallBackWithResponse:response];
    self.nextPageNumber++;
    self.totalNumbers = [((NSDictionary *)response.responseObject)[@"total"] integerValue];
    NSLog(@"PhotoinfoNTHelper  总数据条数%d",(int)self.totalNumbers);
}


- (void)beforePerformFailedCallBackWithResponse:(SWYResponse *)response
{
    [super beforePerformFailedCallBackWithResponse:response];
//    if (self.nextPageNumber > 0) {
//        self.nextPageNumber --;
//    }
}

@end
