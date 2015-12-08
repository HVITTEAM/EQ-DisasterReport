//
//  HMControllerTool.m
//  黑马微博
//
//  Created by apple on 14-7-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMControllerTool.h"
#import "SWYMapViewController.h"
#import "LoginViewController.h"

@implementation HMControllerTool
+ (void)chooseRootViewController
{
    
}

+ (void)setRootViewController
{
    SWYMapViewController *mapVC = [[SWYMapViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //将其设置为当前窗口的跟视图控制器
    window.rootViewController = navVC;
}

+ (void)setLoginViewController
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    //UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    // 切换控制器
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //将其设置为当前窗口的跟视图控制器
    window.rootViewController = loginVC;
}
@end
