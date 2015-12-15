//
//  AMapSearchAPIHelper.h
//  EQ_DisasterReport
//
//  Created by shi on 15/12/15.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapLocationKit/AMapLocationKit.h>
@class MapSearchAPIHelper;

@protocol MapSearchAPIHelperDelegate <NSObject>

-(void)mapSearchAPIHelper:(MapSearchAPIHelper *)searhApiHelper reverseGeocodeSuccess:(NSString *)address;

-(void)mapSearchAPIHelper:(MapSearchAPIHelper *)searhApiHelper reverseGeocodeFail:(NSString *)errorMsg;

@end

@interface MapSearchAPIHelper : NSObject

@property(weak,nonatomic)id<MapSearchAPIHelperDelegate>delegate;

-(void)reverseGeocodeWithCoordinate;

@end
