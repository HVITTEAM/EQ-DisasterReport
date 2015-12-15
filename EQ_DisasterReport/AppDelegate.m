//
//  AppDelegate.m
//  EQ_DisasterReport
//
//  Created by 董徐维 on 15/11/2.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HMControllerTool.h"
#import "MapSearchAPIHelper.h"
#import "LocationNTHelper.h"
#import "SWYRequestParams.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "LoginUser.h"

#define APIKey @"4bc6c5298b30d483ce75d69247d5b2df"
@interface AppDelegate ()<AMapLocationManagerDelegate,MapSearchAPIHelperDelegate,SWYNetworkCallBackDelegate,SWYNetworkReformerDelegate>

@property(strong,nonatomic)AMapLocationManager *locationManager;

@property(strong,nonatomic)MapSearchAPIHelper *searchApiHelper;

@property(strong,nonatomic)LocationNTHelper *locationHelp;

@property(strong,nonatomic)NSTimer *timer;

@property(assign,nonatomic)BOOL shouldAddTimer;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //显示窗口
    [self.window makeKeyAndVisible];
    
    _shouldAddTimer = YES;
    
    //配置key
    [MAMapServices sharedServices].apiKey = APIKey;
    [AMapLocationServices sharedServices].apiKey = APIKey;
    [AMapSearchServices sharedServices].apiKey = APIKey;
    //开启定位
    [self setupLocationManager];
    
    [HMControllerTool setLoginViewController];
    

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

}

-(void)mapSearchAPIHelper:(MapSearchAPIHelper *)searhApiHelper reverseGeocodeSuccess:(NSString *)address
{
    NSDictionary *dict = @{
                           @"address":address,
                           @"latitude":[NSString stringWithFormat:@"%f",self.currentCoordinate.latitude],
                           @"longitude":[NSString stringWithFormat:@"%f",self.currentCoordinate.longitude]
                           };
    SWYRequestParams *params = [[SWYRequestParams alloc] initWithParams:[dict mutableCopy] files:nil];
    [self.locationHelp startSendRequestWithParams:params];
}

#pragma mark SWYNetworkCallBackDelegate
- (void)requestDidSuccess:(SWYBaseNetworkHelper *)networkHelper
{
    id responseData = [networkHelper fetchDataWithReformer:self];
    NSLog(@"AppDelegate  requestDidSuccess   %@",responseData);
}

- (void)requestDidFailed:(SWYBaseNetworkHelper *)networkHelper
{
    
}

#pragma mark SWYNetworkReformerDelegate
- (id)networkHelper:(SWYBaseNetworkHelper *)networkHelper reformData:(id)data
{
    return data;
}


#pragma mark - 定时器方法
-(void)addTimer{
    _searchApiHelper = [[MapSearchAPIHelper alloc] init];
    _searchApiHelper.delegate = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:300 target:_searchApiHelper selector:@selector(reverseGeocodeWithCoordinate) userInfo:nil repeats:YES];
    [_timer fire];
}

-(void)removeTimer{
    [_timer invalidate];
}


#pragma mark - 内部方法
-(void)setupLocationManager{
    _locationManager = [[AMapLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 20.0;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        [_locationManager setAllowsBackgroundLocationUpdates:YES];
        
        [_locationManager startUpdatingLocation];
    }else{
        //失败
        [[[UIAlertView alloc] initWithTitle:@"提醒" message:@"定位失败，请确定是否开启定位功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}


@end
