//
//  LoginUser.h
//  EQ_DisasterReport
//
//  Created by shi on 15/12/15.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUser : NSObject

@property(copy,nonatomic)NSString *loginname;

@property(copy,nonatomic)NSString *username;

@property(strong,nonatomic)NSNumber *userid;

@property(copy,nonatomic)NSString *login_status;

@property(copy,nonatomic)NSString *station;

+(instancetype)shareInstance;

@end
