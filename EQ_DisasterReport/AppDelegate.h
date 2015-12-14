//
//  AppDelegate.h
//  EQ_DisasterReport
//
//  Created by 董徐维 on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic) CLLocationCoordinate2D  currentCoordinate;    //用户当前经纬度

-(void)addTimer;
-(void)removeTimer;

@end

