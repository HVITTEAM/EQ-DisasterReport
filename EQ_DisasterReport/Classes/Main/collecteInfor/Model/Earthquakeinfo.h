//
//  Earthquakeinfo.h
//  EQ_DisasterReport
//
//  Created by shi on 16/1/12.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Earthquakeinfo : NSObject

@property(assign,nonatomic) NSInteger earthquakeid;

@property(strong,nonatomic) NSString *earthquakename;

@property(strong,nonatomic) NSString *earthquaketime;

@property(strong,nonatomic) NSString *eqid;

@end
