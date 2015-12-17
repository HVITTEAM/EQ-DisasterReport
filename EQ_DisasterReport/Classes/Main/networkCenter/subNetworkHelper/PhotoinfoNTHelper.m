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

@property(assign,nonatomic,readwrite)CGFloat numbersOfEachPage;

@property(assign,nonatomic,readwrite)NSInteger totalNumbers;

@property(assign,nonatomic,readwrite)BOOL isFirstPage;

@property(assign,nonatomic,readwrite)BOOL isFinshedAllLoad;

@end

@implementation PhotoinfoNTHelper

-(instancetype)init
{
    self = [super init];
    if (self) {
        _nextPageNumber = 1;
        _numbersOfEachPage = 15.0;
        _isFirstPage = YES;
        _isFinshedAllLoad = NO;
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
    
    self.isFirstPage = NO;
    
    NSInteger totalPage = ceil(self.totalNumbers / self.numbersOfEachPage);
    if (totalPage >= 1 && self.nextPageNumber <= totalPage) {
        [self startSendRequest];
    }
}

- (void)beforePerformSuccessedCallBackWithResponse:(SWYResponse *)response
{
    [super beforePerformSuccessedCallBackWithResponse:response];
    
    self.totalNumbers = [((NSDictionary *)response.responseObject)[@"total"] integerValue];
    
    NSInteger totalPage = ceil(self.totalNumbers / self.numbersOfEachPage);
    
    if (self.nextPageNumber == totalPage) {
        self.isFinshedAllLoad = YES;
    }
    
    self.nextPageNumber++;
    
    NSLog(@"PhotoinfoNTHelper  总数据条数%d 总共有几页%d 当前数据是第几页%d",(int)self.totalNumbers,(int)totalPage,(int)(self.nextPageNumber-1));
}


- (void)beforePerformFailedCallBackWithResponse:(SWYResponse *)response
{
    [super beforePerformFailedCallBackWithResponse:response];
//    if (self.nextPageNumber > 0) {
//        self.nextPageNumber --;
//    }
}

-(void)resetState
{
    self.nextPageNumber = 1;
    self.numbersOfEachPage = 15.0;
    self.isFirstPage = YES;
    self.isFinshedAllLoad = NO;
}

@end
