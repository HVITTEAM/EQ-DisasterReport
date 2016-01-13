//
//  AppDelegate.m
//  EQ_DisasterReport
//
//  Created by 董徐维 on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AppDelegate.h"
#import "HMControllerTool.h"
#import "MapSearchAPIHelper.h"
#import "LocationNTHelper.h"
#import "SWYRequestParams.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "LoginUser.h"
#import "APService.h"

@interface AppDelegate ()<AMapLocationManagerDelegate,MapSearchAPIHelperDelegate,SWYNetworkCallBackDelegate,SWYNetworkReformerDelegate>

@property(strong,nonatomic)AMapLocationManager *locationManager;        //高德定位管理器

@property(strong,nonatomic)MapSearchAPIHelper *searchApiHelper;         //用于将经纬度转换成地址

@property(strong,nonatomic)LocationNTHelper *locationHelp;              //上传接口对象

@property(strong,nonatomic)NSTimer *timer;                              //定时器

@property(assign,nonatomic)BOOL shouldAddTimer;                         //是否要添加定时器

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //显示窗口
    [self.window makeKeyAndVisible];

    //配置地图相关key
    [MAMapServices sharedServices].apiKey = AMapAPIKey;
    [AMapLocationServices sharedServices].apiKey = AMapAPIKey;
    [AMapSearchServices sharedServices].apiKey = AMapAPIKey;
    
    //极光推送:向系统注册远程推送通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    //极光推送:初始化
    [APService setupWithOption:launchOptions];
    
    //开启定位
    [self setupLocationManager];
    
    //显示登录界面
    [HMControllerTool setLoginViewController];
    
    self.shouldAddTimer = YES;
    
    //徽标归零
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //向服务器上报Device Token
    [APService registerDeviceToken:deviceToken];
    
    //格式化deviceToken
    //NSString *deviceTokenStr = [[NSString stringWithFormat:@"%@",deviceToken] substringWithRange:NSMakeRange(1,[NSString stringWithFormat:@"%@",deviceToken].length - 2)];
    NSLog(@"My token is: %@",deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // 处理收到的APNS消息，向服务器上报收到APNS消息
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - getter 方法
-(LocationNTHelper *)locationHelp
{
    if (!_locationHelp) {
        _locationHelp = [[LocationNTHelper alloc] init];
        _locationHelp.callBackDelegate = self;
    }
    return _locationHelp;
}


#pragma mark - MALocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    NSLog(@"定位成功%f    %f",location.coordinate.latitude,location.coordinate.longitude);
    self.currentCoordinate = location.coordinate;
    if (_shouldAddTimer) {
        if ([[LoginUser shareInstance].login_status isEqualToString:@"success"]) {
            //开启定时发送位置信息功能
            [self addTimer];
            _shouldAddTimer = NO;
        }
    }
}

#pragma mark - MapSearchAPIHelperDelegate

-(void)mapSearchAPIHelper:(MapSearchAPIHelper *)searhApiHelper reverseGeocodeFail:(NSString *)errorMsg
{
    NSLog(@"逆地理编码失败");
}

-(void)mapSearchAPIHelper:(MapSearchAPIHelper *)searhApiHelper reverseGeocodeSuccess:(NSString *)address
{
    NSDictionary *dict = @{
                           @"address":address,
                           @"latitude":[NSString stringWithFormat:@"%f",self.currentCoordinate.latitude],
                           @"longitude":[NSString stringWithFormat:@"%f",self.currentCoordinate.longitude]
                           };
    //创建请求参数，发送请求
    SWYRequestParams *params = [[SWYRequestParams alloc] initWithParams:[dict mutableCopy] files:nil];
    [self.locationHelp startSendRequestWithParams:params];
}

#pragma mark SWYNetworkCallBackDelegate
- (void)requestDidSuccess:(SWYBaseNetworkHelper *)networkHelper
{
    id responseData = [networkHelper fetchDataWithReformer:self];
    NSLog(@"---------AppDelegate  requestDidSuccess   %@",responseData);
}

- (void)requestDidFailed:(SWYBaseNetworkHelper *)networkHelper
{
     NSLog(@"--------AppDelegate  requestDidFailed");
}

#pragma mark SWYNetworkReformerDelegate
- (id)networkHelper:(SWYBaseNetworkHelper *)networkHelper reformData:(id)data
{
    return data;
}

#pragma mark - 定时器方法
-(void)addTimer{
    self.searchApiHelper = [[MapSearchAPIHelper alloc] init];
    self.searchApiHelper.delegate = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self.searchApiHelper selector:@selector(reverseGeocodeWithCoordinate) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)removeTimer{
    [self.timer invalidate];
}


#pragma mark - 内部方法，启动定位功能
-(void)setupLocationManager{
    self.locationManager = [[AMapLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 20.0;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        
        [self.locationManager startUpdatingLocation];
    }else{
        //失败
        [[[UIAlertView alloc] initWithTitle:@"提醒" message:@"定位失败，请确定是否开启定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}

@end
