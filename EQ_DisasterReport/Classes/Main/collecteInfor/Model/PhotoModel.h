//
//  PhotoModel.h
//  EQ_DisasterReport
//
//  Created by shi on 15/11/18.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject
@property(copy,nonatomic)NSString *photoid;
@property(copy,nonatomic)NSString *phototime;
@property(copy,nonatomic)NSString *photoName;
@property(copy,nonatomic)NSString *photoPath;
@property(copy,nonatomic)NSString *releteid;
@end
