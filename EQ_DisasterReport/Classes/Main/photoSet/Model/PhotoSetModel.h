//
//  PhotoSetModel.h
//  EQ_DisasterReport
//
//  Created by shi on 15/12/15.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoSetModel : NSObject

@property(copy,nonatomic)NSString *thumbpath;

@property(copy,nonatomic)NSString *photopath;

@property(strong,nonatomic)NSNumber *pointid;

@property(copy,nonatomic)NSString *address;

@end
