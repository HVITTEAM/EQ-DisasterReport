//
//  AMapSearchAPIHelper.m
//  EQ_DisasterReport
//
//  Created by shi on 15/12/15.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "MapSearchAPIHelper.h"
#import "AppDelegate.h"


@interface MapSearchAPIHelper ()<AMapSearchDelegate>

@property(strong,nonatomic)AMapSearchAPI *searchAPi;

@end

@implementation MapSearchAPIHelper

#pragma mark -- getter方法和 setter 方法 --
-(AMapSearchAPI *)searchAPi
{
    if (!_searchAPi) {
        _searchAPi = [[AMapSearchAPI alloc] init];
        _searchAPi.delegate = self;
    }
    return _searchAPi;
}

#pragma mark -- AMapSearchDelegate方法 --
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"SearchRequest失败");
    if ([self.delegate respondsToSelector:@selector(mapSearchAPIHelper:reverseGeocodeFail:)]) {
        [self.delegate mapSearchAPIHelper:self reverseGeocodeFail:@"失败"];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"%@",response.regeocode.formattedAddress);
    if ([self.delegate respondsToSelector:@selector(mapSearchAPIHelper:reverseGeocodeSuccess:)]) {
        [self.delegate mapSearchAPIHelper:self reverseGeocodeSuccess:response.regeocode.formattedAddress];
    }
}

#pragma mark -- 公共方法 --

-(void)reverseGeocodeWithCoordinate
{
    AppDelegate *appdl = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CLLocationCoordinate2D coordinate = appdl.currentCoordinate;

    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [self.searchAPi AMapReGoecodeSearch: regeo];
}


@end
