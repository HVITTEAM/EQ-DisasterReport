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

@property(assign,nonatomic,readonly)CGFloat numbersOfEachPage;

@property(assign,nonatomic,readonly)BOOL isFirstPage;     //当前下载的数据是否是第一页的数据

@property(assign,nonatomic,readonly)BOOL isFinshedAllLoad;

-(void)startSendRequestForNextPage;

-(void)resetState;

@end
