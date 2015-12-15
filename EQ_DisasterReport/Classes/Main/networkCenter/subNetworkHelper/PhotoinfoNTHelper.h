//
//  PhotoSetNTHelper.h
//  EQ_DisasterReport
//
//  Created by shi on 15/12/15.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWYBaseNetworkHelper.h"

@interface PhotoinfoNTHelper : SWYBaseNetworkHelper

@property(assign,nonatomic,readonly)NSInteger nextPageNumber;

@property(assign,nonatomic,readonly)NSInteger numbersOfEachPage;

@property(assign,nonatomic,readonly)NSInteger totalNumbers;

@property(assign,nonatomic)BOOL isFirstPage;

-(void)startSendRequestForNextPage;
@end
