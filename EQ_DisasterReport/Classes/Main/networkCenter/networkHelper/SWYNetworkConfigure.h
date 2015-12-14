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


#define URL_loginaction   @"http://192.168.2.17:9000/sysapi/loginaction"
#define URL_addPointinfo  @"http://192.168.2.17:9000/eers/pointinfo"
#define URL_location      @"http://192.168.2.17:9000/eers/location"


#endif /* SWYNetworkConfigure_h */
