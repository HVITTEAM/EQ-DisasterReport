//
//  SpotInforModel.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/12.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotInforModel : NSObject
@property(nonatomic,copy)NSString *pointid;
@property(nonatomic,copy)NSString *occurTime;
@property(nonatomic,copy)NSString *lon;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,copy)NSString *phoneNum;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,copy)NSString *descr;
@property(nonatomic,copy)NSString *keys;

@property(nonatomic,copy)NSString *isUpload;

@end