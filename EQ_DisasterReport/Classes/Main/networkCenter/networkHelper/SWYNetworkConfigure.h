//
//  SWYNetworkConfigure.h
//  EQCollect_HD
//
//  Created by shi on 15/12/7.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#ifndef SWYNetworkConfigure_h
#define SWYNetworkConfigure_h

#define SWYNetworkStatusChangeNotification

typedef NS_ENUM(NSInteger , SWYRequestType) {
    SWYRequestTypeGet = 0,
    SWYRequestTypePost
};

typedef NS_ENUM(NSUInteger, SWYResponseStatus)
{
    SWYResponseStatusSuccess,
    SWYResponseStatusErrorTimeout,
    SWYResponseStatusErrorNoNetwork
};

#define URL_loginaction        @"http://192.168.2.16:9000/sysapi/loginaction"
#define URL_base               @"http://192.168.2.16:9000/eers/"
#define URL_pointinfo          @"http://192.168.2.16:9000/eers/pointinfo"
#define URL_location           @"http://192.168.2.26:9000/eers/location"
#define URL_photoinfo          @"http://192.168.2.16:9000/eers/photoinfo"
#define URL_earthquakeinfo     @"http://192.168.2.16:9000/eers/earthquakeinfo-last"


#endif /* SWYNetworkConfigure_h */
