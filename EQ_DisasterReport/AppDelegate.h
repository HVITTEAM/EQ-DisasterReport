//
//  AppDelegate.h
//  EQ_DisasterReport
//
//  Created by 董徐维 on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) CLLocation *currentLocation;    //用户当前位置


@end

