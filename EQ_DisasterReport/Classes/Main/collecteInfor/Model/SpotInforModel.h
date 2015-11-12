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
@property(nonatomic,copy)NSString *collecttime;
@property(nonatomic,copy)NSString *level;
@property(nonatomic,copy)NSString *depth;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lon;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *descr;
@property(nonatomic,copy)NSString *keys;
@end
